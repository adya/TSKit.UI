// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

@IBDesignable
public extension UIView {
    
    /// Width of `UIView`'s border.
    /// - Note: This property is simple accessor for `layer`'s `borderWidth` property.
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Color of `UIView`'s borders.
    /// - Note: This property is simple accessor for `layer`'s `borderColor` property.
    @IBInspectable
    var borderColor: UIColor? {
        get {
            layer.borderColor.flatMap(UIColor.init(cgColor:))
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /// If set to `true` `UIView` will be circled by adjusting `cornerRadius`.
    /// - Returns: `true` if current `cornerRadius` matches the one required for `UIView` to be circled.
    @IBInspectable
    var isCircled: Bool {
        get {
            let minDimension = min(frame.width, frame.height)
            return cornerRadius == minDimension / 2
        }
        set {
            let minDimension = min(frame.width, frame.height)
            cornerRadius = (newValue ? minDimension / 2 : 0)
        }
    }
    
    /// Radius of `UIView`'s corners.
    /// - Note: This property is simple accessor for `layer`'s `cornerRadius` property.
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    /// The offset (in points) of `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowOffset` property.
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// The opacity of `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowOpacity` property.
    @IBInspectable
    var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// The blur radius (in points) used to render `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowRadius` property.
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// The color of `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowColor` property.
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            layer.shadowColor.flatMap(UIColor.init(cgColor:))
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}
#endif
