//
//  AppDelegate.swift
//  Chronos
//
//  Created by Michael Nissen on 31/12/2020.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        var chronosStatusBar = ChronosStatusBar()
        
    }
}

class ChronosStatusBar {
    private let _statusBarItem: NSStatusItem?
    private let _IPCClient: IPCClient

    init() {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        _IPCClient = IPCClient.init(serviceName: "nogen.Chronos.XPCService")

        setup()
    }
    
    private func setup() {
        // Pass timezone to IPCClient
        
        // Get value from timezone
        
        // Set value in title
        self._statusBarItem?.button?.title = "Title" // This is the time
    }
    
    /**
     * This function is used by the IPCClient to update the time
     */
    public func updateTime(_ date: Date) {
        
    }
}
