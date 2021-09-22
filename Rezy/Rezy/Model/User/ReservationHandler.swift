
import Foundation
import Firebase
import os

protocol ReservationHandlerDelegate:AnyObject {
    func finishedUp()
}

class ReservationHandler{
    static let shared = ReservationHandler()
    
    var creditCard:CreditCard!
    var reservation:Reservation!
    var ref: DatabaseReference!
    weak var delegate:ReservationHandlerDelegate?
    var group = DispatchGroup()
    var reservations:[Reservation] = []
    
    init(reservation:Reservation, creditCard:CreditCard? = nil) {
        ref = Database.database(url: .firebase).reference(); self.reservation = reservation
        self.creditCard = creditCard
    }
    
    init() {
        ref = Database.database(url: .firebase).reference()
    }
    
    func SaveReservation(){
        let uuid = UserDefaults.standard.value(forKey: "uuid") != nil ?
            UserDefaults.standard.value(forKey: "uuid") as? String : UserDefaults.standard.value(forKey: "guestid") as? String
        guard let uuid = uuid else {return}

        self.ref.child("Client").child(uuid).child("Reservation").child(reservation.reservationUUID).setValue(self.reservation.asPropertyList())
        
        guard creditCard != nil else {
            self.delegate?.finishedUp()
            print("Successfully Save Reservation")
            return
        }
        
        self.ref.child("Client").child(uuid).child("CreditCard").setValue(self.creditCard.asPropertyList())
        print("Successfully Save Reservation")
        self.delegate?.finishedUp()
    }
    
    
    func retrieveReservations(){
        let uuid = UserDefaults.standard.value(forKey: "uuid") != nil ?
            UserDefaults.standard.value(forKey: "uuid") as? String : UserDefaults.standard.value(forKey: "guestid") as? String
        guard let uuid = uuid else {return}
        
        
        self.group.enter()
        let userRef = self.ref.child("Client").child(uuid).child("Reservation")
        self.reservations = []
        userRef.observe(.value, with: { snapshot in
         
            if !snapshot.hasChildren(){
                self.group.leave()
                userRef.removeAllObservers()
                return
            }
            for child in snapshot.children{
                guard let snap = child as? DataSnapshot, let reserved = Reservation.init(snapshot: snap) else{
                    self.group.leave()
                    userRef.removeAllObservers()
                    return
                }
            
                self.reservations.append(reserved)
            }
            self.group.leave()
            userRef.removeAllObservers()
        })
    }
    
    
    func DeleteReservation(with id:String){
        
        let uuid = UserDefaults.standard.value(forKey: "uuid") != nil ?
            UserDefaults.standard.value(forKey: "uuid") as? String : UserDefaults.standard.value(forKey: "guestid") as? String
        guard let uuid = uuid else {return}
        
        self.group.enter()
        
        self.ref.child("Client").child(uuid).child("Reservation").child(id).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        self.group.leave()
    }
}

