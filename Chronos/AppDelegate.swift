import Foundation
import SwiftUI
import CoreData
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    private var _chronosStatusBar: ChronosStatusBar?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChronosDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Checking to see if the Launcher application helper app is already running
        // if it is we kill it
        let launcherAppIdentifier = "nogen.Chronus.LauncherApplication"
        let runningApps = NSWorkspace.shared.runningApplications
        let isLauncherServiceRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppIdentifier }.isEmpty
        
        // Adds the application to the login items list
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, true)
        
        if isLauncherServiceRunning {
            DistributedNotificationCenter.default().post(name: NSNotification.Name(rawValue: "killLauncher"), object: Bundle.main.bundleIdentifier!)
        }
        
        _chronosStatusBar = ChronosStatusBar(persistentContainer)
        OBSERVER_MANAGER.add(_chronosStatusBar!)
    }
}
