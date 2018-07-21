import UIKit

public extension UISplitViewController {

    var masterViewController: UIViewController? {
        get {
            return viewControllers.first
        }
    }

    var detailViewController: UIViewController? {
        get {
            return viewControllers.count > 1 ? viewControllers[1] : nil
        }
    }
}
