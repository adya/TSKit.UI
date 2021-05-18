// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2021. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md
#if os(iOS)
import TSKit_Core
import UIKit


/**
 This extension uses `Identifiable` to provide simplified type-safe dequeueing of `UICollectionReusableView` and its subclasses.
 
 - Version:    1.2
 - Date:       11/08/2017
 - Since:      09/02/2016
 - Author:     AdYa
 */

public protocol CollectionViewElement : Identifiable {
    static var size : CGSize {get}
    var dynamicSize : CGSize {get}
}


public extension CollectionViewElement {
    var dynamicSize : CGSize {
        return type(of: self).size
    }
}


extension UICollectionReusableView : CollectionViewElement {
    public class var size: CGSize {
        return CGSize(width: 90, height: 90)
    }
}

@available(iOS 6.0, *)
public extension UICollectionView {
    func dequeueReusableCell<T> (of type : T.Type, for indexPath : IndexPath) -> T where T : UICollectionViewCell {
        let id = type.identifier
//        let cell = self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
//        if let tsCell = cell as? T {
//            return tsCell
//        } else {
            let nib = UINib(nibName: id, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: id)
            return self.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! T
//        }
    }
    
    @available(iOS 8.0, *)
    func dequeueReusableHeaderView<T> (of type : T.Type, for indexPath : IndexPath) -> T where T : UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(of: type, kind: UICollectionView.elementKindSectionHeader, for: indexPath)
    }
    
    @available(iOS 8.0, *)
    func dequeueReusableFooterView<T> (of type : T.Type, for indexPath : IndexPath) -> T where T : UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(of: type, kind: UICollectionView.elementKindSectionFooter, for: indexPath)
    }
    
    @available(iOS 8.0, *)
    private func dequeueReusableSupplementaryView<T> (of type : T.Type, kind: String, for indexPath : IndexPath) -> T where T : UICollectionReusableView {
        let id = type.identifier
        let nib = UINib(nibName: id, bundle: Bundle.main)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: id)
        let view = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        return view as! T
    }
}
#endif
