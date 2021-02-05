import Cocoa
import OSLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainApplicationIdentifier = "nogen.chronos"
        let runningApps = NSWorkspace.shared.runningApplications
        let isMainApplicationRunning = !runningApps.filter { $0.bundleIdentifier == mainApplicationIdentifier }.isEmpty
        
        //If the main application is not running, we start it
        if !isMainApplicationRunning {
            // Listens to the killLauncher notification from the main application, so it can be terminated
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(terminateApplication), name: NSNotification.Name(rawValue: "killLauncher"), object: mainApplicationIdentifier)

            
            let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainApplicationIdentifier);
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.arguments = ["/bin"];
            NSWorkspace.shared.openApplication(at: url!, configuration: configuration, completionHandler: nil)
        } else {
            // If its already running we just kill the main application
            terminateApplication()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc
    private func terminateApplication() -> Void{
        exit(-1)
    }


}

