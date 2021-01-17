import SwiftUI
import Foundation

extension Array where Element:NSMenuItem {
    mutating func sortByTitle() {
        self.sort(by: { $0.title < $1.title })
    }
}
