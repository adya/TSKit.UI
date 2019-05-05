/// - Since: 01/20/2018
/// - Author: Arkadii Hlushchevskyi
/// - Copyright: © 2018. Arkadii Hlushchevskyi.
/// - Seealso: https://github.com/adya/TSKit.UI/blob/master/LICENSE.md

import UIKit

protocol TSCollapsableSection {
    var isCollapsed : Bool {get set}
}

protocol TSCollapsableSectionHeaderView {
    var controller : TSCollapsableTableViewController {get set}
    var section : Int {get set}
    func toogleCollapse()
}

extension TSCollapsableSectionHeaderView {
    func toogleCollapse() {
        self.controller.toogleSection(self.section)
    }
}

protocol TSCollapsableTableViewController : TSCollapsableTableViewDelegate, TSCollapsableTableViewDataSource {
}

protocol TSCollapsableTableViewDelegate : UITableViewDelegate {
    func collapseSection(section : Int)
    func expandSection(section : Int)
    func collapseAllSections()
    func expandAllSections()
}


protocol TSCollapsableTableViewDataSource : UITableViewDataSource {
    var collapsableSections : [TSCollapsableSection] {get set}
    var tableView : UITableView {get}
}

extension TSCollapsableTableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Extended numberOfRows was called.")
        if collapsableSections[section].isCollapsed {
            return 0
        }
        return self.tableView(tableView, numberOfRowsInSection: section)
    }
    
}

extension TSCollapsableTableViewController {
    
    func collapseSection(section : Int) {
        setSection(section, collapsed: true)
        updateSections([section])
    }
    
    func expandSection(section : Int) {
        setSection(section, collapsed: false)
        updateSections([section])
    }
    
    func collapseAllSections() {
        let sections = allSections
        for section in sections {
            setSection(section, collapsed: true)
        }
        updateSections(sections)
    }
    
    func expandAllSections() {
        let sections = allSections
        for section in sections {
            setSection(section, collapsed: false)
        }
        updateSections(sections)
    }
    
    private var allSections : [Int]{
        return Array(0...collapsableSections.count-1)
    }
    
    private func toogleSection(section : Int) {
        setSection(section, collapsed: !collapsableSections[section].isCollapsed)
    }
    
    private func setSection(section : Int, collapsed:Bool) {
        collapsableSections[section].isCollapsed = collapsed
    }
    
    private func updateSections(sections : [Int]){
        let set = NSMutableIndexSet()
        sections.forEach({set.addIndex($0)})
        tableView.reloadSections(set, withRowAnimation: .Automatic)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("Extended viewForHeader was called.")
        let view = self.tableView(tableView, viewForHeaderInSection: section)
        if var tsView = view as? TSCollapsableSectionHeaderView {
            tsView.controller = self
            tsView.section = section
        }
        return view
    }
    
}

