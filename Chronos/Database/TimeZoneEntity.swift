import Foundation
import CoreData

public class TimeZoneEntity: Database {
    private let _entityName: String

    init(_ persistentContainer: NSPersistentContainer, entityName: String) {
        self._entityName = entityName

        super.init(persistentContainer)
    }
    
    public func readTimeZone() -> String? {
        let request = NSFetchRequest<ChronosSettings>(entityName: _entityName)
        
        do {
            let result = try _context.fetch(request)

            return result.count > 0 ? result[0].timeZone : nil
        } catch {
            fatalError("\(error)")
        }
    }
    
    public func createTimeZone(_ timeZone: String) -> Void {
        let entity = NSEntityDescription.entity(forEntityName: _entityName, in: _context)
        
        let managedObject = NSManagedObject(entity: entity!, insertInto: _context)
        
        managedObject.setValue(timeZone, forKey: "timeZone")
        
        do {
            try _context.save()
        } catch {
            fatalError("\(error)")
        }
    }

    public func updateTimeZone(_ timeZone: String) -> Void {
        let request = NSFetchRequest<ChronosSettings>(entityName: _entityName)
        
        do {
            let result = try _context.fetch(request)

            result[0].setValue(timeZone, forKey: "timeZone")
            try _context.save()
        } catch {
            fatalError("\(error)")
        }
    }
}
