import Foundation
import SwiftUI
import CoreData

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
        _chronosStatusBar = ChronosStatusBar(persistentContainer)
        OBSERVER_MANAGER.add(_chronosStatusBar!)
    }
}
