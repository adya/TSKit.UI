// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

public extension UIViewController {

    /// Finds the top most `controller` that is being presented modally from `self` or any controllers presented from `self`.
    var topMostPresentedController: UIViewController {
        UIViewController.topMostPresentedController(in: self)
    }

    private static func topMostPresentedController(in controller: UIViewController) -> UIViewController {
        controller.presentedViewController.flatMap(topMostPresentedController(in:)) ?? controller
    }
}
#endif
