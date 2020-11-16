import UIKit

class ViewControllerA: UIViewController {
    private let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
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
        let viewControllerB = UIViewController()
        viewControllerB.title = "Screen B"
        viewControllerB.view.backgroundColor = .white
        navigationController?.pushViewController(viewControllerB, animated: true)
    }
}

