// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

/// TODO: Description... 9/24/16.
/**
 1. Setup in IB
 2. Create reference outlet to parent
 3. Set delegate and dataSource
 4. Enjoy!
 */

/**
 1. Make your custom UIVIew conform to TSIndicatorView.
 2. Provide this custom view in dataSource.indicatorViewForIndex method
 3. Enjoy your custom indicators.
 */

import UIKit

public protocol PageControlDelegate: class {
    
    /// Tells the `delegate` that new indicator is about to be selected.
    /// If `delegate` wants to override default flow it should provide desired indicator to be selected instead.
    /// - Returns: Index of the indicator to be selected.
    func pageControl(_ pageControl: PageControl, willSwitchFrom fromIndex: Int, to toIndex: Int) -> Int
    
    func pageControl(_ pageControl: PageControl, didSwitchFrom fromIndex: Int, to toIndex: Int)
    
    func pageControl(_ pageControl: PageControl, customizeIndicator view: UIView, at index: Int)
}

// All methods are optional.

public extension PageControlDelegate {
    
    func pageControl(_ pageControl: PageControl, willSwitchFrom fromIndex: Int, to toIndex: Int) -> Int { toIndex }
    
    func pageControl(_ pageControl: PageControl, didSwitchFrom fromIndex: Int, to toIndex: Int) {}
    
    func pageControl(_ pageControl: PageControl, customizeIndicator view: UIView, at index: Int) {}
}

public protocol TSIndicatorView {
    func changeIndicatorState(active: Bool, animated: Bool)
}

public enum PageControlIndicatorType {
    case color(colors: (defaultColor: UIColor, activeColor: UIColor))
    case image(images: (defaultImage: UIImage, activeImage: UIImage))
    case custom(delegate: (_ index: Int) -> UIView)
}

@IBDesignable
public class PageControl: UIView {
    
    public weak var delegate: PageControlDelegate?
    
    @IBInspectable public var insetsConstant: CGFloat {
        get {
            return self.insets.top
        }
        set(value) {
            self.insets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        }
    }
    
