import UIKit

final class ViewControllerA: UIViewController {

    @IBOutlet weak var nextButton: UIButton!

    @IBAction func onNextButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Screen B", sender: .none)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Screen B" {
            let viewControllerB = segue.destination as! ViewControllerB
            viewControllerB.displayText = "From Screen A"
        }
    }

}

final class ViewControllerB: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var openModal: UIButton!

    var displayText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = displayText
    }

    @IBAction func onOpenModalButton(_ sender: UIButton) {
        performSegue(withIdentifier: "Screen C", sender: .none)
    }

}

final class ViewControllerC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

