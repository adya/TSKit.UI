// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit
import TSKit_Core

public extension UIWindow {
    
    /// Iterates through all controllers of specified type in the hierarchy and performs `updates` on each applicable controller.
    func forEach<T>(controller: T.Type, _ updates: @escaping (T) -> Void) {
        flattenControllers().forEach {
            if let controller = $0 as? T {
                updates(controller)
            }
        }
    }
    
    // Flatten controllers hierarchy into a one-dimensional array.
    func flattenControllers() -> [UIViewController] {
        func traverse(_ controller: UIViewController) -> [UIViewController] {
            var list: [UIViewController] = []
            list.append(controller)
            if let presented = controller.presentedViewController {
                list += traverse(presented)
            }
            if let navController = controller as? UINavigationController {
                list += navController.viewControllers.flatMap(traverse)
            } else if let tabController = controller as? UITabBarController {
                list += tabController.viewControllers?.flatMap(traverse) ?? []
            } else if let splitController = controller as? UISplitViewController {
                list += splitController.viewControllers.flatMap(traverse)
            } else {
                list += controller.children.flatMap(traverse)
            }
            return list
        }
        
        return rootViewController.flatMap(traverse) ?? []
    }
    
    /// Returns the first controller in hierarchy that satisfies the given `predicate`.
    /// - Parameter predicate: A closure that takes a controller as its argument and returns a `Bool` value indicating whether the controller is a match.
    func first(where predicate: (UIViewController) -> Bool) -> UIViewController? {
        flattenControllers().first(where: predicate)
    }
    
    /// Returns the last controller in hierarchy that satisfies the given `predicate`.
    /// - Note: Hierearchy will be traversed in reverse order, so this method as efficient as `first(where:)`.
    /// - Parameter predicate: A closure that takes a controller as its argument and returns a `Bool` value indicating whether the controller is a match.
    func last(where predicate: (UIViewController) -> Bool) -> UIViewController? {
        flattenControllers().last(where: predicate)
    }
    
    /// Returns the first controller in hierarchy of specified type.
    ///
    /// For example, following code will find the first instance of `UINavigationController` in hierarchy of given `window`:
    /// ```
    /// let navController = window.first(controller: UINavigationController.self)
    /// ```
    /// - Parameter controller: Type of the controller to be found.
    func first<T>(controller: T.Type) -> T? {
        flattenControllers().first(where: { $0 is T }) as? T
    }
    
    /// Returns the first controller in hierarchy of specified type.
    ///
    /// For example, following code will find the last instance of `UINavigationController` in hierarchy of given `window`:
    /// ```
    /// let navController = window.last(controller: UINavigationController.self)
    /// ```
    /// - Parameter controller: Type of the controller to be found.
    /// - Note: Hierearchy will be traversed in reverse order, so this method as efficient as `first(controller:)`.
    func last<T>(controller: T.Type) -> T? {
        flattenControllers().last(where: { $0 is T }) as? T
    }
}

public extension UIView {

    /// Iterates through all views of specified type in the hierarchy and performs `updates` on each applicable controller.
    func forEach<T>(view: T.Type, _ updates: @escaping (T) -> Void) where T: UIView {
        func process(_ view: UIView) {
            if let desiredView = view as? T {
                updates(desiredView)
            }
            view.subviews.forEach(process)
        }

        process(self)
    }

    /// Returns first subview of specified type in the hierarchy.
    func first<T>( _ type: T.Type) -> T? where T: UIView {
        func traverse(_ view: UIView) -> T? {
            if let desiredView = view as? T {
                return desiredView
            }

            for subview in view.subviews {
                if let desiredView = traverse(subview) {
                    return desiredView
                }
            }

            return nil
        }

        return traverse(self)
    }
}
#endif