    @IBInspectable public var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var indicatorsCount: Int = 0 {
        didSet {
            self.reset()
        }
    }
    @IBInspectable public var indicatorsSize: CGSize = CGSize(width: 8, height: 8) {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable public var indicatorsSpacing: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var indicatorViewType: PageControlIndicatorType = .color(colors: (defaultColor: UIColor.lightGray, activeColor: UIColor.darkGray)) {
        didSet {
            self.reset()
        }
    }
    
    @IBInspectable public var currentIndicator: Int = 0 {
        willSet {
            self.setIndicator(active: false, at: self.currentIndicator, animated: true)
        }
        
        didSet {
            self.setIndicator(active: true, at: self.currentIndicator, animated: true)
        }
    }
    
    public override var isUserInteractionEnabled: Bool {
        didSet {
            self.subviews.forEach {
                $0.isUserInteractionEnabled = self.isUserInteractionEnabled
            }
        }
    }
    
    /// Flag indicating whether switch occured due to programatically changing `currentPage` or by tapping page indicator.
    /// - Note: Useful to determine origin of of `pageControl(_:didSwitchFrom:to:)` delegate method.
    public private(set) var isUserInitiatedSwitch = true
    
    private var indicators: [UIView] = [UIView]()
    
    private func setup() {
        self.setIndicator(active: true, at: self.currentIndicator, animated: false)
    }
    
    private func setIndicator(active: Bool, at index: Int, animated: Bool) {
        guard self.currentIndicator >= 0 && self.currentIndicator < self.indicators.count else {
            return
        }
        if let indicatorView = self.indicators[currentIndicator] as? TSIndicatorView {
            indicatorView.changeIndicatorState(active: active, animated: animated)
        } else {
            print("\(type(of: self)): Unable to set active state to indicator, because it doesn't conform to TSIndicatorView protocol.")
        }
    }
    
    public func reset() {
        for indicator in self.indicators {
            indicator.removeFromSuperview()
        }
        self.indicators.removeAll()
        self.updateIndicators()
    }
    
    private func updateIndicators() {
        let frame = self.frameForIndicators()
        for index in 0..<self.indicatorsCount {
            let view = self.indicatorView(at: index)
            self.updatePosition(for: view, at: index, with: frame)
        }
    }
    
    private func updatePosition(for indicator: UIView, at index: Int, with frame: CGRect) {
        let shift: CGFloat = self.distanceToCenter(from: index)
        let x = frame.midX + shift
        let y = frame.midY
        indicator.isUserInteractionEnabled = self.isUserInteractionEnabled
        indicator.center = CGPoint(x: x, y: y)
    }
    
    /// Calculates distance from `bounds.center` to `center` of the indicator at given `index`.
    private func distanceToCenter(from index: Int) -> CGFloat {
        let center = indicatorsCount / 2
        let isEven = indicatorsCount % 2 == 0
        let indexDistance = CGFloat((index + (isEven ? 1 : 0)) - center)
        let measureUnit = (indicatorsSize.width + indicatorsSpacing) / 2 // measeureUnit represents distance between indicator center and spacing center. This will ease calculation algorithm
        let unitsNumber = isEven ? indexDistance * 2 - 1 : indexDistance * 2
        return measureUnit * unitsNumber
    }
    
    func suggestCurrentIndicator(_ index: Int) {
        isUserInitiatedSwitch = false
        let prevIndex = currentIndicator
        currentIndicator = delegate?.pageControl(self, willSwitchFrom: currentIndicator, to: index) ?? index
        delegate?.pageControl(self, didSwitchFrom: prevIndex, to: currentIndicator)
        isUserInitiatedSwitch = true
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedView = touches.first?.view,
            let index = self.indicators.firstIndex(of: touchedView), index != self.currentIndicator else {
                return
        }
        let prevIndex = currentIndicator
        self.currentIndicator = index
        self.delegate?.pageControl(self, didSwitchFrom: prevIndex, to: currentIndicator)
    }
    
    public override var intrinsicContentSize: CGSize {
        return sizeForIndicators(adjustInsets: true)
    }
    
    public override func sizeToFit() {
        let size = self.intrinsicContentSize
        self.bounds = CGRect(origin: self.bounds.origin, size: size)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateIndicators()
        self.setIndicator(active: true, at: self.currentIndicator, animated: false)
    }
    
    private func frameForIndicators() -> CGRect {
        let size = self.sizeForIndicators(adjustInsets: false)
        return CGRect(x: (self.bounds.width - size.width) / 2, y: (self.bounds.height - size.height) / 2, width: size.width, height: size.height)
    }
    
    private func sizeForIndicators(adjustInsets: Bool) -> CGSize {
        var width = self.indicatorsSize.width * CGFloat(self.indicatorsCount) + self.indicatorsSpacing * CGFloat(self.indicatorsCount - 1)
        var height = self.indicatorsSize.height
        if adjustInsets {
            width += self.insets.left + self.insets.right
            height += self.insets.top + self.insets.bottom
        }
        return CGSize(width: width, height: height)
    }
    
    /** Retrieves indicator view at given index. */
    private func indicatorView(at index: Int) -> UIView {
        if !self.indicators.isEmpty && index >= 0 && index < self.indicators.count {
            return self.indicators[index]
        }
        let indicatorView: UIView
        switch self.indicatorViewType {
        case let .color(colors):
            indicatorView = TSColorIndicatorView(defaultColor: colors.defaultColor, activeColor: colors.activeColor)
        case let .image(images):
            indicatorView = TSImageIndicatorView(defaultImage: images.defaultImage, activeImage: images.activeImage)
        case let .custom(delegate):
            indicatorView = delegate(index)
        }
        
        indicatorView.frame = CGRect(origin: CGPoint.zero, size: self.indicatorsSize)
        
        self.indicators.append(indicatorView)
        self.addSubview(indicatorView)
        indicatorView.isUserInteractionEnabled = true
        self.delegate?.pageControl(self, customizeIndicator: indicatorView, at: index)
        setIndicator(active: (index == self.currentIndicator), at: index, animated: false)
        return self.indicators[index]
    }
}

private class TSColorIndicatorView: UIView, TSIndicatorView {
    
    var defaultColor: UIColor?
    var activeColor: UIColor?
    
    init(defaultColor: UIColor, activeColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.setup(defaultColor: defaultColor, activeColor: activeColor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup(defaultColor: UIColor = UIColor.lightGray, activeColor: UIColor = UIColor.darkGray) {
        self.defaultColor = defaultColor
        self.activeColor = activeColor
        self.backgroundColor = self.defaultColor
    }
    
    func changeIndicatorState(active: Bool, animated: Bool) {
        let color = active ? self.activeColor : self.defaultColor
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.backgroundColor = color
            })
        } else {
            self.backgroundColor = color
        }
        
    }
}

private class TSImageIndicatorView: UIImageView, TSIndicatorView {
    var defaultImage: UIImage? = nil
    var activeImage: UIImage? = nil
    
    init(defaultImage: UIImage, activeImage: UIImage) {
        super.init(frame: CGRect.zero)
        self.setup(defaultImage: defaultImage, activeImage: activeImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup(defaultImage: UIImage, activeImage: UIImage) {
        self.defaultImage = defaultImage
        self.activeImage = activeImage
        self.image = self.defaultImage
    }
    
    func changeIndicatorState(active: Bool, animated: Bool) {
        let image = active ? self.activeImage : self.defaultImage
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.image = image
            })
        } else {
            self.image = image
        }
        
    }
}
