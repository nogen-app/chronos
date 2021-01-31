import Foundation

public class TimeZoneUtility {
    public class func timeZoneFromString(_ timeZone: String?) -> TimeZone {
        return timeZone != nil ? TimeZone.init(identifier: timeZone!)! : TimeZone.current
    }
    
    public class func timeZoneToString(_ timeZone: TimeZone) -> String {
        return timeZone.identifier
    }
    
    public class func splitTimeZone(_ timeZone: Substring) -> (Substring, Substring) {
        let normalized = timeZone.split(separator: "_").joined(separator: " ")

        let parts = normalized.split(separator: "/")
        
        var rest: [Substring] = []
        
        for index in 1...parts.count - 1 {
            rest.append(parts[index])
        }

        return (parts[0], Substring("\(rest.joined(separator: "/"))"))
    }

}
