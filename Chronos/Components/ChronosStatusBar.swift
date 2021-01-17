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
    private var _lookupTable: [Int: String]
    private var _currentLookupCount: Int
    
    init(_ persistentContainer: NSPersistentContainer) {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        _selectedStatusBarItem = nil
        _exists = [Substring: MenuItemParentLink]()
        _IPCClient = IPCClient.init("nogen.Chronos.XPCService")
        
        _lookupTable = [Int: String]()
        _currentLookupCount = 0
        
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
       
        setMenuItemStateOn(menuItems: _statusBarMenu.items, identifier: TimeZoneUtility.timeZoneToString(timeZone), state: NSControl.StateValue.on)
    }
    
    private func setupStatusBarMenu() -> Void {
        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            if timeZone != "GMT" {
                recurse(timeZone: timeZone.suffix(from: timeZone.startIndex))
            }
        }

        for (title, menuItemParentLink) in _exists {
            let menuItem = createMenuItem(title, identifier: String(title))
            
            menuItem.submenu = menuItemParentLink.menu
            
            if menuItemParentLink.parent != nil {
                _exists[Substring(menuItemParentLink.parent!)]?.menu.addItem(menuItem)
                _exists[Substring(menuItemParentLink.parent!)]?.menu.items.sortByTitle()
            } else {
                _statusBarMenu.addItem(menuItem)
            }
        }
        
        _statusBarMenu.items.sortByTitle()
    }
    
    private func recurse(timeZone: Substring, parent: Substring? = nil) {
        let (first, rest) = TimeZoneUtility.splitTimeZone(timeZone)

        if rest.contains("/") {
            recurse(timeZone: rest, parent: first)
        } else if _exists[first] == nil {
            let menu = NSMenu.init(title: String(first))
            
            if parent != nil {
                addItemToMenu(menu: menu, item: rest, identifier: parent!.base)
            } else {
                addItemToMenu(menu: menu, item: rest, identifier: first.base)
            }
            
            _exists[first] = MenuItemParentLink(menu: menu, parent: parent)
        } else {

            if _exists[first]?.parent != nil {
                addItemToMenu(menu: _exists[first]!.menu, item: rest, identifier: parent!.base)
            } else {
                addItemToMenu(menu: _exists[first]!.menu, item: rest, identifier: first.base)
            }
        }
    }
    
    private func createMenuItem(_ title: Substring, identifier: String) -> NSMenuItem {
        let menuItem = NSMenuItem.init(title: String(title), action: #selector(chooseTimeZone(_:)), keyEquivalent: "")
        menuItem.target = self
        
        menuItem.tag = _currentLookupCount
        _lookupTable[_currentLookupCount] = identifier.split(separator: " ").joined(separator: "_")
        _currentLookupCount += 1
        
        return menuItem
    }
        
    private func addItemToMenu(menu: NSMenu, item: Substring, identifier: String) -> Void {
        let menuItem = createMenuItem(item, identifier: identifier)
        
        menu.addItem(menuItem)
    }
    
    private func updateTime(_ date: Date) -> Void {
        let formatter = DateFormatter()

        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")
 
        _statusBarItem?.button?.title = formatter.string(from: date)
    }

    private func setMenuItemStateOn(menuItems: [NSMenuItem], identifier: String, state: NSControl.StateValue) -> Void {
        for menuItem in menuItems {
            if menuItem.submenu != nil {
//                menuItem.target = nil
                
                setMenuItemStateOn(menuItems: menuItem.submenu!.items, identifier: identifier, state: state)
            } else {
                if _lookupTable[menuItem.tag] == identifier {
                    menuItem.state = state
                }
            }
        }
    }
    
    private func resetMenuItemsState(_ menuItems: [NSMenuItem]) -> Void {
        for menuItem in menuItems {
            if menuItem.submenu != nil {
                resetMenuItemsState(menuItem.submenu!.items)
            } else {
                menuItem.state = NSControl.StateValue.off
            }
        }
    }
    
    @IBAction private func chooseTimeZone(_ menuItem: NSMenuItem) -> Void {
        if menuItem.submenu == nil {
            var timeZoneToUse: String = ""
            
            if _lookupTable[menuItem.tag] != nil {
                timeZoneToUse = _lookupTable[menuItem.tag]!
            } else {
                fatalError("A menuItem is not in the lookupTable")
            }

            resetMenuItemsState(_statusBarMenu.items)
            
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
}
