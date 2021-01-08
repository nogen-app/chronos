// main.swift
import Foundation

let delegate = ChronosServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()

