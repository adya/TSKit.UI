/// - Since: 01/20/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

/// A `UIButton` subclass that highlights border.
@IBDesignable
public class BorderedButton: UIButton {
    
    private var originalBorderColor: UIColor? {
        didSet {
            setBorder(faded: !isEnabled, animated: false)
        }
    }
    
    override public var borderColor: UIColor? {
        get {
            return originalBorderColor
        }
        set {
            originalBorderColor = newValue
        }
        
    }
    
    override public var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                setBorder(faded: !isEnabled, animated: true)
            }
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                setBorder(faded: !isEnabled || isHighlighted, animated: true)
            }
        }
    }
    
    private func setBorder(faded: Bool, animated: Bool) {
        guard let borderColor = originalBorderColor else { return }
        
        let fadedColor = borderColor.withAlphaComponent(0.2).cgColor
        
        if faded {
            layer.borderColor = fadedColor
        } else {
            layer.borderColor = borderColor.cgColor
            if animated {
                let animation = CABasicAnimation(keyPath: "borderColor")
                animation.fromValue = fadedColor
                animation.toValue = borderColor.cgColor
                animation.duration = 0.4
                layer.add(animation, forKey: "")
            }
        }
    }
}
