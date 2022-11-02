import Foundation

class PictureCollectionViewCoordinator: ViewCoordinator<PictureCollectionViewController, [PlanetaryAPOD]> {
    
    private let apiService: APIServiceType
    private var startDate: String?
    private var endDate: String?
    private(set) var viewModel: [PlanetaryAPOD]
    
    init(apiService: APIServiceType = APIServices()) {
        
        self.apiService = apiService
        self.viewModel = []
    }
    
    private func setupOnViewReady() {
        fetchPics()
    }
    
    override func onViewDidLoad() {
        setupOnViewReady()
    }
    
    override func onUpdate(startDate: String?, endDate: String?) {
        self.startDate = startDate
        self.endDate = endDate
        fetchPics()
    }
    
    override func updateView(with viewModel: [PlanetaryAPOD]) {
        saveToUserDefaults(viewModel: viewModel)
        view?.bindViewModel(viewModel)
    }
    
    func fetchPics() {
        if !URLSession.connectedToNetwork() {
            updateView(with: fetchFromUserDefaults())
            print("No internet")
            return
        }
        
        apiService.fetchPics(from: startDate ?? "2022-09-01", end_date: endDate ?? "2022-09-10", completion: { result in
            switch result {
            case .success(let response):
                self.updateView(with: response)
            case .failure(let error):
                self.view?.handleError(error: error)
            }
        })
    }
    
    func saveToUserDefaults(viewModel: [PlanetaryAPOD]) {
        let userDefaults = UserDefaults.standard
        do {
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: viewModel, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "ViewModel")
        }
        catch {
            print("Error")
        }
    }
    
    func fetchFromUserDefaults() -> [PlanetaryAPOD] {
        do {
            guard let decoded = UserDefaults.standard.object(forKey: "ViewModel") as? Data else {
                return []
            }
            if let model = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [PlanetaryAPOD] {
                return model
            }
            return []
        } catch (let error){
            print("Failed : \(error.localizedDescription)")
        }
        return []
    }
}
