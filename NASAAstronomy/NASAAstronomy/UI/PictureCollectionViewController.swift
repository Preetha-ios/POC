import UIKit

class PictureCollectionViewController: UICollectionViewController, CoordinateableView {
    
    internal var coordinator: ViewCoordinator<PictureCollectionViewController, [PlanetaryAPOD]>?
    private let picker: UIDatePicker = UIDatePicker()
    internal var dataSource = CollectionViewDataSource(viewModel: [])
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPicker()
        configureCoordinator()
        setupProgressLoader()
    }
    
    func bindViewModel(_ model: [PlanetaryAPOD]) {
        dataSource = CollectionViewDataSource(viewModel: model)
        dataSource.collectionViewDelegate = self
        refreshUI()
    }
    
    func handleError(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Private methods
    
    private func configureCoordinator() {
        coordinator = PictureCollectionViewCoordinator()
        coordinator?.view = self
        coordinator?.onViewDidLoad()
    }
    
    private func refreshUI() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.activityIndicator.stopAnimating()
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        }
    }
    
    private func setupProgressLoader() {
        activityIndicator.center = view.center
        view.isUserInteractionEnabled = false
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setupPicker() {
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x: 0.0, y: view.frame.size.height - 200 , width: pickerSize.width, height: 200)
        picker.isHidden = true
        self.view.addSubview(picker)
    }
    
    // MARK: Action methods
    
    @objc private func dueDateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: sender.date)
        
        let button = self.view.viewWithTag(sender.tag) as? UIButton
        button?.setTitle(date, for: .normal)
        
        let startButton = self.view.viewWithTag(10) as? UIButton
        let endButton = self.view.viewWithTag(11) as? UIButton
        
        let startDate = startButton?.currentTitle == "Start Date" ? nil : startButton?.currentTitle
        let endDate = endButton?.currentTitle == "End Date" ? nil : endButton?.currentTitle
        
        coordinator?.onUpdate(startDate: startDate, endDate: endDate)
    }
}

extension PictureCollectionViewController: CollectionViewDelegate {
    
    func startDateTapped(button: UIButton) {
        picker.isHidden = false
        picker.tag = button.tag
    }
    
    func endDateTapped(button: UIButton) {
        picker.isHidden = false
        picker.tag = button.tag
    }
}
