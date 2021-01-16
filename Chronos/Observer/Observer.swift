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
    
    func updateTime(date: Date) -> Void {
        print("Notifying observers of updateClock")
        _date = date
        notifyObservers()
    }
    
    func notifyObservers() {
        _observers.forEach({ $0.updateTime(_date) })
    }
}

protocol Observer {
    
    func updateTime(_ date: Date)
}
