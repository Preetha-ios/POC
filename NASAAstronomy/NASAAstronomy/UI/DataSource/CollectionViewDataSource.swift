import UIKit

protocol CollectionViewDelegate: AnyObject {
    func startDateTapped(button: UIButton)
    func endDateTapped(button: UIButton)
}

final class CollectionViewDataSource: NSObject {
    var viewModel: [PlanetaryAPOD] = []
    weak var collectionViewDelegate: CollectionViewDelegate?

    init(viewModel: [PlanetaryAPOD] = []) {
        self.viewModel = viewModel
    }
}

extension CollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! PictureCollectionViewCell
        cell.pictureTitleLabel.text = viewModel[indexPath.row].title
        cell.imageView.loadImageUsingCache(withUrl: viewModel[indexPath.row].url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(PhotoHeaderView.self)",
                for: indexPath)

            guard let photoHeaderView = headerView as? PhotoHeaderView
            else { return headerView }

            photoHeaderView.delegate = self
            return photoHeaderView

        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension CollectionViewDataSource: PhotoHeaderViewDelegate {
    func startDateTapped(button: UIButton) {
        collectionViewDelegate?.startDateTapped(button: button)
    }
    
    func endDateTapped(button: UIButton) {
        collectionViewDelegate?.endDateTapped(button: button)
    }
}
