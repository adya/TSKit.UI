import UIKit

@IBDesignable
open class FilledButton: UIButton {

    private var originalBackgroundColor: UIColor? {
        didSet {
            setBackground(faded: !isEnabled, animated: false)
        }
    }

    open override var backgroundColor: UIColor? {
        get {
            originalBackgroundColor
        }
        set {
            originalBackgroundColor = newValue
        }

    }
    
    public var disabledBackgroundColor: UIColor? {
        didSet {
            setBackground(enabled: isEnabled, animated: false)
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
            if isHighlighted != newValue {
                setBackground(faded: !isEnabled || newValue, animated: true)
            }
        }
    }

    private func setBackground(enabled: Bool, animated: Bool) {
        guard let backgroundColor = originalBackgroundColor?.cgColor else { return }
        
        guard let disabledColor = disabledBackgroundColor?.cgColor else {
            return setBackground(faded: true, animated: animated)
        }
        
        if enabled {
            layer.backgroundColor = disabledColor
        } else {
            layer.backgroundColor = backgroundColor
            if animated {
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = disabledColor
                animation.toValue = backgroundColor
                animation.duration = animated ? 0.15 : 0
                layer.add(animation, forKey: "enabling")
            }
        }
    }
    
    private func setBackground(faded: Bool, animated: Bool) {
        guard let backgroundColor = originalBackgroundColor else { return }

        let fadedColor = backgroundColor.withAlphaComponent(0.8).cgColor

        if faded {
            layer.backgroundColor = fadedColor
        } else {
            layer.backgroundColor = backgroundColor.cgColor
            if animated {
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = fadedColor
                animation.toValue = backgroundColor.cgColor
                animation.duration = animated ? 0.15 : 0
                layer.add(animation, forKey: "highlighting")
            }
        }
    }
}
