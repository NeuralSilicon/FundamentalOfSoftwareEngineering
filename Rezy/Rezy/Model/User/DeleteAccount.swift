
import UIKit
import Firebase
import os

class DeleteAccount {
    
    var uuid:String?
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database(url: .firebase).reference()
        guard let uuid = UserDefaults.standard.value(forKey: "uuid") as? String else {return}
        self.uuid = uuid
    }
    
    func deleteAccount(deleted:@escaping(Bool)->Void){
        guard let uuid = uuid else {
            print("can't access uuid")
            return
        }
        
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            print(error.localizedDescription)
            deleted(false)
          } else {
            print("user was deleted from cloud")
            self.ref.child("Client").child(uuid).removeValue()
            deleted(true)
          }
        }
        
    }
    
    
}
