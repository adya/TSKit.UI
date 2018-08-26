import UIKit
import TSKit_Log

/**
 `UIViewController` subclass designed to simplify implementation of `UIPageViewController` via embedding it into self and providing various methods for configuration.
 
 ### Key Features:
    * Powerful delegation for each state of `UIPageViewController`.
    * Easily embedding `UIPageViewController` into nested views.
    * Simple implementation.
    * Provides `TSPageControl` as custom page indicator which is highly configurable.
 
 
 - Note: Designed to be subclassed.
 
 - Requires:
     * TSPageControl.swift
     * TSArchitectureBase.swift
 
 ### 1. Setup:
    1. Subclass `TSPageViewController`.
    2. Set `dataSource` to provide pages.

 ### 2. Handling page switching:
    1. Do **Setup**
    2. Implement delegate's `pageController(_, didShow:, forPageAt:)` to do whatever you want when page is switched.
 
 ### 3. Some advanced features:
    1. Access view controller which is next or previous to current while swiping pages:
        * `pageController(_, willShow:, forPageAt:)`
        * `pageController(_, didCancelShow:, forPageAt:)`
 
    2. Customize `pageControl`'s indicators appearance:
        1. Set `pageControl` property to use custom `TSPageControl`.
        2. Set `pageControl?.indicatorViewType` to one of the predefined types.
        3. For more details see `TSPageControl`.

 - Version:    2.0
 - Date:       06/23/2017
 - Since:      09/23/2016
 - Author:     AdYa
 */

@IBDesignable
public class TSPageViewController: UIViewController, TSPageControlDelegate, Loggable {
    
    /// Custom page control to be used as page indicator.
    /// - Note: If set to nil and `useDefaultPageIndicator = false` there won't be any indicator.
    @IBOutlet
    public weak var pageControl: TSPageControl? {
        didSet {
            self.updatePageControl()
        }
    }
    
    /// Target `UIView` to which `UIPageViewController` will be embedded.
    @IBOutlet
    private weak var pageContentView: UIView!
    
    /// If `true` `TSPaeViewController` will use default `UIPageViewController` indicator instead of custom one.
    /// - Note: Use it if you don't need any custom indicators.
    @IBInspectable
    public var useDefaultPageIndicator: Bool = false {
        didSet {
            self.updatePageControl()
            self.updatePageViewControllerHelper()
        }
    }
    
    @IBInspectable
    public var allowGesureBasedNavigation: Bool = true {
        didSet {
            self.updatePageViewControllerHelper()
        }
    }
    
    /// When `TSPageViewController` uses custom `pageControl` this property enables or disables user interaction on `pageControl`, allowing user to switch pages by tapping on indicators.
    @IBInspectable
    public var allowPageControlSwitchPages: Bool = true {
        didSet {
            self.updatePageControl()
        }
    }
    
    /// Delegate which will be notified about all `TSPageViewController`'s events.
    public weak var pageDelegate: TSPageViewControllerDelegate?
    
    /// Data source providing `UIViewController` pages to `TSPageViewController`
    public weak var pageDataSource: TSPageViewControllerDataSource?
    
    /// Index of the currently displayed `UIViewController`.
    fileprivate(set) var currentPageIndex: Int = -1 {
        didSet {
            guard currentPageIndex >= 0 else {
                log.verbose("Not initialized.")
                return
            }
            log.debug("Updating current index from \(oldValue) to \(self.currentPageIndex)")
            self.pageControl?.currentIndicator = self.currentPageIndex
            
            log.debug("Filter pages outside of visible range.")
            let filtered = currentPages.filter {
                let notVisible = !self.isVisiblePage(at: $0.index)
                log.debug("Page \($0.index) is \(notVisible ? "not " : "")visible")
                return notVisible
            }
            
            log.debug("No longer visible pages: \(filtered).")
            
            let ids = filtered.map({$0.page.identifier}).distinct
            log.debug("Adding non-visible pages to reusable pool.")
            ids.forEach { id in
                
                if self.reusablePageViewControllers[id] == nil {
                    self.reusablePageViewControllers[id] = []
                }
                
                if let reusable = self.reusablePageViewControllers[id] {
                    self.reusablePageViewControllers[id] = reusable + filtered.map { $0.page }
                }
            }
            log.debug("Reusable pool: \(self.reusablePageViewControllers)")
            
            log.debug("Remove non-visible pages from used pool.")
            self.currentPages = self.currentPages.filter { dequeuedPage in
                !filtered.contains(where: { $0.page.controller == dequeuedPage.page.controller })
            }
            log.debug("Visible pages: \(self.currentPages)")
        }
    }
    
    /// Internal `UIPageViewController`
    private var pageViewController: UIPageViewController!
    
    /// Internal helper which implements `UIPageViewController`'s `Delegate` and `DataSource`.
    private var helper: TSPageViewControllerHelper!
    
