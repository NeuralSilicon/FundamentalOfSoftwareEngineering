
import Foundation
import Firebase
import os

protocol LoginDelegate {
    func succeeded(value:Bool)
}

class Login{
    
    var username:String!; var password:String!
    var ref: DatabaseReference!
    var delegate:LoginDelegate?
    
    init(username:String, password:String) {
        ref = Database.database(url: .firebase).reference()
        self.username = username ;  self.password = password
    }
    
    func signIn(){
        Auth.auth().signIn(withEmail: (self.username), password: (self.password)) { (result, error) in
            if let _eror = error{
                    print(_eror.localizedDescription)
            }else{
                print("signed in ")
            }
        }
    }
    
    func signInAnonymous(){
        Auth.auth().signInAnonymously { Result, error in
            if let _eror = error{
                    print(_eror.localizedDescription)
            }else{
                print("signed in ")
            }
        }
    }
    
    func fetchUser(succeeded:@escaping (Bool) ->Void){
        Auth.auth().signIn(withEmail: (self.username), password: (self.password)) { (result, error) in
            if let _eror = error{
                    print(_eror.localizedDescription)
                succeeded(false)
            }else{
                if let _res = result{
                    print(_res)
                    guard let uuid = Auth.auth().currentUser?.uid else {
                        succeeded(false)
                        return
                    }
                    UserDefaults.standard.setValue(uuid, forKey: "uuid")
                    UserDefaults.standard.setValue(self.password, forKey: "password")
                    
                    do{
                        self.password = try Encryption().aesEncrypt(KEY: "keykeykeykeykeyk", IV: "drowssapdrowssap", password: self.password)
                    }
                    catch{
                        os_log("failed to encrypt")
                    }
                    self.ref.child("Client").child(uuid).child("User").child("password").setValue(self.password)
                    self.setLoginDefaultValue()
                    succeeded(true)
                }
            }
        }
    }

    func setLoginDefaultValue(){
        UserDefaults.standard.setValue(true, forKey: "loggedin")
    }
    
}
