// main.swift
import Foundation


// Global struct used to save the picked timezone
struct SavedTimezone {
    static var timezone: TimeZone?
}

let delegate = ChronosServiceDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
// Starts a new background thread
var timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now(), repeating: .seconds(1))
timer.setEventHandler(handler: {
    /*
    Checks if there is a timezone saved
    This will only be true after the connection has been initialized with the GUI, and the service has been told its timezone This is done to clear race conditioning were the service would boot quicker in certain cases, therfore the timer would trigger before the gui had time to send the timezone, and it would crash the service trying to convert the nil timezone
     **/
    if SavedTimezone.timezone != nil {
        // If there is a timezone saved
        // Send a message over IPC to tell gui to update with the timezones date
        delegate.RemoteObject().updateClock(TimezoneUtil.getDate(timezone: SavedTimezone.timezone!))
    }
})
timer.resume()

// Starts the NSXPCListener
listener.resume()
