//
//  ChronosService.swift
//
//  Created by Morten Nissen on 31/12/2020.
//
import Foundation

class ChronosService: NSObject, ChronosServiceProtocol {
    func chooseTimezone(_ timezone: TimeZone, withReply reply: @escaping (Date) -> Void) {
        //let response = string.uppercased()
        let timezoneUtil = TimezoneUtil()
        
        // Saves the timezone in the global struct
        SavedTimezone.timezone = timezone
        
        reply(timezoneUtil.getDate(timezone))
    }
}
