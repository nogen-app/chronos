import Foundation
import SwiftUI
import CoreData

class ChronosStatusBar: Observer {
    private var _exists: [Substring: MenuItemParentLink]
    private let _statusBarItem: NSStatusItem?
    private let _statusBarMenu = NSMenu.init(title: "Chronos")
    private let _selectedStatusBarItem: NSStatusItem?
    private let _timeZoneEntity: TimeZoneEntity
    private let _IPCClient: IPCClient

    init(_ persistentContainer: NSPersistentContainer) {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        _selectedStatusBarItem = nil
        _exists = [Substring: MenuItemParentLink]()
        _IPCClient = IPCClient.init("nogen.Chronos.XPCService")
        
        _timeZoneEntity = TimeZoneEntity.init(persistentContainer, entityName: "ChronosSettings")

        setup()
    }
    
    public func refreshView(_ date: Date) -> Void {
        DispatchQueue.main.sync {
            self.updateTime(date)
        }
    }
        
    private func setup() -> Void {
        let timeZone = TimeZoneUtility.timeZoneFromString(_timeZoneEntity.readTimeZone())

        // Pass timezone to IPCClient
        let currentDate = _IPCClient.chooseTimeZone(timeZone)
        
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

        for (title, menuItemParentLink) in _exists {
            let menuItem = createMenuItem(title)
            
            menuItem.submenu = menuItemParentLink.menu
            
            if menuItemParentLink.parent != nil {
                _exists[Substring(menuItemParentLink.parent!)]?.menu.addItem(menuItem)
                _exists[Substring(menuItemParentLink.parent!)]?.menu.items.sortByTitle()
            } else {
                _statusBarMenu.addItem(menuItem)
            }
        }
        
        _statusBarMenu.items.sortByTitle()
        // TODO: Disable action on top level menu bar items
    }
    
    private func recurse(timeZone: String, parent: String? = nil) {
        let (first, rest) = TimeZoneUtility.splitTimeZone(timeZone)

        if rest.contains("/") {
            recurse(timeZone: String(rest), parent: String(first))
        } else if _exists[first] == nil {
            let menu = NSMenu.init(title: String(first))
            addItemToMenu(menu: menu, item: rest)

            _exists[first] = MenuItemParentLink(menu: menu, parent: parent)
        } else {
            addItemToMenu(menu: _exists[first]!.menu, item: rest)
        }
    }
    
    private func createMenuItem(_ title: Substring) -> NSMenuItem {
        let menuItem = NSMenuItem.init(title: String(title), action: #selector(chooseTimeZone(_:)), keyEquivalent: "")
        menuItem.target = self
        
        return menuItem
    }
        
    private func addItemToMenu(menu: NSMenu, item: Substring) -> Void {
        let menuItem = createMenuItem(item)
        
        menu.addItem(menuItem)
    }
    
    private func updateTime(_ date: Date) -> Void {
        let formatter = DateFormatter()

        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")

        _statusBarItem?.button?.title = formatter.string(from: date)
    }
    
    @IBAction private func chooseTimeZone(_ menuItem: NSMenuItem) -> Void {
        let originalTitle = menuItem.title.split(separator: " ").joined(separator: "_")
        var timeZoneToUse: String = ""
        
        for statusBarItem in _statusBarMenu.items {
            if statusBarItem.menu != nil {
                for nestedStatusBarItem in statusBarItem.menu!.items {
                    
                }
            }
        }

        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            if timeZone.contains(originalTitle) {
                timeZoneToUse = timeZone
            }
        }
        
        menuItem.state = NSControl.StateValue.on

        // Pass timezone to IPCClient
        let currentDate = _IPCClient.chooseTimeZone(TimeZoneUtility.timeZoneFromString(timeZoneToUse))
        
        // Get value from date and Set value in title
        updateTime(currentDate)
        
        DispatchQueue.global(qos: .background).async {
            if self._timeZoneEntity.readTimeZone() != nil {
                self._timeZoneEntity.updateTimeZone(timeZoneToUse)
            } else {
                self._timeZoneEntity.createTimeZone(timeZoneToUse)
            }
        }
    }
}
