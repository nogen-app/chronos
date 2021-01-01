//
//  TimezoneUtil.swift
//  XPCService
//
//  Created by Morten Nissen on 01/01/2021.
//

import Foundation

class TimezoneUtil {
    
    func getDate(_ timezone: TimeZone) -> Date {
        let now = Date()
        let formatter = DateFormatter()
        let stringFormatter = DateFormatter()
        formatter.timeZone = timezone
        return formatter.date(from: stringFormatter.string(from: now))!
    }
}
