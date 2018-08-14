import TSKit_Core
//import TSKit_MVVM

/**
 This extension uses `Identifiable` to provide simplified type-safe dequeueing of `UITableViewCell` and `UITableViewHeaderFooterView` and their subclasses.
 
 - Version:    1.2
 - Date:       11/08/2017
 - Since:      09/02/2016
 - Author:     AdYa
 */

/// Defines common element of `UITableView`. Provides information about desired `height` and `identifier` for element's type.
public protocol TableViewElement : Identifiable {
    
    /// Desired default height of the `TableViewElement`
    static var height : CGFloat {get}
    
    /// Computed height of the `TableViewElement`.
    /// - Note: Usually based on content's size.
    var dynamicHeight : CGFloat {get}
}

/// Adds to `TableViewElement` an ability to measure its `height` based on supported `dataSource` when it is conforming to `Configurable`.
//public protocol ConfigurableTableViewElement : TableViewElement, Configurable {
//
//    /// Calculates minimum height to fit content provided in `dataSource`.
//    /// - Note: By default this method returns base desired `height` of `TableViewElement`.
//    /// - Parameter dataSource: A data source for which `height` will be calculated.
//    /// - Parameter frameWidth: Desired width of the `TableViewElement`.
//    /// - Returns: Minimum `height` of the `TableViewElement` to fit content of `DataSource`.
//    static func height(with dataSource: Self.DataSourceType, frameWidth: CGFloat) -> CGFloat
//
//}

public extension TableViewElement {
    public var dynamicHeight : CGFloat {
        return type(of: self).height
    }
}

extension UITableViewCell: TableViewElement {
    
    public class var height: CGFloat {
        return UITableViewAutomaticDimension
    }
}

/// Extension which utilizes `TableViewElement` and eases process of dequeueing a new elements.
public extension UITableView {
    
    /**
     Dequeues custom `UITableViewCell` instance of given `type`.
     - Parameter type: Type of the cell to be dequeued.
     - Attention:
     * If you are using standalone xib for cell layout make sure that cell's class name matches filename of the xib (disregarding file extension).
     * If you are using prototype cells in storyboards make sure to set `reusableIdentifier` to match cell's class name.
     - Note: No additional setup required to make it work. (No need to register a class nor nib file using the `register(_:forCellReuseIdentifier:)`)
     */
    func dequeueReusableCell<T> (of type : T.Type) -> T where T : UITableViewCell {
        let id = type.identifier
        if let cell = self.dequeueReusableCell(withIdentifier: id) {
            return cell as! T
        }
        else {
            let nib = UINib(nibName: id, bundle: Bundle.main)
            self.register(nib, forCellReuseIdentifier: id)
            return self.dequeueReusableCell(of: type)
        }
    }
    
    /**
     Dequeues custom `UITableViewCell` instance of given `type`.
     - Parameter type: Type of the cell to be dequeued.
     - Parameter indexPath: The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the table view.
     - Attention:
     * If you are using standalone xib for cell layout make sure that cell's class name matches filename of the xib (disregarding file extension).
     * If you are using prototype cells in storyboards make sure to set `reusableIdentifier` to match cell's class name.
     - Note: No additional setup required to make it work. (No need to register a class nor nib file using the `register(_:forCellReuseIdentifier:)`)
     */
    @available(iOS 6.0, *)
    func dequeueReusableCell<T> (of type : T.Type, for indexPath : IndexPath) -> T where T : UITableViewCell {
        let id = type.identifier
        
        //        let cell = self.dequeueReusableCell(withIdentifier: id, for: indexPath)
        //        if let tsCell = cell as? T {
        //            return tsCell
        //        } else {
        let nib = UINib(nibName: id, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: id)
        return self.dequeueReusableCell(withIdentifier: id, for: indexPath) as! T
        //        }
    }
    
    /**
     Dequeues custom `UITableViewHeaderFooterView` instance of given `type`.
     - Parameter type: Type of the header/footer view to be dequeued.
     - Attention:
     * If you are using standalone xib for view layout make sure that view's class name matches filename of the xib (disregarding file extension).
     * If you are using prototype cells in storyboards make sure to set `reusableIdentifier` to match cell's class name. (Though, you should not use prototype cells for headers/footers).
     - Note: No additional setup required to make it work.
     */
    func dequeueReusableView<T> (of type : T.Type) -> T where T : UITableViewHeaderFooterView {
        let id = type.identifier
        if let view = self.dequeueReusableHeaderFooterView(withIdentifier: id) {
            return view as! T
        }
        else {
            let nib = UINib(nibName: id, bundle: Bundle.main)
            self.register(nib, forHeaderFooterViewReuseIdentifier: id)
            return self.dequeueReusableView(of: type)
        }
    }    
}
