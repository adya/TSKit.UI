import UIKit

@IBDesignable
public class InsetableTextField : UITextField {
    
    @IBInspectable public var inset : CGFloat = 0
    
    override public func textRect(forBounds bounds : CGRect) -> CGRect {
        let defaultBounds = super.textRect(forBounds: bounds)
        let inseted = CGRect(x: defaultBounds.minX + self.inset,
                      y: defaultBounds.minY,
                      width: defaultBounds.width - 2 * self.inset,
                      height: defaultBounds.height)
        return inseted
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.editingRect(forBounds: bounds)
        let inseted = CGRect(x: defaultBounds.minX + self.inset,
                      y: defaultBounds.minY,
                      width: defaultBounds.width - 2 * self.inset,
                      height: defaultBounds.height)
        return inseted
    }
}
