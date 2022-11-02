import UIKit

extension PictureCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FullPictureViewController") as? FullPictureViewController
        guard let fullImageVC = viewController else { return }
        self.navigationController?.pushViewController(fullImageVC, animated: true)
        fullImageVC.loadView()
        fullImageVC.loadDetails(with: dataSource.viewModel[indexPath.item])
    }
}
