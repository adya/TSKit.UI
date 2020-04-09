// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

/// Provides a way to do post-segue actions using `completion` closure.
public class CompletionStoryboardSegue: UIStoryboardSegue {
	
    public var completion: (() -> Void)?
	
    override public func perform() {
		super.perform()
        completion?()
	}
}
