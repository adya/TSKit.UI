import UIKit

/**
  A handy `UIView` extension providing access to underlying `layer`'s  common properties.

  - Version:    1.2
  - Date:       11/08/2017
  - Since:      09/23/2016
  - Author:     AdYa
*/
@IBDesignable
public extension UIView {
    
    /// Width of `UIView`'s border.
    /// - Note: This property is simple accessor for `layer`'s `borderWidth` property.
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Color of `UIView`'s borders.
    /// - Note: This property is simple accessor for `layer`'s `borderColor` property.
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /// If set to `true` `UIView` will be circled by adjusting `cornerRadius`.
    /// - Returns: `true` if current `cornerRadius` matches the one required for `UIView` to be circled.
    @IBInspectable
    public var isCircled: Bool {
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
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    /// The offset (in points) of `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowOffset` property.
    @IBInspectable
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// The opacity of `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowOpacity` property.
    @IBInspectable
    public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// The blur radius (in points) used to render `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowRadius` property.
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// The color of `UIView`'s shadow.
    /// - Note: This property is simple accessor for `layer`'s `shadowColor` property.
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}
