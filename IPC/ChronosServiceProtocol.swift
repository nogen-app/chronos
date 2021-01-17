import Foundation

@objc public protocol ChronosServiceProtocol {
    func chooseTimeZone(timeZone: TimeZone, withReply reply: @escaping (Date) -> Void)
}
