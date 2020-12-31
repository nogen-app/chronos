//
//  ChronosService.swift
//
//  Created by Morten Nissen on 31/12/2020.
//
import Foundation

class ChronosService: NSObject, ChronosServiceProtocol {
    func chooseTimezone(_ timezone: TimeZone, withReply reply: @escaping (String) -> Void) {
        //let response = string.uppercased()
        reply("Succesful")
    }
}
