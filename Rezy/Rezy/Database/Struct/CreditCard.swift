
import Foundation
import Firebase

struct CreditCard{
    var useruuid: String = ""
    
    var nameOnCard: String = ""
    var cardNumber: String = ""
    var expirationDate: String = ""
    var ccv: String = ""
    
    var fullname:String = ""
    var phoneNumber: String = ""
    var addressLineOne: String = ""
    var addressLineTwo: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""
    
    init() {}

    init(from dictionary: [String: Any]) {
        useruuid = dictionary["useruuid"] as! String
        
        nameOnCard = dictionary["nameOnCard"] as! String
        cardNumber = dictionary["cardNumber"] as! String
        expirationDate = dictionary["expirationDate"] as! String
        ccv = dictionary["ccv"] as! String
        
        fullname = dictionary["fullname"] as! String
        phoneNumber = dictionary["phoneNumber"] as! String
        addressLineOne = dictionary["addressLineOne"] as! String
        addressLineTwo = dictionary["addressLineTwo"] as! String
        city = dictionary["city"] as! String
        state = dictionary["state"] as! String
        zipcode = dictionary["zipcode"] as! String
    }

    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let uuid = value["useruuid"] as? String,
        
        let nameOnCard = value["nameOnCard"] as? String,
        let cardNumber = value["cardNumber"] as? String,
        let expirationDate = value["expirationDate"] as? String,
        let ccv = value["ccv"] as? String,
        
        let fullname = value["fullname"] as? String,
        let pn = value["phoneNumber"] as? String,
        let addressLineOne = value["addressLineOne"] as? String,
        let addressLineTwo = value["addressLineTwo"] as? String,
        let city = value["city"] as? String,
        let state = value["state"] as? String,
        let zipcode = value["zipcode"] as? String
        else {
        return
      }
        self.useruuid = uuid
        
        self.nameOnCard = nameOnCard
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.ccv = ccv
        
        self.fullname = fullname
        self.phoneNumber = pn
        self.addressLineOne = addressLineOne
        self.addressLineTwo = addressLineTwo
        self.city = city
        self.state = state
        self.zipcode = zipcode
    }
    
    func asPropertyList() -> [String: Any] {
        return ["useruuid": useruuid,
                
                "nameOnCard":nameOnCard,
                "cardNumber": cardNumber,
                "expirationDate":expirationDate,
                "ccv": ccv,
                
                "fullname": fullname,
                "phoneNumber":phoneNumber,
                "addressLineOne": addressLineOne,
                "addressLineTwo":addressLineTwo,
                "city": city,
                "state": state,"zipcode":zipcode]
    }

}
