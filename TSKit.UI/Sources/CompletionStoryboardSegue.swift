/// Provides a way to do post-segue actions using `completion` closure.
public class CompletionStoryboardSegue: UIStoryboardSegue {
	
    public var completion: (() -> Void)?
	
    override public func perform() {
		super.perform()
        completion?()
	}
}
