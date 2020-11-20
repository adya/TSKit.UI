// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md


/// TSTOOLS: Description .. 9/14/16.
/// Placeholder added .. 12/05/16.

//import UIKit
//
//public enum TSButtonAlignment {
//    case Left, Right
//}
//
///// Target can be triggered.
//public protocol Triggerable : class {
//    var isTriggered : Bool {get set}
//}
//
///// TSTOOLS: Make it configurable and stylable
//@IBDesignable
//public class TSOptionButton : UIButton, Triggerable {
//    
//    private var alignedTitleEdgeInsets : UIEdgeInsets = UIEdgeInsets.zero
//    private var alignedImageEdgeInsets : UIEdgeInsets = UIEdgeInsets.zero
//    
//    private var placeholderLabel : UILabel?
//
//    private var initialized : Bool = false
//    
//    @IBInspectable public var placeholder : String? {
//        didSet {
//            self.placeholderLabel?.text = self.placeholder
//            self.placeholderLabel?.isHidden = !self.shouldUsePlaceholder(self.title(for: self.state), self.state)
//            self.placeholderLabel?.font = self.titleLabel?.font // force to update font each time placeholder is updated (there is no way to track titleLabel?.font property)
//        }
//    }
//    @IBInspectable public var placeholderColor : UIColor! = UIColor(alpha: 255, red: 199, green: 199, blue: 205) {
//        didSet {
//            self.placeholderLabel?.textColor = self.placeholderColor
//        }
//    }
//    
//    public override var isSelected: Bool {
//        didSet {
//            self.placeholderLabel?.textColor = self.isSelected ? self.titleColor(for: self.state) : self.placeholderColor
//        }
//    }
//    
//    public override var isHighlighted: Bool {
//        didSet {
//            self.placeholderLabel?.textColor = self.isHighlighted || self.isSelected ? self.titleColor(for: self.state) : self.placeholderColor
//        }
//    }
//    
//    @IBInspectable public var reverseImage : Bool {
//        get {
//            return self.imageAlignment == .Right
//        }
//        set {
//            self.imageAlignment = newValue ? .Right : .Left
//        }
//    }
//    
//    public var imageAlignment : TSButtonAlignment = .Left {
//        didSet {
//            self.updateAlignment()
//        }
//    }
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.initialize()
//    }
//    
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.initialize()
//    }
//    
//    private func initialize() {
//        self.placeholderLabel = UILabel()
//        self.placeholderLabel?.textColor = self.placeholderColor
//        self.placeholderLabel?.text = self.placeholder
//        self.addSubview(self.placeholderLabel!)
//        self.imageView?.contentMode = .scaleAspectFit
//    }
//    
//    public var isTriggered: Bool {
//        get {
//            return self.isSelected
//        }
//        
//        set {
//            UIView.animate(withDuration: 0.7) {
//                self.isSelected = newValue
//            }
//        }
//    }
//    
//    public override func setTitle(_ title: String?, for state: UIControlState) {
//        self.placeholderLabel?.isHidden = !self.shouldUsePlaceholder(title, state)
//        super.setTitle(title, for: state)
//    }
//    
//    private func shouldUsePlaceholder(_ title : String?, _ state : UIControlState) -> Bool {
//        let title = title.flatMap({ $0 == "" ? nil : $0}) // avoid empty strings
//        return (self.placeholder != nil) && (title == nil || title == self.placeholder)
//    }
//
//    private func updateAlignment() {
//        switch self.imageAlignment {
//        case .Left: self.alignLeft()
//        case .Right: self.alignRight()
//        }
//    }
//    
//    private func alignLeft() {
//        self.alignedImageEdgeInsets = UIEdgeInsets.zero
//        self.alignedTitleEdgeInsets = UIEdgeInsets.zero
//        self.setNeedsLayout()
//    }
//    
//    private func alignRight() {
//        let imageWidth : CGFloat = self.imageView?.image?.size.width ?? 0
//        let imageLeft = self.bounds.size.width - imageWidth - self.contentEdgeInsets.right - self.contentEdgeInsets.left
//        self.alignedImageEdgeInsets = UIEdgeInsetsMake(0, imageLeft, 0, 0)
//        self.alignedTitleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, imageWidth)
//        self.setNeedsLayout()
//    }
//    
//    private func layoutLabel(_ label : UILabel, inFrame frame : CGRect) {
//        label.sizeToFit()
//        let width = min(label.frame.width, frame.width)
//        let height = min(label.frame.height, frame.height)
//        let x : CGFloat
//        let y : CGFloat
//        switch contentHorizontalAlignment {
//        case .left, .leading:
//            label.textAlignment = .left
//            x = frame.minX
//        case .right, .trailing:
//            label.textAlignment = .right
//            x = frame.width - width
//        case .center:
//            label.textAlignment = .center
//            x = frame.midX - width/2
//        case .fill:
//            label.textAlignment = .justified
//            x = frame.midX - width/2
//        }
//        
//        switch contentVerticalAlignment {
//        case .top: y = frame.minY
//        case .bottom: y = frame.height - height
//        case .center, .fill: y = frame.midY - height/2
//        }
//        label.frame = CGRect(x: x, y: y, width: width, height: height)
//    }
//    
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        let titleInsets = self.alignedTitleEdgeInsets + self.titleEdgeInsets
//        let imageInsets = self.alignedImageEdgeInsets + self.imageEdgeInsets
//        
//        let contentFrame = CGRect(x: self.contentEdgeInsets.left,
//                                  y: self.contentEdgeInsets.top,
//                                  width:  self.bounds.width
//                                        - self.contentEdgeInsets.left
//                                        - self.contentEdgeInsets.right,
//                                  height: self.bounds.height
//                                        - self.contentEdgeInsets.top
//                                        - self.contentEdgeInsets.bottom)
//        let imageWidth : CGFloat = self.imageView?.image?.size.width ?? 0
//        let imageFrame = CGRect(x: self.contentEdgeInsets.left + imageInsets.left - imageInsets.right,
//                                y: contentFrame.minY + imageInsets.top,
//                                width: imageWidth,
//                                height: contentFrame.height
//                                    - imageInsets.top
//                                    - imageInsets.bottom)
//        
//        let titleFrame = CGRect(x: contentFrame.minX + titleInsets.left,
//                                       y: contentFrame.minY + titleInsets.top,
//                                       width: contentFrame.width
//                                            - titleInsets.left
//                                            - titleInsets.right
//                                            - imageFrame.width
//                                            - imageInsets.right,
//                                       height: contentFrame.height
//                                             - titleInsets.top
//                                             - titleInsets.bottom)
//        if let label = placeholderLabel {
//            layoutLabel(label, inFrame: titleFrame)
//        }
//        if let label = titleLabel {
//            layoutLabel(label, inFrame: titleFrame)
//        }
//        self.imageView?.frame = imageFrame
//    }
//}
//
//private func + (insets1 : UIEdgeInsets, insets2 : UIEdgeInsets) -> UIEdgeInsets {
//    return UIEdgeInsets(top: insets1.top + insets2.top,
//                        left: insets1.left + insets2.left,
//                        bottom: insets1.bottom + insets2.bottom,
//                        right: insets1.right + insets2.right)
//}
//
//public protocol TSOptionButtonDataSource {
//    var indicatorImage : UIImage {get}
//    var triggeredIndicatorImage : UIImage? {get}
//    
//    var title : String? {get}
//    var placeholder : String? {get}
//}
//
//public extension TSOptionButtonDataSource {
//    var triggeredIndicatorImage : UIImage? {
//        return nil
//    }
//    
//    var triggeredTitle : String? {
//        return nil
//    }
//}
//
//public protocol TSOptionButtonStyle {
//    var placeholderColor : UIColor? {get}
//    var titleColor : UIColor? {get}
//}
