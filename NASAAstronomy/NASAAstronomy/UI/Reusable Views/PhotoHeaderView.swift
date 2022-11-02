import UIKit

protocol PhotoHeaderViewDelegate: AnyObject {
    func startDateTapped(button: UIButton)
    func endDateTapped(button: UIButton)
}

class PhotoHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    weak var delegate: PhotoHeaderViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startButton.tag = 10
        endButton.tag = 11
    }
    
    // MARK: Action methods
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            delegate?.startDateTapped(button: button)
        }
    }
    
    @IBAction func endButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            delegate?.endDateTapped(button: button)
        }
    }
}
