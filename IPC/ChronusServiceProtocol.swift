//
//  ChronusServiceProtocol.swift
//  Chronos
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

@objc public protocol ChronusServiceProtocol {
    func chooseTimezone(_ timezone: TimeZone, withReply reply: @escaping (String) -> Void)
}
