import UIKit

public extension UIViewController {

    /// Embeds passed `UIViewController` into current `UIViewController`.
    /// - Parameter controller: Screen to be embeded into `UIViewController`.
    /// - Parameter view: `UIView` for storing embedding screen.
    func embed(controller: UIViewController, into view: UIView) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[content]|",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["content" : controller.view]) +
                            NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["content" : controller.view])

        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParentViewController: self)
    }

    /// Removes `self` from parent `UIViewController` to which `self` aws embedded.
    /// - Note: Has no effect if `self` is not embedded.
    func unembed() {
        removeFromParentViewController()
        view.removeFromSuperview()
    }

}
