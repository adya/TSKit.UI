// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

/// `PageViewController`'s base delegate which provides a couple of methods to report state changes of the `PageViewController`.
public protocol PageViewControllerBaseDelegate: class {
    /**
     Called when `pageController` finished initialization and has been embedded.
     
     - Parameter pageController: `PageViewController` which triggers the delegate.
     - Parameter controller: `UIPageViewController` which has been embedded.
     - Parameter view: Content view into which `controller` has been embedded.
     */
    func pageController(_ pageController : PageViewController, didEmbed controller : UIPageViewController, to contentView : UIView)
}

/// `PageViewController`'s delegate which provides a couple of methods to report state changes of the `PageViewController`.
public protocol PageViewControllerDelegate: PageViewControllerBaseDelegate {
    
    /**
     Called whenever user begins swiping of the page.
     
     - Note: This method is optional.
     
     - Parameter pageController: `PageViewController` which triggers the delegate.
     - Parameter controller: `UIViewController` which `pageController` will show.
     - Parameter index: Index of target `controller`.
     
     - Attention: Do not use this method to handle page switching. (See notes).
     
     - Note: When this method is called `pageController` still hasn't switched current page to target `UIViewController`. This means that user may cancel the swipe and therefore page won't be switched. However target `UIViewController` will be partially visible to user during swipe animation.
     
     - Important: In case swipe has been canceled `pageController` will call `pageController(_:, didCancelShowViewController:, forPageAt:) with currently displayed controller.
     */
    func pageController(_ pageController : PageViewController, willShow controller : UIViewController, forPageAt index : Int)
    
    /**
     Called whenever `pageController` switched to new page.
     
     - Note: This method is optional.
     
     - Parameter pageController: `PageViewController` which triggers the delegate.
     - Parameter controller: `UIViewController` which `pageController` did show.
     - Parameter index: Index of displayed `controller`.
     */
    func pageController(_ pageController : PageViewController, didShow controller : UIViewController, forPageAt index : Int)
    
    /**
     Called whenever `pageController` was switching to new page, but canceled the switch.
     
     - Note: This method is optional.
     
     - Parameter pageController: `PageViewController` which triggers the delegate.
     - Parameter controller: `UIViewController` switching to which `pageController` did cancel.
     - Parameter index: Index of canceled `controller`.
     */
    func pageController(_ pageController : PageViewController, didCancelShow controller : UIViewController, forPageAt index : Int)
    
}

// MARK: - Default implementation for PageViewControllerDelegate

public extension PageViewControllerBaseDelegate {
    func pageController(_ pageController : PageViewController, didEmbed controller : UIPageViewController, to contentView : UIView) {}
}

public extension PageViewControllerDelegate {
    func pageController(_ pageController : PageViewController, willShow controller : UIViewController, forPageAt index : Int) {}
    func pageController(_ pageController : PageViewController, didShow controller : UIViewController, forPageAt index : Int) {}
    func pageController(_ pageController : PageViewController, didCancelShow controller : UIViewController, forPageAt index : Int) {}
}
#endif
