import Foundation

public class ObserverManager {
    private lazy var _date: Date = Date.init()
    private lazy var _observers = [Observer]()
    
    public func add(_ observer: Observer) -> Void {
        _observers.append(observer)
    }
    
    public func refreshView(_ date: Date) -> Void {
        _date = date
        notifyObservers()
    }
    
    private func notifyObservers() {
        _observers.forEach({ $0.refreshView(_date) })
    }
}
