import UIKit

final class ViewControllerA: UIViewController {

    private let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Modal", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(buttonNext)
        NSLayoutConstraint.activate([
            buttonNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonNext.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        buttonNext.addTarget(self, action: #selector(onButtonNext(_:)), for: .touchUpInside)
    }

    @objc func onButtonNext(_ sender: UIButton) {
        present(ViewControllerB(), animated: true) {
            print("ViewControllerA :: presentingViewController :: \(self.presentingViewController)")
            print("ViewControllerA :: presentedViewController :: \(self.presentedViewController)")
        }
    }
}

final class ViewControllerB: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        print("ViewControllerB :: presentingViewController :: \(presentingViewController)")
        print("ViewControllerB :: presentedViewController :: \(presentedViewController)")
    }

}
