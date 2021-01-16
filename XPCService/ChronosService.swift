//
//  ChronosService.swift
//
//  Created by Morten Nissen on 31/12/2020.
//
import Foundation

class ChronosService: NSObject, ChronosServiceProtocol {
    func chooseTimezone(_ timezone: TimeZone, withReply reply: @escaping (Date) -> Void) {
        // Saves the selected timezone in the global struct
        SavedTimezone.timezone = timezone
        
        
        // Reply to the gui with the current time for given timezone
        reply(TimezoneUtil.getDate(timezone: timezone))
    }
}
