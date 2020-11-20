// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

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
