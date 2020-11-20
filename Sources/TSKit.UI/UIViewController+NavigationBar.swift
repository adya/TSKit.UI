import UIKit

public extension UIViewController {
    
    var isNavigationBarBorderHidden: Bool {
        get {
            return navigationController?.navigationBar.shadowImage == nil
        }
        set {
            if newValue {
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                navigationController?.navigationBar.shadowImage = UIImage()
            } else {
                navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
                navigationController?.navigationBar.shadowImage = nil
            }
        }
    }
    
    /// Makes navigation bar fully transparent by removing its background, borders and shadows.
    func setNavigationBarTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }
}
