import UIKit
import AVFoundation
import LocalAuthentication

class ViewController: UIViewController {

    private let openCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Camera", for: .normal)
        return button
    }()

    private let biometricsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Biometrics", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.addArrangedSubview(openCameraButton)
            stack.addArrangedSubview(biometricsButton)
            return stack
        }()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        openCameraButton.addTarget(self, action: #selector(onCameraButton(_:)), for: .touchUpInside)
        biometricsButton.addTarget(self, action: #selector(onBiometricsButton(_:)), for: .touchUpInside)
    }

    @objc func onCameraButton(_ sender: UIButton) {
        present(CameraPreviewViewController(), animated: true, completion: .none)
    }

    @objc func onBiometricsButton(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in") { success, error in
                if success {
                    print("authen success")
                } else {
                    guard let _error = error else { return }
                    print("authen fail :: \(_error)")
                }
            }
        } else {
            guard let _error = error else { return }
            print("error :: \(_error)")
        }
    }

}
