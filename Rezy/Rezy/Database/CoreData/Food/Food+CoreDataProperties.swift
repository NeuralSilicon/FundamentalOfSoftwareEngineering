//
//  Food+CoreDataProperties.swift
//  
//
//  Created by Ian Cooper on 9/5/21.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var img: String?
    @NSManaged public var descriptions: String?

}
