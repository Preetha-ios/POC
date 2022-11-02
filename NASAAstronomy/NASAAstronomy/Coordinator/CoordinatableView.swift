import Foundation

protocol CoordinateableView: AnyObject {
    associatedtype ViewModel
    associatedtype ViewCoordinator: ViewCoordinatorType
    var coordinator: ViewCoordinator? { get }
    func bindViewModel(_ model: ViewModel)
    func handleError(error: Error)
}
