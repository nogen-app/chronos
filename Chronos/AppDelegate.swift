import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var _chronosStatusBar: ChronosStatusBar?

    func applicationDidFinishLaunching(_ notification: Notification) {
        _chronosStatusBar = ChronosStatusBar()
    }
}

class ChronosStatusBar {
    private var _statusBarItem: NSStatusItem?
    private let _IPCClient: IPCClient

    init() {
        _statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        _IPCClient = IPCClient.init(serviceName: "nogen.Chronos.XPCService")

        setup()
    }
    
    private func setup() {
        let currentTimezone = TimeZone.current

        // Pass timezone to IPCClient
        let currentDate: Date = _IPCClient.chooseTimezone(timezone: currentTimezone)
        
        // Get value from date and Set value in title
        updateTime(currentDate)
    }
    
    /**
     * This function is used by the IPCClient to update the time
     */
    public func updateTime(_ date: Date) {
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        
        self._statusBarItem?.button?.title = dateString
    }
}
