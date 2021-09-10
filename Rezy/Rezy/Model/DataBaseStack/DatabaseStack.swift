
import Foundation
import Firebase

class DatabaseStack{
    static var shared = DatabaseStack()
    var group = DispatchGroup()
    var group2 = DispatchGroup()
    
    var client:Client!
    var address:Address!
    var creditcard:CreditCard!
    
    
    var ref: DatabaseReference!
    private var uuid:String?
    
    init() {
        ref = Database.database(url: .firebase).reference()
        self.uuid = UserDefaults.standard.value(forKey: "uuid") as? String ?? nil
    }
    

    func RetrieveAddress(){
        guard let uuid = UserDefaults.standard.value(forKey: "uuid") as? String else {
            return
        }
        self.address = Address()
        self.group.enter()
        let addressRef = self.ref.child("Client").child(uuid).child("Address")
        addressRef.observe(.value, with: { snapshot in

            if !snapshot.hasChildren(){
                self.group.leave()
                addressRef.removeAllObservers()
                return
            }
            self.address = Address.init(snapshot: snapshot)
      
            self.group.leave()
            addressRef.removeAllObservers()
        })
    }
    
    func RetrieveClient(){
        guard let uuid = UserDefaults.standard.value(forKey: "uuid") as? String else {
            return
        }
        self.group.enter()
        let userRef = self.ref.child("Client").child(uuid).child("User")
        
        userRef.observe(.value, with: { snapshot in
         
            if !snapshot.hasChildren(){
                self.group.leave()
                userRef.removeAllObservers()
                return
            }
     
            self.client = Client.init(snapshot: snapshot)
            self.group.leave()
            userRef.removeAllObservers()
        })
        
    }
    
    func DownloadUserInfo(){
        guard let uuid = self.uuid else{return}
        
        self.group.enter()
        let userRef = self.ref.child("Client").child(uuid)
        
        func removeObserver(){
            self.group.leave()
            userRef.removeAllObservers()
        }
        
        userRef.observe(.value) { snapshot in
            if !snapshot.hasChildren(){
                removeObserver()
                print("has no children")
                return
            }
            guard let dict = snapshot.value as? [String:Any] else{
                removeObserver()
                print("cant find value")
                return
            }
            
            if dict["User"] != nil, let user = dict["User"] as? [String : Any]{
                self.client = Client.init(from: user)
                print("Downloaded User")
            }
            if dict["Address"] != nil, let address = dict["Address"] as? [String : Any]{
                self.address = Address.init(from: address)
                print("Downloaded Address")
            }
            if dict["CreditCard"] != nil, let credit = dict["CreditCard"] as? [String : Any]{
                self.creditcard = CreditCard.init(from: credit)
                print("Downloaded Creditcard")
            }
            
            removeObserver()
        }
    }
        
    func retrieveAddressClient(){
        guard let uuid = UserDefaults.standard.value(forKey: "uuid") as? String else {
            return
        }
        self.group2.enter()
        self.group.enter()
        let userRef = self.ref.child("Client").child(uuid).child("User")
        
        userRef.observe(.value, with: { snapshot in
         
            if !snapshot.hasChildren(){
                self.group.leave()
                userRef.removeAllObservers()
                return
            }
            
            self.client = Client.init(snapshot: snapshot)
            
            self.group.leave()
            userRef.removeAllObservers()
        })
        
        self.group.notify(queue: .main) {
            self.address = Address()
            let addressRef = self.ref.child("Client").child(uuid).child("Address")
            addressRef.observe(.value, with: { snapshot in

                if !snapshot.hasChildren(){
                    self.group2.leave()
                    addressRef.removeAllObservers()
                    return
                }
                self.address = Address.init(snapshot: snapshot)
          
                self.group2.leave()
                addressRef.removeAllObservers()
            })
        }
    }
}
