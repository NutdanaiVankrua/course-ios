import UIKit

class ViewController: UIViewController {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: .none
        )
    }()
    private var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        callService("S=onic")
//        postService()
    }


    /// Example of making a .GET request
    /// Caution of Percent-encoding/URL encoding
    private func callService(_ searchTerm: String) {
        dataTask?.cancel()

        /// Proper way of building query search
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "itunes.apple.com"
            components.path = "/search"
            components.queryItems = [
                .init(name: "media", value: "music"),
                .init(name: "entity", value: "song"),
                .init(name: "term", value: searchTerm)
            ]
            return components.url!
        }

        /// Bad example of creating query search from string directly
        /// Doesn't handle URL encoding properly
//        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else { return }
//        urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
//        guard let url = urlComponents.url else { return }

        dataTask = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            defer {
                self?.dataTask = .none
            }
            if let error = error {
                print("error :: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else {
                print("error :: status code :: \(response.statusCode)")
                return
            }
            guard let data = data else { return }
            let result = String(decoding: data, as: UTF8.self)
            DispatchQueue.main.async {
                print("success :: \(result)")
            }
        })
        dataTask?.resume()
    }

    /// Example of making a .POST request
    private func postService() {
        dataTask?.cancel()
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "itunes.apple.com"
            components.path = "/search"
            return components.url!
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONEncoder().encode(SomeRequest(username: "test", password: "1234")) else { return }
        request.httpBody = httpBody

        dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            defer {
                self?.dataTask = .none
            }
            if let error = error {
                print("error :: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            guard let data = data else { return }
            let result = String(decoding: data, as: UTF8.self)
            DispatchQueue.main.async {
                print("success :: \(result)")
            }
        }
        dataTask?.resume()
    }

}

extension ViewController: URLSessionDelegate {

    /// Example of server trust evaluation
    /// Use cases:
    /// [1] development server that uses a self-signed certificate, which doesn't match any
    ///     in the system's trust store
    /// [2] "pin" your app to a set of specific keys or certificates under your control,
    ///     rather than accept any valid credential
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        func checkValidity(of: SecTrust) -> Bool {
            let bundleCert = Certificates.localhost
            let serverCert = SecTrustGetCertificateAtIndex(of, 0)
            let bundleCertData = SecCertificateCopyData(bundleCert) as NSData
            let serverCertData = SecCertificateCopyData(serverCert!) as NSData
            return serverCertData.isEqual(to: bundleCertData as Data)
        }
        print("URLAuthenticationChallenge :: didReceive")
        let protectionSpace = challenge.protectionSpace
        guard protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust, protectionSpace.host.contains("itunes.apple.com") else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        guard let serverTrust = protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        if checkValidity(of: serverTrust) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

}

struct SomeRequest: Encodable {
    let username: String
    let password: String
}

struct Certificates {

    static let localhost = Certificates.certificate(filename: "localhost")

    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "der")! /// .pem, .cer, ...
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        return certificate
    }
}
