
import UIKit
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    var managedObjectContext: NSManagedObjectContext {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    

    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
        return context
    }


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DinerModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print("core stack")
                print(error)
            }
        })
        return container
    }()


    func saveContext(){
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                    print("Main context saved")
                } catch {
                    print(error)
                }
            }
        }
    }

    func saveWorkingContext() {
        do {
            try workingContext.save()
            print("Working context saved")
            saveContext()
        } catch (let error) {
            print(error)
        }
    }
}
