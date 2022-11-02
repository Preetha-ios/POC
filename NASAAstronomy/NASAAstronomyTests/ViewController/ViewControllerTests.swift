import XCTest
@testable import NASAAstronomy

class ViewControllerTests: XCTestCase {

    var viewController: PictureCollectionViewController?
    func test_collectionViewSectionsCount() {
        viewController = makeSUT(with: [])
        XCTAssert(viewController?.collectionView.numberOfSections == 1)
    }
}

extension ViewControllerTests {
    
    func makeSUT(with viewModel: [PlanetaryAPOD]) -> PictureCollectionViewController {
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PictureCollectionViewController") as? PictureCollectionViewController
        
        viewController?.loadView()
        viewController?.dataSource = CollectionViewDataSource(viewModel: viewModel)
        return viewController!
    }
}
