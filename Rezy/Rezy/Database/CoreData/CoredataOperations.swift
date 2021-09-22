
import UIKit
import CoreData

class CoredataOperations<T>{
    
    typealias T = AnyObject
    
    enum Entity:String {
        case diner="Diner"
        case availability="Availability"
        case time="Time"
        case food="Food"
    }
    
    enum UID:String{
        case dinerUUID = "dinerUUID"
        case timeUUID = "timeUUID"
        case reservationsUUID = "reservationsUUID"
        case dateUUID = "dateUUID"
    }
    
    func Fetch(entity:Entity, completion: @escaping ([T]) -> Void){
        let context = CoreDataStack.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        context.perform {
            do {
                if let result = try context.fetch(fetchRequest) as? [T]{
                    completion(result)
                }
            }catch{
                print("Couldn't load user")
            }
        }
    }
    
    func FetchWithID(entity:Entity, id: UID, uuid:UUID, completion: @escaping ([T]) -> Void){
        let context = CoreDataStack.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        let predicate = NSPredicate(format: "\(id.rawValue) == %@", uuid as CVarArg)
        fetchRequest.predicate = predicate
        context.perform {
            do {
                if let result = try context.fetch(fetchRequest) as? [T]{
                    completion(result)
                }
            }catch{
                print("Couldn't load user")
            }
        }
    }
    
    func Save(){
        let context = CoreDataStack.shared
        context.saveContext()
    }
}

class DinerStack: CoredataOperations<Diner> {
    static let shared = DinerStack()
    override func Fetch(entity: CoredataOperations<Diner>.Entity, completion: @escaping ([Diner]) -> Void) {
        super.Fetch(entity: entity) { diner in
            completion(diner)
        }
    }
    override func FetchWithID(entity: CoredataOperations<Diner>.Entity, id: CoredataOperations<Diner>.UID, uuid: UUID, completion: @escaping ([Diner]) -> Void) {
        super.FetchWithID(entity: entity, id: id, uuid: uuid) { diners in
            completion(diners)
        }
    }
    override func Save() {
        super.Save()
    }
}

class FoodStack: CoredataOperations<Food> {
    static let shared = FoodStack()
    
    override func Fetch(entity: CoredataOperations<Food>.Entity, completion: @escaping ([Food]) -> Void) {
        super.Fetch(entity: entity) { diner in
            completion(diner)
        }
    }
    override func FetchWithID(entity: CoredataOperations<Food>.Entity, id: CoredataOperations<Food>.UID, uuid: UUID, completion: @escaping ([Food]) -> Void) {
        super.FetchWithID(entity: entity, id: id, uuid: uuid) { diners in
            completion(diners)
        }
    }
    override func Save() {
        super.Save()
    }
}

class AvailabilityStack: CoredataOperations<Availability> {
    static let shared = AvailabilityStack()
    override func Fetch(entity: CoredataOperations<Availability>.Entity, completion: @escaping ([Availability]) -> Void) {
        super.Fetch(entity: entity) { avail in
            completion(avail)
        }
    }
    
    override func FetchWithID(entity: CoredataOperations<Availability>.Entity, id: CoredataOperations<Availability>.UID, uuid: UUID, completion: @escaping ([Availability]) -> Void) {
        super.FetchWithID(entity: entity, id: id, uuid: uuid) { avails in
            completion(avails)
        }
    }
    
    override func Save() {
        super.Save()
    }
}

class TimeStack: CoredataOperations<Time> {
    static let shared = TimeStack()
    override func Fetch(entity: CoredataOperations<Time>.Entity, completion: @escaping ([Time]) -> Void) {
        super.Fetch(entity: entity) { time in
            completion(time)
        }
    }
    
    override func FetchWithID(entity: CoredataOperations<Time>.Entity, id: CoredataOperations<Time>.UID, uuid: UUID, completion: @escaping ([Time]) -> Void) {
        super.FetchWithID(entity: entity, id: id, uuid: uuid) { times in
            completion(times)
        }
    }
    
    override func Save() {
        super.Save()
    }
}
