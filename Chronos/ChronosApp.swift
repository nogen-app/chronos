//
//  ChronosApp.swift
//  Chronos
//
//  Created by Michael Nissen on 27/12/2020.
//

import Foundation
import SwiftUI

@main
struct ChronosApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegatee: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var statusBarMenu = NSMenu.init(title: "Chronos")
    var ipcClient = IPCClient(serviceName: "nogen.Chronos.XPCService")
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = "Chronos"
      
        
        var timeZones = [Substring: [Substring]]()
                
        for timeZone in TimeZone.knownTimeZoneIdentifiers {
            print(timeZone)
            if timeZone != "GMT" {
                let (zone, city) = splitTimezone(timeZone)

                if timeZones[zone] == nil {
                    timeZones[zone] = [city]
                } else {
                    timeZones[zone]?.append(city)
                }
            }
        }
        
        for timeZone in timeZones {
            let menuItem = NSMenuItem.init()
            menuItem.title = String(timeZone.key)
            menuItem.submenu = createSubMenu(timeZone.key, timeZone.value)
            
            statusBarMenu.addItem(menuItem)
        }

        statusBarItem?.menu = statusBarMenu
    }
    
    func createSubMenu(_ title: Substring, _ values: [Substring]) -> NSMenu {
        let subMenu = NSMenu.init(title: String(title))

        var timeZones = [Substring: [Substring]]()

        for value in values {
            if value.contains("/") {
                let (country, city) = splitTimezone(String(value))
                
                if timeZones[country] == nil {
                    timeZones[country] = [city]
                } else {
                    timeZones[country]?.append(city)
                }
            }
        
            let name = value.split(separator: "_").joined(separator: " ")
            
            let subMenuItem = NSMenuItem.init()
            subMenuItem.title = name
            
            subMenu.addItem(subMenuItem)
        }
        
        return subMenu
    }
    
    func splitTimezone(_ timeZone: String) -> (Substring, Substring) {
        let parts = timeZone.split(separator: "/")
        return (parts[0], parts[1])
    }
}
