
import Foundation
import Firebase

struct Client {
    var uuid:String = ""
    var username: String = ""
    var password:String = ""
    var fullname:String = ""
    var points: String = "10"
    var preferredPayment: String = "Credit Card"
    var preferredDiner: String = "1"
    
    init() {}

  init(from dictionary: [String: Any]) {
    uuid = dictionary["uuid"] as! String
    username = dictionary["username"] as! String
    password = dictionary["password"] as! String
    fullname = dictionary["fullname"] as! String
    points = dictionary["points"] as! String
    preferredPayment = dictionary["preferredPayment"] as! String
    preferredDiner = dictionary["preferredDiner"] as! String
  }

    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let uuid = value["uuid"] as? String,
        let username = value["username"] as? String,
        let password = value["password"] as? String,
        let fullname = value["fullname"] as? String,
        let points = value["points"] as? String,
        let preferredPayment = value["preferredPayment"] as? String,
        let preferredDiner = value["preferredDiner"] as? String
        else {
        return
      }
        self.uuid = uuid
        self.username = username
        self.password = password
        self.fullname = fullname
        self.points = points
        self.preferredPayment = preferredPayment
        self.preferredDiner = preferredDiner
    }
    
  func asPropertyList() -> [String: Any] {
    return ["uuid": uuid,
            "username": username, "password": password,
            "fullname": fullname,
            "points": points, "preferredPayment": preferredPayment,
            "preferredDiner": preferredDiner
    ]
  }

}
