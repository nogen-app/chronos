import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var _chronosStatusBar: ChronosStatusBar?

    func applicationDidFinishLaunching(_ notification: Notification) {
        _chronosStatusBar = ChronosStatusBar()
    }
}

struct Test {
    var menu: NSMenu
    var parent: String?
}

class ChronosStatusBar {
//    private var _exists: [Substring: NSMenu]
    private var _newExists: [Substring: Test]
    private var _statusBarItem: NSStatusItem?
    private var _statusBarMenu = NSMenu.init(title: "Chronos")
    private let _IPCClient: IPCClient

    init() {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//        _exists = [Substring: NSMenu]()
        _newExists = [Substring: Test]()
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

        for (title, test) in _newExists {
            let menuItem = NSMenuItem.init()
            menuItem.title = String(title)
            menuItem.submenu = test.menu
            
            if test.parent != nil {
                _newExists[Substring(test.parent!)]?.menu.addItem(menuItem)
            } else {
                _statusBarMenu.addItem(menuItem)
            }
        }
    }
    
    private func recurse(timeZone: String, parent: String? = nil) {
        let (first, rest) = splitTimezone(timeZone)

        if rest.contains("/") {
            recurse(timeZone: String(rest), parent: String(first))
        } else if _newExists[first] == nil {
            let menu = createMenu(title: first, item: rest)
            _newExists[first] = Test(menu: menu, parent: parent)
        } else {
            addItemToMenu(menu: _newExists[first]!.menu, item: rest)
        }
    }
    
    private func createMenu(title: Substring, item: Substring) -> NSMenu {
        let menu = NSMenu.init(title: String(title))
        
        addItemToMenu(menu: menu, item: item)
    
        return menu
    }
    
    private func addItemToMenu(menu: NSMenu, item: Substring) -> Void {
        let menuItem = NSMenuItem.init()
        
        menuItem.title = item.split(separator: "_").joined(separator: " ")
//        menuItem.action = #selector(chooseTimezone(_:))
//        menuItem.
        
        menu.addItem(menuItem)
    }
    
    @objc private func chooseTimezone(_ menuItem: NSMenuItem) -> Void {
        let timeZone = menuItem.title // TODO: Here
        print(timeZone)

        // Pass timezone to IPCClient
//        let currentDate: Date = _IPCClient.chooseTimezone(timezone: TimeZone.init(identifier: timeZone)!)
        
        // Get value from date and Set value in title
//        updateTime(currentDate)
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
