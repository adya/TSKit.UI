// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit
import TSKit_Core

/// Makes any `UIViewController` identifiable by its class name.
extension UIViewController : Identifiable {}

/// Makes any `UIView` identifiable by its class name.
extension UIView : Identifiable {}


// MARK: - UIViewController instantiation
public extension UIStoryboard {
    
    /**
     * Instantiates and returns the view controller of given `type` using that `type` as identifier.
     * You use this method to create view controller objects that you want to manipulate and present programmatically in your application.
     * - Note: This method creates a new instance of the specified view controller each time you call it.
     * - Parameter type: Type of the view controller to be instantiated.
     * - Important: Before you can use this method to retrieve a view controller, you must explicitly tag it with an identifier string matching view controller's type in Interface Builder.
     *
     *   ## Example:
     *   Let's assume you have following view controller:
     *   ```
     *   class ExampleViewController: UIViewController { }
     *   ```
     *   In order to instantiate it like this:
     *   ```
     *   storyboard.instantiateViewController(ofType: ExampleViewController.self)
     *   ```
     *   you should tag corresponding view controller in Interface Builder with identifier `ExampleViewController` in the `Storyboard` you are referencing to.
     * - Returns: The view controller of given `type`. If no view controller has matching indetifier, this method throws an exception.
     */
    @available(*, deprecated, renamed: "viewController(ofType:)")
    func instantiateViewController<ViewControllerType>(ofType type: ViewControllerType.Type) -> ViewControllerType
        where ViewControllerType: UIViewController {
        return viewController(ofType: type)
    }
    
    /**
     * Instantiates and returns the view controller of given `type` using that `type` as identifier.
     * You use this method to create view controller objects that you want to manipulate and present programmatically in your application.
     * - Note: This method creates a new instance of the specified view controller each time you call it.
     * - Parameter type: Type of the view controller to be instantiated.
     * - Important: Before you can use this method to retrieve a view controller, you must explicitly tag it with an identifier string matching view controller's type in Interface Builder.
     *
     *   ## Example:
     *   Let's assume you have following view controller:
     *   ```
     *   class ExampleViewController: UIViewController { }
     *   ```
     *   In order to instantiate it like this:
     *   ```
     *   storyboard.viewController(ofType: ExampleViewController.self)
     *   ```
     *   you should tag corresponding view controller in Interface Builder with identifier `ExampleViewController` in the `Storyboard` you are referencing to.
     * - Returns: The view controller of given `type`. If no view controller has matching indetifier, this method throws an exception.
     */
    func viewController<ViewControllerType>(ofType type: ViewControllerType.Type) -> ViewControllerType
        where ViewControllerType : UIViewController {
            return instantiateViewController(withIdentifier: type.identifier) as! ViewControllerType
    }
}

public extension Bundle {
    
    /**
     * Instantiates and returns the view controller of given `type` using that `type` as a name of the nib file containing view of the view controller.
     * You use this method to create view controller objects that you want to manipulate and present programmatically in your application.
     * - Note: This method creates a new instance of the specified view controller each time you call it.
     * - Parameter type: Type of the view controller to be instantiated.
     * - Important: Make sure that nib file name matches view controller's `type` and that this file is included in bundle.
     *
     *   ## Example:
     *   Let's assume you have following view controller:
     *   ```
     *   class ExampleViewController: UIViewController { }
     *   ```
     *   In order to instantiate it like this:
     *   ```
     *   Bundle.main.instantiateViewController(ofType: ExampleViewController.self)
     *   ```
     *   you should name corresponding nib file as `ExampleViewController` and make sure this file is included in bundle.
     * - Returns: The view controller of given `type`. If matching nib file was not found, this method throws an exception.
     */
    @available(*, deprecated, renamed: "viewController(ofType:)")
    func instantiateViewController<ViewControllerType>(ofType type: ViewControllerType.Type) -> ViewControllerType
        where ViewControllerType: UIViewController {
            return viewController(ofType: type)
    }
    
