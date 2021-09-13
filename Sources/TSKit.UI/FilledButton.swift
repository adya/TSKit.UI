// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

@IBDesignable
open class FilledButton: UIButton {

    private var originalBackgroundColor: UIColor? {
        didSet {
            setBackground(enabled: isEnabled, animated: false)
        }
    }

    @IBInspectable
    open override var backgroundColor: UIColor? {
        get {
            originalBackgroundColor
        }
        set {
            originalBackgroundColor = newValue
        }

    }
    
    @IBInspectable
    public var disabledBackgroundColor: UIColor? {
        didSet {
            setBackground(enabled: isEnabled, animated: false)
        }
    }
    
    @IBInspectable
    public var highlightedBackgroundColor: UIColor? {
        didSet {
            setBackground(faded: isHighlighted, animated: false)
        }
    }

    open override var isEnabled: Bool {
        didSet {
            if isEnabled != oldValue {
                setBackground(enabled: isEnabled, animated: true)
            }
        }
    }

    open override var isHighlighted: Bool {
        willSet {
            if isEnabled, isHighlighted != newValue {
                setBackground(faded: newValue, animated: true)
            }
        }
    }

    private func setBackground(enabled: Bool, animated: Bool) {
        guard let backgroundColor = originalBackgroundColor?.cgColor else { return }
        
        guard let disabledColor = disabledBackgroundColor?.cgColor else {
            return setBackground(faded: true, animated: animated)
        }
        
        if enabled {
            layer.backgroundColor = backgroundColor
            if animated {
                layer.removeAllAnimations()
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = disabledColor
                animation.toValue = backgroundColor
                animation.duration = animated ? 0.15 : 0
                layer.add(animation, forKey: "enabling")
            }
        } else {
            layer.backgroundColor = disabledColor
            if animated {
                layer.removeAllAnimations()
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = backgroundColor
                animation.toValue = disabledColor
                animation.duration = animated ? 0.15 : 0
                layer.add(animation, forKey: "disabling")
            }
        }
    }
    
    private func setBackground(faded: Bool, animated: Bool) {
        guard let backgroundColor = originalBackgroundColor else { return }

        let fadedColor = (highlightedBackgroundColor ?? backgroundColor.withAlphaComponent(0.8)).cgColor

        if faded {
            layer.backgroundColor = fadedColor
            if animated {
                layer.removeAllAnimations()
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = backgroundColor.cgColor
                animation.toValue = faded
                animation.duration = animated ? 0.15 : 0
                layer.add(animation, forKey: "selecting")
            }
        } else {
            layer.backgroundColor = backgroundColor.cgColor
            if animated {
                layer.removeAllAnimations()
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = fadedColor
                animation.toValue = backgroundColor.cgColor
                animation.duration = animated ? 0.15 : 0
                layer.add(animation, forKey: "deselecting")
            }
        }
    }
}
#endif
