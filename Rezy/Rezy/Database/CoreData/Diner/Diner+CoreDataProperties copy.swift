//
//  Diner+CoreDataProperties.swift
//  
//
//  Created by Ian Cooper on 9/2/21.
//
//

import Foundation
import CoreData


extension Diner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diner> {
        return NSFetchRequest<Diner>(entityName: "Diner")
    }

    @NSManaged public var dinerUUID: UUID?
    @NSManaged public var address: String?
    @NSManaged public var url: String?
    @NSManaged public var table: String?
    @NSManaged public var name: String?
    @NSManaged public var reviews: String?

}
