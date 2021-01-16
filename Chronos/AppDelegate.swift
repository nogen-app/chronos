import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var _chronosStatusBar: ChronosStatusBar?

    func applicationDidFinishLaunching(_ notification: Notification) {
        _chronosStatusBar = ChronosStatusBar()
    }
}

class ChronosStatusBar {
    private var _exists: [Substring: NSMenu]
    private var _comp: [Substring: Substring]
    private var _statusBarItem: NSStatusItem?
    private var _statusBarMenu = NSMenu.init(title: "Chronos")
    private let _IPCClient: IPCClient

    init() {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        _exists = [Substring: NSMenu]()
        _comp = [Substring: Substring]()
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
//        var exists = [Substring: NSMenu]()
        
        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            if timeZone != "GMT" {
//                print(timeZone)
                
                recurse(timeZone)
                
                // 1: Africa/Abidjan -> (Africa, Abidjan)
                // 2: Africa/Accra -> (Africa, Accra)
                // 3: America/Argentina/Buenes_aires -> (America, Argentina/Buenes_aires)
//                let (first, rest) = splitTimezone(timeZone)
//
//                if exists[first] == nil {
//                    let menu = createMenu(title: first, item: rest)
//                    exists[first] = menu
//                } else {
//                    addItemToMenu(menu: exists[first]!, item: rest)
//                }
            }
        }
        print(_comp)
        for (title, menu) in _exists {
            print(title)
            print(menu.items)
            print("--------------------------------------------------------")
            
//            if menu.items.contains
            let menuItem = NSMenuItem.init()
            menuItem.title = String(title)
            menuItem.submenu = menu

            _statusBarMenu.addItem(menuItem)
        }
    }
    
    private func recurse(_ timeZone: String) {
        let (first, rest) = splitTimezone(timeZone)

        if rest.contains("/") {
            let (newFirst, _) = splitTimezone(String(rest))
            _comp[newFirst] = first
            recurse(String(rest))
        } else if _exists[first] == nil {
            let menu = createMenu(title: first, item: rest)
            _exists[first] = menu
        } else {
            addItemToMenu(menu: _exists[first]!, item: rest)
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
        
        menu.addItem(menuItem)
    }
    
    // America/Argentina/Buenes_aires
    // -> (America, Argentina/Buenes_aires)
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
