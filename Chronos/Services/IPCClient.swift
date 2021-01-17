import Foundation
import XPCService

class IPCClient: ObservableObject {
    private var _connection: NSXPCConnection
    private var _service: ChronosServiceProtocol?
    private var _exportedObject: ChronosClient
    
    init(_ serviceName: String) {
        _exportedObject = ChronosClient()
        _connection = NSXPCConnection.init(serviceName: serviceName)
        
        _connection.remoteObjectInterface = NSXPCInterface(with: ChronosServiceProtocol.self)
        _connection.exportedInterface = NSXPCInterface(with: ChronosClientProtocol.self)
        _connection.exportedObject = _exportedObject
        
        _connection.resume()
        _service = _connection.remoteObjectProxyWithErrorHandler{ error in
            fatalError("Received error: \(error)")
        } as? ChronosServiceProtocol
    }
    
    public func chooseTimeZone(_ timeZone: TimeZone) -> Date {
        var result = Date()
        let semaphore = DispatchSemaphore(value: 0)
        
        _service?.chooseTimeZone(timeZone: timeZone){ response in
            result = response
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return result
    }
}
