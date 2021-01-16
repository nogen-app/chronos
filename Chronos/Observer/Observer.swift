//
//  Observer.swift
//  Chronos
//
//  Created by Morten Nissen on 16/01/2021.
//

import Foundation

public let observerManager = ObserverManager()

public class ObserverManager {
    private lazy var _date: Date = Date.init()
    private lazy var _observers = [Observer]()
    
    func add(observer: Observer) -> Void {
        print("Adding observer")
        _observers.append(observer)
    }
    
    func updateClock(date: Date) -> Void {
        print("Notifying observers of updateClock")
        _date = date
        notifyObservers()
    }
    
    func notifyObservers() {
        _observers.forEach({ $0.updateClock(aDate: _date) })
    }
    
    // gui should create an observer that observes the "updateClock" pattern
    // ChronosClient manager.notify("Date") -> Void
}

protocol Observer {
    
    func updateClock(aDate: Date)
}
