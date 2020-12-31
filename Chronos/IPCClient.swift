//
//  IPCClient.swift
//  Chronos
//
//  Created by Morten Nissen on 28/12/2020.
//

import Foundation
import XPCService


class IPCClient: ObservableObject {
    var _connection: NSXPCConnection
    var _service: ChronosServiceProtocol?
    var _exportedObject: ChronosClient
    
    init(serviceName: String) {
        _exportedObject = ChronosClient()
        _connection = NSXPCConnection.init(serviceName: serviceName)
        
        _connection.remoteObjectInterface = NSXPCInterface(with: ChronosServiceProtocol.self)
        _connection.exportedInterface = NSXPCInterface(with: ChronosClientProtocol.self)
        _connection.exportedObject = _exportedObject
        
        _connection.resume()
        _service = _connection.remoteObjectProxyWithErrorHandler{ error in
            print("Received error: ", error)
        } as? ChronosServiceProtocol
    }
    
    func chooseTimezone(timezone: TimeZone) -> String {
        var result: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        _service?.chooseTimezone(timezone){ response in
            result = response
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return result
    }
}
