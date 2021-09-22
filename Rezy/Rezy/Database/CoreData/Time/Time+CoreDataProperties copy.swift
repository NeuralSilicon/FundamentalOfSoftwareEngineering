//
//  Time+CoreDataProperties.swift
//  
//
//  Created by Ian Cooper on 9/2/21.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var dinerUUID: UUID?
    @NSManaged public var table: String?
    @NSManaged public var time: String?
    @NSManaged public var dateUUID: UUID?
    @NSManaged public var timeUUID: UUID?
    @NSManaged public var reservationsUUID: String?
}
