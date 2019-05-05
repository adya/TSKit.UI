/// - Since: 01/20/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

/// A set of methods extending `UITableView`.
/// - Since: 11/08/2017
/// - Author: AdYa
public extension UITableView {
    
    /// Forces `UITableView` to recalculate it's `contentSize` therefore to update cell heights.
    /// Changes displayed immediately with animations.
    /// - Parameter updates: A closure performing any additional updates to the `UITableView` in the same animation transaction.
    public func update(_ updates: ((UITableView) -> Void)? = nil) {
        beginUpdates()
        updates?(self)
        endUpdates()
    }

}