    /// Currently used instantiated `UIViewController`s.
    private var currentPages = [DequeuedPage]() {
        didSet {
            log.debug("Used pages: Count = \(self.currentPages.count)")
            log.debug("Used pages: \(self.currentPages)")
        }
    }
    
    /// `UIViewController`s ready to be reused.
    private var reusablePageViewControllers = [String: [Page]]() {
        didSet {
            log.debug("Reusable pages: Count = \(self.reusablePageViewControllers.count)")
            log.debug("Reusable pages: \(self.reusablePageViewControllers)")
            
        }
    }
    
    /// Represents a pair of page  and it's index.
    private typealias DequeuedPage = (index: Int, page: Page)
    
    /// Represents a pair of controller and its' reuse identifier.
    private typealias Page = (identifier : String, controller : UIViewController)
    
    fileprivate var pagesCount: Int {
        return pageDataSource?.numberOfPages(in: self) ?? 0
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        updatePageControl()
        updatePageViewControllerHelper()
        
        addChildViewController(self.pageViewController)
        let viewName = (self.pageContentView != nil ? "root view" : "content view")
        let targetView: UIView = self.pageContentView ?? self.view
        
        pageContentView = targetView   // if targetView contains root view set reference to pageContentView
        targetView.addSubview(self.pageViewController.view)
        
        pageViewController!.didMove(toParentViewController: self)
        pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        constraintPageContentView()
        
        pageDelegate?.pageController(self, didEmbed: self.pageViewController, to: targetView)
        //        showPage(atIndex: 0)
        log.verbose("Page controller did embed UIPageViewController to \(viewName)")
    }
    
    /// Shows page at given index.
    /// - Parameter index: Index of the page to be shown.
    /// - Parameter animated: Flag indicating whether transition should be animated or not.
    public func showPage(atIndex index: Int, animated: Bool = true) {
        guard index != currentPageIndex else {
            log.verbose("Page at specified index is already shown.")
            return
        }
        
        guard let controller = self.viewController(at: index) else {
            log.warning("Index \(index) is out of bounds [0, \(self.pagesCount)].")
            return
        }
        
        self.pageViewController?.setViewControllers([controller], direction: (self.currentPageIndex < index ? .forward : .reverse), animated: animated, completion: nil)
        self.currentPageIndex = index
        self.pageDataSource?.pageController(self, prepareViewController: controller, at: index)
        self.pageDelegate?.pageController(self, didShow: controller, forPageAt: index)
    }
    
    /// Convenient method to show next page.
    /// - Parameter animated: Flag indicating whether transition should be animated or not.
    public func showNextPage(animated: Bool = true) {
        self.showPage(atIndex: self.currentPageIndex + 1, animated: animated)
    }
    
    /// Convenient method to show previous page.
    /// - Parameter animated: Flag indicating whether transition should be animated or not.
    public func showPrevPage(animated: Bool = true) {
        self.showPage(atIndex: self.currentPageIndex - 1, animated: animated)
    }
    
    /// Reloads current page.
    public func reloadPage() {
        guard let controller = self.viewController(at: currentPageIndex) else {
            log.warning("Index \(self.currentPageIndex) is out of bounds [0, \(self.pagesCount)].")
            return
        }
        
        self.pageDataSource?.pageController(self, prepareViewController: controller, at: currentPageIndex)
    }
    
    fileprivate func isVisiblePage(at index: Int) -> Bool {
        let minIndex = max(currentPageIndex - 1, 0)
        let maxIndex = min(currentPageIndex + 1, pagesCount - 1)
        return index >= minIndex && index <= maxIndex
    }
    
    /// Gets index of the page managed by specified `controller` if it's currently visible.
    /// - Returns: Index of the page or `nil` if page is not visible.
    fileprivate func pageIndex(for controller: UIViewController) -> Int? {
        return currentPages.first(where: { controller == $0.page.controller })?.index
    }
    
    /// Updates `pageControl` whenever configuration changes.
    private func updatePageControl() {
        self.pageControl?.delegate = self
        self.pageControl?.isHidden = self.useDefaultPageIndicator
        self.pageControl?.isUserInteractionEnabled = self.allowPageControlSwitchPages
        self.pageControl?.indicatorsCount = pagesCount
    }
    
    /// Updates `helper` whenever configuration changes.
    private func updatePageViewControllerHelper() {
        self.helper = self.useDefaultPageIndicator ? TSPageViewControllerDefaultHelper(parent: self) : TSPageViewControllerHelper(parent: self)
        self.pageViewController?.dataSource = self.allowGesureBasedNavigation ? self.helper : nil
        self.pageViewController?.delegate = self.helper
    }
    
    /// Reloads pages and displays the first one.
    private func updatePages() {
        self.showPage(atIndex: 0)
    }
    
