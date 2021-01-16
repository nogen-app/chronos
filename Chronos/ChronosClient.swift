//
//  ChronosClient.swift
//  Chronos
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

class ChronosClient: NSObject, ChronosClientProtocol {
    func updateClock(_ date: Date) {
        // This function is called by the XPCService every other second
        observerManager.updateTime(date: date)
    }
}
