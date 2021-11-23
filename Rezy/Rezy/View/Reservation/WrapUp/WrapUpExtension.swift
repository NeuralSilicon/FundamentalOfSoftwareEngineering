//sayra (; 

import UIKit
import Firebase
import CoreData

extension WrapUp{
    
    func saveUp(){
        wrapUpReservation()
    }

    private func wrapUpReservation(){
                
        guard let parent = self.parentPage as? ReserveVC, let model = parent.model else{
            return
        }
        //confirm reservation time
        // UUID generates uique valuee to assure date & timeare available
        guard let time = model.time.filter({$0.time == model.reservation.time.hour && $0.dateUUID == UUID(uuidString: model.reservation.dateUUID)}).first else{ 
            print("failed to load the time")
            return
        }

        if let tab = time.table{
            var str = ""
            var table = model.reservation.table.stringToDict()
            
            for i in tab{
                if table[String(i)] != nil && table[String(i), default: 0] > 0{ //nil - absence of valid object
                    table[String(i), default:0] -= 1
                }else{
                    str.append(i)
                }
            }
            
            time.table = str
        }
      
        if time.reservationsUUID == nil{ //if reseration is not available generata unique 
            time.reservationsUUID = ""
        }
        model.reservation.reservationUUID = UUID.init().uuidString
        time.reservationsUUID?.append("\(model.reservation.reservationUUID),")
  

        model.reservation.useruuid = model.uuid
        model.reservation.timeUUID = time.timeUUID?.uuidString ?? UUID.init().uuidString
        model.reservation.dinerUUID = model.diner.dinerUUID?.uuidString ?? UUID.init().uuidString
        
        CoreDataStack.shared.saveContext()
        
        
        if model.reservation.noShowCharge{
            UserDefaults.standard.setValue(true, forKey: "creditcard")
            let reservation = ReservationHandler(reservation: model.reservation, creditCard: model.creditCard)
            reservation.delegate = parent
            reservation.SaveReservation()
        }else{
            let reservation = ReservationHandler(reservation: model.reservation)
            reservation.delegate = parent
            reservation.SaveReservation() 
        }
    }
}

extension ReserveVC:ReservationHandlerDelegate{
    func finishedUp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            print("Done!") //let user know reservation complete
            self.dismiss(animated: true, completion: nil)
        }
    }
}
