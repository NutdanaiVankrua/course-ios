import UIKit

final class ViewControllerA: UIViewController {

    let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Screen B", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Screen A"
        view.backgroundColor = .white
        view.addSubview(buttonNext)
        NSLayoutConstraint.activate([
            buttonNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonNext.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        buttonNext.addTarget(self, action: #selector(onButtonNext(_:)), for: .touchUpInside)
    }

    @objc func onButtonNext(_ sender: UIButton) {
        navigationController?.pushViewController(ViewControllerB(), animated: true)
    }
}

final class ViewControllerB: UIViewController {

    let buttonBefore: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Screen C", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Screen B"
        view.backgroundColor = .white
        let vStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [buttonBefore, buttonNext])
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        buttonBefore.addTarget(self, action: #selector(onBeforeButton(_:)), for: .touchUpInside)
        buttonNext.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
    }

    @objc func onBeforeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func onNextButton(_ sender: UIButton) {
        navigationController?.pushViewController(ViewControllerC(), animated: true)
    }
}

final class ViewControllerC: UIViewController {

    let buttonBefore: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let buttonModal: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Screen D Modal", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let buttonJump: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Jump Screen A", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Screen C"
        view.backgroundColor = .white
        let vStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [buttonBefore, buttonModal, buttonJump])
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        buttonBefore.addTarget(self, action: #selector(onBeforeButton(_:)), for: .touchUpInside)
        buttonModal.addTarget(self, action: #selector(onButtonModal(_:)), for: .touchUpInside)
        buttonJump.addTarget(self, action: #selector(onButtonJump(_:)), for: .touchUpInside)
    }

    @objc func onBeforeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func onButtonModal(_ sender: UIButton) {
        /// Presents a view controller modally.
        present(ViewControllerD(), animated: true, completion: .none)
    }

    @objc func onButtonJump(_ sender: UIButton) {
        guard let screenA = navigationController?.viewControllers.first(where: { $0 is ViewControllerA }) else { return }
        navigationController?.popToViewController(screenA, animated: true)
    }
}

final class ViewControllerD: UIViewController {

    let buttonBefore: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Screen D"
        view.backgroundColor = .white
        view.addSubview(buttonBefore)
        NSLayoutConstraint.activate([
            buttonBefore.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonBefore.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        buttonBefore.addTarget(self, action: #selector(onButtonBefore(_:)), for: .touchUpInside)
    }

    @objc func onButtonBefore(_ sender: UIButton) {
        /// Dismiss modal
        dismiss(animated: true, completion: .none)
    }
}
