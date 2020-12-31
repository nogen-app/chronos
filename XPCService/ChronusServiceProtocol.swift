//
//  ChronusServiceProtocol.swift
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

@objc public protocol ChronusServiceProtocol {
    func upperCaseString(_ string: String, withReply reply: @escaping (String) -> Void)
}
