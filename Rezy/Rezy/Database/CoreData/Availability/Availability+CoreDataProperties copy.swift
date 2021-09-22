//
//  Availability+CoreDataProperties.swift
//  
//
//  Created by Ian Cooper on 9/2/21.
//
//

import Foundation
import CoreData


extension Availability {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Availability> {
        return NSFetchRequest<Availability>(entityName: "Availability")
    }

    @NSManaged public var dinerUUID: UUID?
    @NSManaged public var date: String?
    @NSManaged public var dateUUID: UUID?

}
