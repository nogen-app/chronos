//
//  ChronosSettings+CoreDataProperties.swift
//  Chronos
//
//  Created by Michael Nissen on 17/01/2021.
//
//

import Foundation
import CoreData


extension ChronosSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChronosSettings> {
        return NSFetchRequest<ChronosSettings>(entityName: "ChronosSettings")
    }

    @NSManaged public var timeZone: String?

}

extension ChronosSettings : Identifiable {

}
