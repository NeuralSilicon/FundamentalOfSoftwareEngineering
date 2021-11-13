
import Foundation
import Firebase

struct Reservation {
    var useruuid: String = UUID.init().uuidString
    var reservationUUID: String = ""
    var dinerUUID: String = ""
    var timeUUID: String = ""
    var dateUUID: String = ""
    var fullname: String = ""
    var email:String = ""
    var phoneNumber: String = ""
    var table:String = ""
    var numberOfGuest: Int = 0
    var noShowCharge: Bool = false
    var date: String = ""
    var time: String = ""
    
    init() {}
    init(reservation:Reservation) {
        self = reservation
    }

    init(from dictionary: [String: Any]) {
        useruuid = dictionary["useruuid"] as! String
        reservationUUID = dictionary["reservationUUID"] as! String
        dinerUUID = dictionary["dinerUUID"] as! String
        timeUUID = dictionary["timeUUID"] as! String
        dateUUID = dictionary["dateUUID"] as! String
        fullname = dictionary["fullname"] as! String
        email = dictionary["email"] as! String
        phoneNumber = dictionary["phoneNumber"] as! String
        table = dictionary["table"] as! String
        numberOfGuest = dictionary["numberOfGuest"] as! Int
        noShowCharge = dictionary["noShowCharge"] as! Bool
        date = dictionary["date"] as! String
        time = dictionary["time"] as! String
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let dictionary = snapshot.value as? [String: AnyObject],
        let uuid = dictionary["useruuid"] as? String,
        let reservationUUID = dictionary["reservationUUID"] as? String,
        let dinerUUID = dictionary["dinerUUID"] as? String,
        let timeUUID = dictionary["timeUUID"] as? String,
        let dateUUID = dictionary["dateUUID"] as? String,
        let fullname = dictionary["fullname"] as? String,
        let email = dictionary["email"] as? String,
        let phoneNumber = dictionary["phoneNumber"] as? String,
        let table = dictionary["table"] as? String,
        let numberOfGuest = dictionary["numberOfGuest"] as? Int,
        let noShowCharge = dictionary["noShowCharge"] as? Bool,
        let date = dictionary["date"] as? String,
        let time = dictionary["time"] as? String
        else {
        return
      }

        self.useruuid = uuid
        self.reservationUUID = reservationUUID
        self.dinerUUID = dinerUUID
        self.timeUUID = timeUUID
        self.dateUUID = dateUUID
        self.fullname = fullname
        self.email = email
        self.phoneNumber = phoneNumber
        self.table = table
        self.numberOfGuest = numberOfGuest
        self.noShowCharge = noShowCharge
        self.date = date
        self.time = time
    }


    func asPropertyList() -> [String: Any] {
        return ["useruuid": useruuid,
                "reservationUUID": reservationUUID,
                "dinerUUID": dinerUUID,
                "timeUUID": timeUUID,"dateUUID": dateUUID,
                "fullname":fullname, "email":email,"phoneNumber":phoneNumber,
                "table": table,
                "numberOfGuest":numberOfGuest,"noShowCharge":noShowCharge,
                "date":date,"time":time
        ]
    }

}
