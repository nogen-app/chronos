import Foundation

class ChronosService: NSObject, ChronosServiceProtocol {
    func chooseTimeZone(timeZone: TimeZone, withReply reply: @escaping (Date) -> Void) {
        // Saves the selected timeZone in the global struct
        SavedTimeZone.timeZone = timeZone
        
        // Reply to the gui with the current time for given timeZone
        reply(TimeZoneUtil.getDate(timeZone))
    }
}
