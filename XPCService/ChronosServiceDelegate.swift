//
//  ChronosServiceDelegate.swift
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

class ChronosServiceDelegate: NSObject, NSXPCListenerDelegate {
    var _remoteObject: ChronosClientProtocol?
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = ChronosService()
        newConnection.exportedInterface = NSXPCInterface(with: ChronosServiceProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.remoteObjectInterface = NSXPCInterface(with: ChronosClientProtocol.self)
        _remoteObject = newConnection.remoteObjectProxyWithErrorHandler({ error in print("XPC error: ", error)
        }) as? ChronosClientProtocol
        
        newConnection.resume()
        return true
    }
    
    func RemoteObject() -> ChronosClientProtocol {
        return self._remoteObject!
    }
    
}
