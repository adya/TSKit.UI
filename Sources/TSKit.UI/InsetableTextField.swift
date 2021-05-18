// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import UIKit

@IBDesignable
public class InsetableTextField : UITextField {
    
    @IBInspectable
    public var inset : CGFloat = 0
    
    public override func textRect(forBounds bounds : CGRect) -> CGRect {
        let defaultBounds = super.textRect(forBounds: bounds)
        let inseted = CGRect(x: defaultBounds.minX + self.inset,
                      y: defaultBounds.minY,
                      width: defaultBounds.width - 2 * self.inset,
                      height: defaultBounds.height)
        return inseted
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.editingRect(forBounds: bounds)
        let inseted = CGRect(x: defaultBounds.minX + self.inset,
                      y: defaultBounds.minY,
                      width: defaultBounds.width - 2 * self.inset,
                      height: defaultBounds.height)
        return inseted
    }
}
#endif