    /**
     * Instantiates and returns the view controller of given `type` using that `type` as a name of the nib file containing view of the view controller.
     * You use this method to create view controller objects that you want to manipulate and present programmatically in your application.
     * - Note: This method creates a new instance of the specified view controller each time you call it.
     * - Parameter type: Type of the view controller to be instantiated.
     * - Important: Make sure that nib file name matches view controller's `type` and that this file is included in bundle.
     *
     *   ## Example:
     *   Let's assume you have following view controller:
     *   ```
     *   class ExampleViewController: UIViewController { }
     *   ```
     *   In order to instantiate it like this:
     *   ```
     *   Bundle.main.viewController(ofType: ExampleViewController.self)
     *   ```
     *   you should name corresponding nib file as `ExampleViewController` and make sure this file is included in bundle.
     * - Returns: The view controller of given `type`. If matching nib file was not found, this method throws an exception.
     */
    func viewController<ViewControllerType>(ofType type: ViewControllerType.Type) -> ViewControllerType
        where ViewControllerType : UIViewController {
            return type.init(nibName: type.identifier, bundle: self)
    }
}

// MARK: - UIView instantiation
public extension Bundle {
    
    /**
     * Instantiates and returns the view of given `type` using that `type` as a name of the nib file containing the view.
     * - Note: This method creates a new instance of the specified view each time you call it.
     * - Parameter type: Type of the view to be instantiated.
     * - Parameter owner: The object to use as the owner of the nib file. If the nib file has an owner, you must specify a valid object for this parameter.
     * - Important: Make sure that nib file name matches view's `type` and that this file is included in bundle.
     *
     *   ## Example:
     *   Let's assume you have following view:
     *   ```
     *   class ExampleViewr: UIView { }
     *   ```
     *   In order to instantiate it like this:
     *   ```
     *   Bundle.main.instantiateView(of: ExampleView.self)
     *   ```
     *   you should name corresponding nib file as `ExampleView` and make sure this file is included in bundle.
     * - Returns: The view of given `type`. If matching nib file was not found, this method throws an exception.
     */
    @available(*, deprecated, renamed: "view(ofType:)")
    func instantiateView<ViewType>(of type: ViewType.Type, owner: Any? = nil) -> ViewType
        where ViewType : UIView {
            return view(ofType: type, owner: owner)
    }
    
    /**
     * Instantiates and returns the view of given `type` using that `type` as a name of the nib file containing the view.
     * - Note: This method creates a new instance of the specified view each time you call it.
     * - Parameter type: Type of the view to be instantiated.
     * - Parameter owner: The object to use as the owner of the nib file. If the nib file has an owner, you must specify a valid object for this parameter.
     * - Important: Make sure that nib file name matches view's `type` and that this file is included in bundle.
     *
     *   ## Example:
     *   Let's assume you have following view:
     *   ```
     *   class ExampleViewr: UIView { }
     *   ```
     *   In order to instantiate it like this:
     *   ```
     *   Bundle.main.view(ofType: ExampleView.self)
     *   ```
     *   you should name corresponding nib file as `ExampleView` and make sure this file is included in bundle.
     * - Returns: The view of given `type`. If matching nib file was not found, this method throws an exception.
     */
    func view<ViewType>(ofType type: ViewType.Type, owner: Any? = nil) -> ViewType
        where ViewType : UIView {
            return self.loadNibNamed(type.identifier, owner: owner)!.first as! ViewType
    }
}

public extension UINib {
    
    /**
     * Instantiates and returns the view of given `type`.
     * - Note: This method creates a new instance of the specified view each time you call it.
     * - Parameter type: Type of the view to be instantiated.
     * - Parameter owner: The object to use as the owner of the nib file. If the nib file has an owner, you must specify a valid object for this parameter.
     * - Returns: The view of given `type`. If nib doesn't contain a view of given `type`, this method throws an exception.
     */
    @available(*, deprecated, renamed: "view(ofType:)")
    func instantiateView<ViewType>(of type: ViewType.Type, owner: Any? = nil) -> ViewType
        where ViewType : UIView {
            return view(ofType: type, owner: owner)
    }
    
    /**
     * Instantiates and returns the view of given `type`.
     * - Note: This method creates a new instance of the specified view each time you call it.
     * - Parameter type: Type of the view to be instantiated.
     * - Parameter owner: The object to use as the owner of the nib file. If the nib file has an owner, you must specify a valid object for this parameter.
     * - Returns: The view of given `type`. If nib doesn't contain a view of given `type`, this method throws an exception.
     */
    func view<ViewType>(ofType type: ViewType.Type, owner: Any? = nil) -> ViewType
        where ViewType : UIView {
            return self.instantiate(withOwner: owner).first as! ViewType
    }
}
#endif
