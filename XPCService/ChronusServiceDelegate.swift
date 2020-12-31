//
//  ChronusServiceDelegate.swift
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

class ChronusServiceDelegate: NSObject, NSXPCListenerDelegate {
    var _remoteObject: ChronusClientProtocol?
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = ChronusService()
        newConnection.exportedInterface = NSXPCInterface(with: ChronusServiceProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
    
    func RemoteObject() -> ChronusClientProtocol {
        return self._remoteObject!
    }
    
}
