//
//  TimezoneUtil.swift
//  XPCService
//
//  Created by Morten Nissen on 01/01/2021.
//

import Foundation

class TimezoneUtil {
    
    class func getDate(timezone: TimeZone) -> Date {
        let now = Date()
        // Adds the GMT offset of the calendar to the current date, meaning it should return the time in said timezone
        let calendar = Calendar.current
        let timezoneDate = calendar.date(byAdding: .second, value: timezone.secondsFromGMT(), to: now)
        return timezoneDate!;
    }
}