    /// Applies constraints to `contentView`.
    private func constraintPageContentView() {
        guard let pageView = self.pageViewController?.view else {
            return
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|", metrics: nil, views: ["v": pageView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|", metrics: nil, views: ["v": pageView]))
    }
    
    /// Gets `UIViewController` at requested index or `nil`.
    fileprivate func viewController(at index: Int) -> UIViewController? {
        guard index >= 0 && index < pagesCount else {
            return nil
        }
        
        log.debug("Obtaining viewController at index \(index)")
        
        
        if let dequeuedPage = currentPages.first(where: { $0.index == index }) {
            log.debug("Using visible page.")
            return dequeuedPage.page.controller
        }
        
        log.debug("Requesting identifier")
        guard let identifier = pageDataSource?.pageController(self, reuseIdentifierForPageAt: index) else {
            log.verbose("DataSource was not set.")
            return nil
        }
        
        log.debug("Trying to find reusable controller for that page with identifier '\(identifier)'.")
        if let viewController = reusablePageViewControllers[identifier]?.first?.controller {
            log.debug("Found")
            log.debug("Adding new controller to active pages at index \(index) with identifier '\(identifier)'.")
            reusablePageViewControllers[identifier]?.removeFirst().controller
            currentPages.append(DequeuedPage(index: index, Page(identifier: identifier, controller: viewController)))
            return viewController
        } else {
            log.debug("Requesting new controller for identifier '\(identifier)'.")
            guard let viewController = pageDataSource?.pageController(self, viewControllerWithReuseIdentifier: identifier) else {
                log.warning("Failed to get view controller for page with identifier \(identifier).")
                return nil
            }
            
            log.debug("Adding new controller to active pages at index \(index) with identifier '\(identifier)'.")
            currentPages.append(DequeuedPage(index: index, Page(identifier: identifier, controller: viewController)))
            return viewController
        }
    }
    
    
    /// Handles taps on `pageControl`'s indicators to switch pages.
    public func pageControl(_ pageControl: TSPageControl, didSwitchFrom fromIndex: Int, to toIndex: Int) {
        guard self.allowPageControlSwitchPages else {
            log.warning("Page switching disabled by allowPageControlSwitchPages property.")
            return
        }
        self.showPage(atIndex: toIndex)
    }
    
    
    /// Default implementation which allows subclasses to override customization.
    public func pageControl(_ pageControl: TSPageControl, customizeIndicator view: UIView, at index: Int) {
        
    }
}

// MARK: - TSPageViewController helpers
/// Implements `UIPageViewController`'s `Delegate` and `DataSource`.

private class TSPageViewControllerHelper: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    fileprivate unowned let pageController: TSPageViewController
    
    init(parent: TSPageViewController) {
        self.pageController = parent
    }
    
    @objc
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //        pageController.log.debug("Requesting viewController after \(viewController)")
        if let index = self.pageController.pageIndex(for: viewController) {
            //            pageController.log.debug("Index of this controller is \(index)")
            let next = index + 1
            let controller = self.pageController.viewController(at: next)
            if let controller = controller {
                //self.pageController.pageDataSource?.pageController(self.pageController, prepareViewController: controller, at: next)
            }
            return controller
        }
        return nil
    }
    
    @objc
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //        pageController.log.debug("Requesting viewController before \(viewController)")
        if let index = self.pageController.pageIndex(for: viewController) {
            //            pageController.log.debug("Index of this controller is \(index)")
            let prev = index - 1
            let controller = self.pageController.viewController(at: prev)
            if let controller = controller {
                //self.pageController.pageDataSource?.pageController(self.pageController, prepareViewController: controller, at: prev)
            }
            return controller
        }
        return nil
    }
    
    @objc
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let controller = pendingViewControllers.first,
            let index = self.pageController.pageIndex(for: controller) else {
                return
        }
        self.pageController.pageDataSource?.pageController(self.pageController, prepareViewController: controller, at: index)
        self.pageController.pageDelegate?.pageController(self.pageController, willShow: controller, forPageAt: index)
    }
    
    @objc
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let controller = pageViewController.viewControllers?.first,
            let index = self.pageController.pageIndex(for: controller) else {
                return
        }
        
        guard completed else {
            self.pageController.pageDelegate?.pageController(pageController, didCancelShow: controller, forPageAt: index)
            return
        }
        
        self.pageController.currentPageIndex = index
        self.pageController.pageDelegate?.pageController(pageController, didShow: controller, forPageAt: index)
    }
}

/// Implements `UIPageViewController`'s `Delegate` and `DataSource` and enables default `UIPageViewController`'s page indicator.
private class TSPageViewControllerDefaultHelper: TSPageViewControllerHelper {
    @objc
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageController.pagesCount
    }
    
    @objc
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageController.currentPageIndex
    }
}

