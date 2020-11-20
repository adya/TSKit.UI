// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

import UIKit

public extension UIViewController {

    /// Embeds passed `UIViewController` into current `UIViewController`.
    /// - Parameter controller: Screen to be embedded into `UIViewController`.
    /// - Parameter view: `UIView` for storing embedding screen.
    func embed(controller: UIViewController, into view: UIView) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[content]|",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["content": controller.view!]) +
                          NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]|",
                                                         options: [],
                                                         metrics: nil,
                                                         views: ["content": controller.view!])

        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: self)
    }

    /// Removes `self` from parent `UIViewController` to which `self` aws embedded.
    /// - Note: Has no effect if `self` is not embedded.
    func unembed() {
        removeFromParent()
        view.removeFromSuperview()
    }
}
