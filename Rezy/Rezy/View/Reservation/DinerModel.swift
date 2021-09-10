
import UIKit


final class DinerModel {
    
    var reservation: Reservation = Reservation()
    
    var reservations: [Reservation] = []
    
    var diner: Diner!
    
    var avail: [Availability] = []
    
    var time: [Time] = []
    
    var creditCard = CreditCard()
    
    var isGuest:Bool={
        return UserDefaults.standard.value(forKey: "guestid") != nil
    }()
    
    var uuid:String={
        return UserDefaults.standard.value(forKey: "guestid") != nil ?
            UserDefaults.standard.value(forKey: "guestid") as! String
        :
            UserDefaults.standard.value(forKey: "uuid") as! String
    }()
    
}
