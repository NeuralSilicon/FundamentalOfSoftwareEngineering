
import Foundation
import Firebase
import os

protocol RegisterationDelegate {
    func savedClient(value:Bool)
    func createdUser(value:Bool)
}

class Registeration{
    
    var client:Client!
    var address:Address!
    var ref: DatabaseReference!
    var delegate:RegisterationDelegate?
    
    init(client:Client, address:Address) {
        ref = Database.database(url: .firebase).reference(); self.client = client
        self.address = address
    }
    
    init() {
        ref = Database.database(url: .firebase).reference()
    }
    
    func createUser(){
         Auth.auth().createUser(withEmail: (self.client.username), password: (self.client.password)) { (result, error) in
            if let _eror = error {
                print(_eror.localizedDescription )
                self.delegate?.createdUser(value: false)
            }else{
                UserDefaults.standard.setValue(result?.user.uid, forKey: "uuid")
                UserDefaults.standard.setValue(self.client.password, forKey: "password")
                
                self.setLoginDefaultValue()
                self.delegate?.createdUser(value: true)
            }
        }
    }
    
    func saveClient(){
        do{
            self.client.password = try Encryption().aesEncrypt(KEY: "keykeykeykeykeyk", IV: "drowssapdrowssap", password: self.client.password)
        }
        catch{
            os_log("failed to encrypt")
        }
        self.ref.child("Client").child(self.client.uuid).child("User").setValue(self.client.asPropertyList())
        self.ref.child("Client").child(self.client.uuid).child("Address").setValue(self.address.asPropertyList())
  
        self.delegate?.savedClient(value: true)
    }
    
    func createGuest(){
        Auth.auth().signInAnonymously { authResult, error in
            if let _eror = error {
                print(_eror.localizedDescription )
                self.delegate?.createdUser(value: false)
            }else{
                guard let user = authResult?.user else { return }
                UserDefaults.standard.setValue(user.uid, forKey: "guestid")
                
                self.setLoginDefaultValue()
                self.delegate?.createdUser(value: true)
            }
        }
    }
    
    func convertAccountToPerm(){
        let credential = EmailAuthProvider.credential(withEmail: self.client.username, password: self.client.password)
        Auth.auth().currentUser?.link(with: credential, completion: { Result, error in
            if let _eror = error {
                print(_eror.localizedDescription, "ConvertAccountToPerm" )
                self.delegate?.createdUser(value: false)
            }else{
                guard let id = UserDefaults.standard.value(forKey: "guestid") as? String else {return}
                UserDefaults.standard.setValue(nil, forKey: "guestid")
                UserDefaults.standard.setValue(id, forKey: "uuid")
                UserDefaults.standard.setValue(self.client.password, forKey: "password")
                
                self.setLoginDefaultValue()
                self.delegate?.createdUser(value: true)
            }
        })
    }
    
    func setLoginDefaultValue(){
        UserDefaults.standard.setValue(true, forKey: "loggedin")
    }
}

