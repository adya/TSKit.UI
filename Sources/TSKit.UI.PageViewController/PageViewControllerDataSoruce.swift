// - Since: 01/20/2018
// - Author: Arkadii Hlushchevskyi
// - Copyright: © 2020. Arkadii Hlushchevskyi.
// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

import UIKit

/// `PageViewController`'s data source used to provide `UIViewController` representing a single page.
public protocol PageViewControllerDataSource: class {
    
    /**
     Provides number of pages to be displayed in `pageController`.
     */
    func numberOfPages(in pageController: PageViewController) -> Int
    
    /**
     Called whenever `pageController` needs to instantiate new `UIViewController`.
     
     - Parameter pageController: `PageViewController` which triggers the delegate.
     - Parameter identifier: Reuse identifier of the page for which `UIViewController` will be instantiated.
     
     - Returns: `UIViewController` for specified `reuseIdentifier`.
     */
    func pageController(_ pageController: PageViewController, viewControllerWithReuseIdentifier identifier: String) -> UIViewController
    
    /**
     Called when `pageController` is preparing page's `viewController` to be displayed.
     Use this method to configure your page.
     */
    func pageController(_ pageController: PageViewController, prepareViewController controller: UIViewController, at index: Int)
    
    /**
     Called whenever `pageController` dequeues a page at given index and needs to know reuse identifier for that page.
     
     - Parameter pageController: `PageViewController` which triggers the delegate.
     - Parameter index: Index of the page which reuse identifier is requested.
     
     - Returns: Reuse identifier for page at given index.
     */
    func pageController(_  pageController: PageViewController, reuseIdentifierForPageAt index: Int) -> String
}
