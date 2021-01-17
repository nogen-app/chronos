import Foundation
import CoreData

public class Database {
    internal let _persistentContainer: NSPersistentContainer!
    internal let _context: NSManagedObjectContext
    
    init(_ persistentContainer: NSPersistentContainer) {
        _persistentContainer = persistentContainer
        _context = persistentContainer.viewContext
    }
}
