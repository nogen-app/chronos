//
//  ChronosClient.swift
//  Chronos
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

class ChronosClient: NSObject, ChronosClientProtocol {
    func updateClock(_ date: Date) {
        // This function is called by the XPCService every 3rd second
        //TODO: add the logic that updates the view clock
    }
}
