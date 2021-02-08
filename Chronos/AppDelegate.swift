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
        let launcherAppIdentifier = "nogen.Chronos.LauncherApplication"
        let runningApps = NSWorkspace.shared.runningApplications
        
        // Checking to see if the launcher application helper app is already running
        let isLauncherServiceRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppIdentifier }.isEmpty
        
        // Adds the application to the login items list
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, true)
        
        if isLauncherServiceRunning {
            // Send notification to the launcher application helper app, telling it to kill itself
            DistributedNotificationCenter.default().post(name: NSNotification.Name(rawValue: "killLauncher"), object: Bundle.main.bundleIdentifier!)
        }
        
        _chronosStatusBar = ChronosStatusBar(persistentContainer)
        OBSERVER_MANAGER.add(_chronosStatusBar!)
    }
}
