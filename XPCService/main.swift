// main.swift
import Foundation

let delegate = ChronusServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
