import Foundation

class ChronosClient: NSObject, ChronosClientProtocol {
    func updateClock(_ date: Date) {
        // This function is called by the XPCService every 5th second
        OBSERVER_MANAGER.refreshView(date)
    }
}
