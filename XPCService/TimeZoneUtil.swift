import Foundation

class TimeZoneUtil {
    
    class func getDate(_ timeZone: TimeZone) -> Date {
        let now = Date()
        // Adds the GMT offset of the calendar to the current date, meaning it should return the time in said timezone
        let calendar = Calendar.current
        let timeZoneDate = calendar.date(byAdding: .second, value: timeZone.secondsFromGMT(), to: now)
        return timeZoneDate!;
    }
}
