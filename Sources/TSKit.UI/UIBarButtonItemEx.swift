// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

public extension UIBarButtonItem {

    private struct AssociatedObject {
        static var actionHandlerKey = "actionHandler"
    }

    /// A closure that is associated with `UIBarButtonItem`'s action and will be called upon receiving the `action`.
    var actionHandler: ((UIBarButtonItem) -> Void)? {
        get {
            objc_getAssociatedObject(self, &AssociatedObject.actionHandlerKey) as? (UIBarButtonItem) -> Void
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObject.actionHandlerKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            target = self
            action = #selector(didPress)
        }
    }

    @objc private func didPress(_ sender: UIBarButtonItem) {
        actionHandler?(sender)
    }
}
#endif
