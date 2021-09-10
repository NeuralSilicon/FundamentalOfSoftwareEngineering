
import UIKit
import os
import CoreData

extension ReserveVC{
    
    //MARK: - Step 1: Check dates and tables
    func checkTable(){
        
        var table = self.model.diner.table
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global(qos: .background).async {
            let date = self.model.avail.filter({$0.date == self.model.reservation.date})

            guard date.count > 0, let first = date.first else {
                self.createAvailAndTime(table!)
                group.leave()
                return
            }
            let time = self.model.time.filter({$0.time == self.model.reservation.time.hour && $0.dateUUID == first.dateUUID})
            guard time.count > 0, let fr = time.first else{
                self.createAvailAndTime(table!)
                group.leave()
                return
            }
            table = fr.table
            self.addmodels(fr, first)
            group.leave()
        }

        group.notify(queue: .main) {
            guard table?.count ?? 0 > 0 else{
                self.alert("No table is available at this time", "Please choose a different hour or day.")
                return
            }
            self.checkPreviousReservation()
        }
    }
    
    private func checkPreviousReservation(){
        if model.reservations.contains(where: {$0.date == model.reservation.date && $0.time.hour == model.reservation.time.hour}){
            self.alert("You already have reservation at this Hour.", "Please choose a different Time!")
            return
        }
        self.reserveTable()
    }
    
    private func reserveTable(){
        guard model.reservation.numberOfGuest != 0 else {
            self.alert("No guest number", "Please fill out the Who section!")
            return
        }
        
        let guestNum = model.reservation.numberOfGuest
        let arr = Array(model.time.last!.table!).map({Int(String($0)) ?? 0})

        guard let result = arr.subSets.lazy.filter({ $0.reduce(0,+) >= guestNum }).sorted(by:{$0.count <= $1.count
            && $0.reduce(0,+) <= $1.reduce(0,+)
        }).first else{
            let activity = UIAlertController(title: nil, message: "Failed to reserve a table, not enough table available!", preferredStyle: .alert)
            activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(activity, animated: true, completion: nil)
            return
        }
        
        model.reservation.table =  result.map{ String($0) }.joined(separator: "")
        checkCreditCard()
    }
    
    
    private func addmodels(_ time:Time,_ avail:Availability){
        self.model.reservation.dateUUID = avail.dateUUID?.uuidString ?? UUID().uuidString
        self.model.reservation.timeUUID = time.timeUUID?.uuidString ?? UUID().uuidString
        self.model.reservation.dinerUUID = time.dinerUUID?.uuidString ?? UUID().uuidString
    }

    private func createAvailAndTime(_ table:String){
        let avail = Availability(context: CoreDataStack.shared.managedObjectContext)
        avail.dinerUUID = model.diner.dinerUUID
        avail.date = model.reservation.date
        avail.dateUUID = UUID.init()


        let time = Time(context: CoreDataStack.shared.managedObjectContext)
        time.dateUUID = avail.dateUUID
        time.dinerUUID = avail.dinerUUID
        time.reservationsUUID = ""
        time.table = table
        time.time = model.reservation.time.hour
        time.timeUUID = UUID.init()


        model.avail.append(avail)
        model.time.append(time)

        addmodels(time, avail)
        os_log("Saved both date and time")
    }

    private func createTime(_ table:String){
        let time = Time(context: CoreDataStack.shared.managedObjectContext)
        guard let avail = self.model.avail.filter({$0.date == self.model.reservation.date}).first else{
            return
        }
        time.dateUUID = avail.dateUUID
        time.dinerUUID = avail.dinerUUID
        time.reservationsUUID = ""
        time.table = table
        time.time = model.reservation.time.hour
        time.timeUUID = UUID.init()

        model.time.append(time)

        addmodels(time, avail)
        os_log("Saved time")
    }
    
    
    
    //MARK: - Step 2: check credit card and billing address
    private func checkCreditCard(){
        guard (isCreditCardNeeded)else {finishChecking();return}
        if UserDefaults.standard.value(forKey: "creditcard") != nil{
            finishChecking()
            return
        }
        guard (!model.creditCard.cardNumber.isEmpty) else{
            self.alert("Credit Card is Required!", "This day has no show charge of $10.")
            return
        }
        
        guard isBillingSameAsAddress else{self.finishChecking();return}
        
        guard DatabaseStack.shared.address != nil, let address = DatabaseStack.shared.address,
              DatabaseStack.shared.client != nil, let user = DatabaseStack.shared.client
            else {
                self.alert("No users address found", "Please fill out the billing address!")
                return
            }
        
        model.creditCard.fullname = user.fullname
        model.creditCard.addressLineOne = address.addressLineOne
        model.creditCard.addressLineTwo = address.addressLineTwo
        model.creditCard.city = address.city
        model.creditCard.state = address.state
        model.creditCard.zipcode = address.zipcode
        

        finishChecking()
    }
    
    //MARK: - Step 3: finalize
    private func finishChecking(){
        
        self.view.bringSubviewToFront(self.wrapUp)
        self.wrapUp.progressBar.animateCircle()
        UIView.animate(withDuration: 0.3) {
            self.wrapUp.transform = .identity
        } completion: { _ in
            self.wrapUp.saveUp()
        }
    }

}
