import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    
    func start()
}

protocol SubCoordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    
    func start(in parentCoordinator: any Coordinator, present: Bool, onCompletion: (() -> Void)?)
}
