import Foundation
import SwiftUI

struct MenuItemParentLink {
    var menu: NSMenu
    var parent: String?
}

extension Array where Element:NSMenuItem {
    mutating func sortByTitle() {
        self.sort(by: { $0.title < $1.title })
    }
}

class ChronosStatusBar {
    private var _exists: [Substring: MenuItemParentLink]
    private var _statusBarItem: NSStatusItem?
    private var _statusBarMenu = NSMenu.init(title: "Chronos")
    private let _IPCClient: IPCClient

    init() {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        _exists = [Substring: MenuItemParentLink]()
        _IPCClient = IPCClient.init(serviceName: "nogen.Chronos.XPCService")

        setup()
    }
        
    private func setup() -> Void {

        // Pass timezone to IPCClient
        let currentDate: Date = _IPCClient.chooseTimezone(timezone: TimeZone.current)
        
        // Get value from date and Set value in title
        updateTime(currentDate)
        
        setupStatusBarMenu()
        
        // Add the status bar menu to the item
        _statusBarItem?.menu = _statusBarMenu
    }
    
    private func setupStatusBarMenu() -> Void {
        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            if timeZone != "GMT" {
                recurse(timeZone: timeZone)
            }
        }

        for (title, test) in _exists {
            let menuItem = NSMenuItem.init(title: String(title), action: #selector(chooseTimezone(_:)), keyEquivalent: "")
            menuItem.target = self
            
            menuItem.submenu = test.menu
            
            if test.parent != nil {
                _exists[Substring(test.parent!)]?.menu.addItem(menuItem)
                _exists[Substring(test.parent!)]?.menu.items.sortByTitle()
            } else {
                _statusBarMenu.addItem(menuItem)
            }
        }
        
        _statusBarMenu.items.sortByTitle()
    }
    
    private func recurse(timeZone: String, parent: String? = nil) {
        let (first, rest) = splitTimezone(timeZone)

        if rest.contains("/") {
            recurse(timeZone: String(rest), parent: String(first))
        } else if _exists[first] == nil {
            let menu = createMenu(title: first, item: rest)
            _exists[first] = MenuItemParentLink(menu: menu, parent: parent)
        } else {
            addItemToMenu(menu: _exists[first]!.menu, item: rest)
        }
    }
    
    private func createMenu(title: Substring, item: Substring) -> NSMenu {
        let menu = NSMenu.init(title: String(title))
        
        addItemToMenu(menu: menu, item: item)
    
        return menu
    }
    
    private func addItemToMenu(menu: NSMenu, item: Substring) -> Void {
        let title = item.split(separator: "_").joined(separator: " ")
        
        let menuItem = NSMenuItem.init(title: title, action: #selector(chooseTimezone(_:)), keyEquivalent: "")
        menuItem.target = self
        
        menu.addItem(menuItem)
    }
    
    @IBAction private func chooseTimezone(_ menuItem: NSMenuItem) -> Void {
        let nomalizedTitle = menuItem.title.split(separator: " ").joined(separator: "_")
        var timeZoneToUse = ""

        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            if timeZone.contains(nomalizedTitle) {
                timeZoneToUse = timeZone
            }
        }
        
        menuItem.state = NSControl.StateValue.on

        // Pass timezone to IPCClient
        let currentDate: Date = _IPCClient.chooseTimezone(timezone: TimeZone.init(identifier: timeZoneToUse)!)
        
        // Get value from date and Set value in title
        updateTime(currentDate)
    }
    
    private func splitTimezone(_ timeZone: String) -> (Substring, Substring) {
        let parts = timeZone.split(separator: "/")
        
        var rest: [Substring] = []
        
        for index in 1...parts.count - 1 {
            rest.append(parts[index])
        }

        return (parts[0], Substring("\(rest.joined(separator: "/"))"))
    }

    /**
     * This function is used by the IPCClient to update the time
     */
    public func updateTime(_ date: Date) -> Void {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        
        _statusBarItem?.button?.title = dateString
    }
}
