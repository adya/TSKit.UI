import UIKit
import TSKit_Core

/// Makes any `UIViewController` identifiable by its class name.
extension UIViewController : Identifiable {}

/// Makes any `UIView` identifiable by its class name.
extension UIView : Identifiable {}


// MARK: - UIViewController instantiation
extension UIStoryboard {
    
    /**
     Handy method to instantiate view controllers by its type.
     Instantiates any subclass of `UIViewController` which conforms to `Identifiable`.
     - Parameter type: Type of the `viewController` to instantiate.
     - Attention: Make sure that you:
        1. Use the right storyboard (storyboard contains desired view controller).
        2. Set identifier to view controller in storyboard.
    */
    func instantiateViewController <ViewControllerType> (ofType type: ViewControllerType.Type) -> ViewControllerType
        where ViewControllerType : UIViewController {
        return self.instantiateViewController(withIdentifier: type.identifier) as! ViewControllerType
    }
}

extension Bundle {
    func instantiateViewController <ViewControllerType> (ofType type: ViewControllerType.Type) -> ViewControllerType
        where ViewControllerType : UIViewController {
            return type.init(nibName: type.identifier, bundle: self)
    }
}

// MARK: - UIView instantiation
extension Bundle {
    
    func instantiateView <ViewType> (of type: ViewType.Type, owner: Any? = nil) -> ViewType
        where ViewType : UIView {
            return self.loadNibNamed(type.identifier, owner: owner)!.first as! ViewType
    }
}

extension UINib {
    
    func instantiateView <ViewType> (of type: ViewType.Type, owner: Any? = nil) -> ViewType
        where ViewType : UIView {
            return self.instantiate(withOwner: owner).first as! ViewType
    }
}
