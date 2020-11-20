import UIKit
import AVFoundation
import Photos

final class CameraPreviewViewController: UIViewController {

    private let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Capture", for: .normal)
        return button
    }()

    private var session: AVCaptureSession?
    private let photoOutput: AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        output.isHighResolutionCaptureEnabled = true
        return output
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        captureButton.addTarget(self, action: #selector(onCaptureButton(_:)), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCamera()
    }

    @objc func onCaptureButton(_ sender: UIButton) {
        photoOutput.capturePhoto(with: {
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .off
            settings.isHighResolutionPhotoEnabled = true
            return settings
        }(), delegate: self)
    }

    private func startCamera() {
        func previewCamera(_ frame: CGRect, output: AVCapturePhotoOutput) {
            guard !(session?.isRunning ?? false) else { return }
            let deviceInput: AVCaptureDeviceInput? = {
                guard let captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else { return .none }
                guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return .none }
                return deviceInput
            }()
            guard let _deviceInput = deviceInput else { return }
            session = {
                let session = AVCaptureSession()
                session.sessionPreset = .hd1920x1080
                session.addInput(_deviceInput)
                session.addOutput(output)
                session.commitConfiguration()
                return session
            }()
            guard let _session = session else { return }
            view.layer.addSublayer({
                let previewLayer = AVCaptureVideoPreviewLayer(session: _session)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = frame
                return previewLayer
            }())
            view.bringSubviewToFront(captureButton)
            guard !_session.isRunning else { return }
            _session.startRunning()
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        /// The user has previously granted access to the camera
        case .authorized: previewCamera(view.bounds, output: photoOutput)

        /// The user has not yet been asked for camera access
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                guard granted else { return }
                DispatchQueue.main.async {
                    previewCamera(self.view.bounds, output: self.photoOutput)
                }
            }

        /// The user has declined access
        case .denied: break

        /// The user can't grant access due to restrictions
        /// The access is restricted possibly because of parental control, etc
        case .restricted: break
        default: break
        }
    }

    private func stopCamera() {
        guard let _session = session else { return }
        guard _session.isRunning else { return }
        _session.stopRunning()
    }

}

extension CameraPreviewViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        func savePhoto(_ data: Data) {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data, options: .none)
            } completionHandler: { isSuccess, error in
                guard !isSuccess else { return }
                print("save error: \(String(describing: error))")
            }
        }
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                guard let photoData = photo.fileDataRepresentation() else { return }
                savePhoto(photoData)

            default: break
            }
        }
    }

}
