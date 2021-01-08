//
//  ChronosServiceDelegate.swift
//
//  Created by Morten Nissen on 31/12/2020.
//

import Foundation

class ChronosServiceDelegate: NSObject, NSXPCListenerDelegate {
    private var _remoteObject: ChronosClientProtocol?
    
    // Creates the listener that specifies how the GUI program can communicate with the service
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
   
    // Public getter for the _remoteObject
    // Used so the main program can send data to the GUI
    public func RemoteObject() -> ChronosClientProtocol {
        return self._remoteObject!
    }
}
