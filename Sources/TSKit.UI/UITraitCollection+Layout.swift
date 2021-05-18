// - Since: 05/18/2021
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

public extension UITraitCollection {

    /// Flag that indicates whether given trait collection corresponds to regular layout in both dimensions (iPad layout).
    ///
    /// This layout is asscoiated with iPads.
    var isRegularLayout: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    /// Flag that indicates whether given trait collection corresponds to regular layout in horizontal dimension.
    ///
    /// This layout is asscoiated with iPads and iPhones Max in landscape orientation.
    var isLandscapeRegularLayout: Bool {
        horizontalSizeClass == .regular
    }

    /// Flag that indicates whether given trait collection corresponds to compact layout in vertical dimension.
    ///
    /// This layout is asscoiated with standard iPhones in any orientation or iPhones Max in portrait orientation.
    var isCompactLayout: Bool {
        verticalSizeClass == .compact
    }
}
#endif
