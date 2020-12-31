//
//  ChronusClientProtocol.swift
//  Chronos
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

@objc public protocol ChronusClientProtocol {
    func updateClock(_ date: Date)
}
