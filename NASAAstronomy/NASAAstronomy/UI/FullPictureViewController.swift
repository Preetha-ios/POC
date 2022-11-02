import UIKit

class FullPictureViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicTaken: UILabel!
    @IBOutlet weak var explanationLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadDetails(with details: PlanetaryAPOD) {
        navigationItem.title = details.title
        imageView.loadImageUsingCache(withUrl: details.url)
        datePicTaken.text = details.date
        explanationLabel.text = details.explanation
    }
}
