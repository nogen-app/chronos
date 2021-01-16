import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var _chronosStatusBar: ChronosStatusBar?

    func applicationDidFinishLaunching(_ notification: Notification) {
        _chronosStatusBar = ChronosStatusBar()
        observerManager.add(observer: _chronosStatusBar!)
    }
}
