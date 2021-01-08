//
//  ChronosServiceDelegate.swift
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

class ChronosServiceDelegate: NSObject, NSXPCListenerDelegate {
    private var _remoteObject: ChronosClientProtocol?
    private var _chronosService: ChronosService?
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        _chronosService = ChronosService()
        let exportedObject = _chronosService
        newConnection.exportedInterface = NSXPCInterface(with: ChronosServiceProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.remoteObjectInterface = NSXPCInterface(with: ChronosClientProtocol.self)
        _remoteObject = newConnection.remoteObjectProxyWithErrorHandler({ error in print("XPC error: ", error)
        }) as? ChronosClientProtocol
        
        newConnection.resume()
        return true
    }
    
    public func RemoteObject() -> ChronosClientProtocol {
        return self._remoteObject!
    }
    
    public func ChronosSevice() -> ChronosService {
        return self._chronosService!
    }
    
}
