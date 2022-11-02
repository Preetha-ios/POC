import Foundation

protocol ViewCoordinatorType {
    associatedtype ViewModel
    associatedtype View: CoordinateableView
    var view: View? { get set }
    func updateView(with viewModel: ViewModel)

    func onViewDidLoad()
    func onUpdate(startDate: String?, endDate: String?)
    func onViewWillAppear()
    func onViewWillDisappear()
}
