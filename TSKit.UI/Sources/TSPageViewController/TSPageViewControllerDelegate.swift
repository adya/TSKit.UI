/// `TSPageViewController`'s base delegate which provides a couple of methods to report state changes of the `TSPageViewController`.
public protocol TSPageViewControllerBaseDelegate {
    /**
    Called when `pageController` finished initialization and has been embedded.

    - Parameter pageController: `TSPageViewController` which triggers the delegate.
    - Parameter controller: `UIPageViewController` which has been embedded.
    - Parameter view: Content view into which `controller` has been embedded.
    */
    func pageController(_ pageController : TSPageViewController, didEmbed controller : UIPageViewController, to contentView : UIView)
}

/// `TSPageViewController`'s delegate which provides a couple of methods to report state changes of the `TSPageViewController`.
public protocol TSPageViewControllerDelegate: TSPageViewControllerBaseDelegate {

    /**
     Called whenever user begins swiping of the page.
     
     - Note: This method is optional.
     
     - Parameter pageController: `TSPageViewController` which triggers the delegate.
     - Parameter controller: `UIViewController` which `pageController` will show.
     - Parameter index: Index of target `controller`.
     
     - Attention: Do not use this method to handle page switching. (See notes).
     
     - Note: When this method is called `pageController` still hasn't switched current page to target `UIViewController`. This means that user may cancel the swipe and therefore page won't be switched. However target `UIViewController` will be partially visible to user during swipe animation.
     
     - Important: In case swipe has been canceled `pageController` will call `pageController(_:, didCancelShowViewController:, forPageAt:) with currently displayed controller.
     */
    func pageController(_ pageController : TSPageViewController, willShow controller : UIViewController, forPageAt index : Int)

    /**
     Called whenever `pageController` switched to new page.
     
     - Note: This method is optional.
     
     - Parameter pageController: `TSPageViewController` which triggers the delegate.
     - Parameter controller: `UIViewController` which `pageController` did show.
     - Parameter index: Index of displayed `controller`.
     */
    func pageController(_ pageController : TSPageViewController, didShow controller : UIViewController, forPageAt index : Int)

    /**
     Called whenever `pageController` was switching to new page, but canceled the switch.
     
     - Note: This method is optional.
     
     - Parameter pageController: `TSPageViewController` which triggers the delegate.
     - Parameter controller: `UIViewController` switching to which `pageController` did cancel.
     - Parameter index: Index of canceled `controller`.
     */
    func pageController(_ pageController : TSPageViewController, didCancelShow controller : UIViewController, forPageAt index : Int)

}

// MARK: - Default implementation for TSPageViewControllerDelegate

public extension TSPageViewControllerBaseDelegate {
    func pageController(_ pageController : TSPageViewController, didEmbed controller : UIPageViewController, to contentView : UIView) {}
}

public extension TSPageViewControllerDelegate {
    func pageController(_ pageController : TSPageViewController, willShow controller : UIViewController, forPageAt index : Int) {}
    func pageController(_ pageController : TSPageViewController, didShow controller : UIViewController, forPageAt index : Int) {}
    func pageController(_ pageController : TSPageViewController, didCancelShow controller : UIViewController, forPageAt index : Int) {}
}