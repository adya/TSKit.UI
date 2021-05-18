// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

/// A set of methods extending `UITableView`.
public extension UITableView {
    
    /// Forces `UITableView` to recalculate it's `contentSize` therefore to update cell heights.
    /// Changes displayed immediately with animations.
    /// - Parameter updates: A closure performing any additional updates to the `UITableView` in the same animation transaction.
    func update(_ updates: ((UITableView) -> Void)? = nil) {
        beginUpdates()
        updates?(self)
        endUpdates()
    }
}
#endif
