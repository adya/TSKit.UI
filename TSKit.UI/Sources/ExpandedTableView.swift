/// UITableView subclass which will resize itself to fit content without scrolling.
public class ExpandedTableView: UITableView {
    
    override public var contentSize : CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
    
}
