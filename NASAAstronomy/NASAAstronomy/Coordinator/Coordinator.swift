import Foundation
class ViewCoordinator<T: CoordinateableView, U>: ViewCoordinatorType {

    weak var view: T?

    func updateView(with viewModel: U) {
        fatalError("Must be overriden by subclass")
    }

    func onViewDidLoad() {
        fatalError("Must be overriden by subclass")
    }

    func onViewWillAppear() {
        fatalError("Must be overriden by subclass")
    }

    func onViewWillDisappear() {
        fatalError("Must be overriden by subclass")
    }
    
    func onUpdate(startDate: String?, endDate: String?) {
        fatalError("Must be overriden by subclass")
    }
}
