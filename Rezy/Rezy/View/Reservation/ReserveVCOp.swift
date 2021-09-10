
import UIKit
import CoreData

extension ReserveVC{
    
    //MARK: - Background
    func fetchDinerInfo(){
        AvailabilityStack.shared.FetchWithID(entity: .availability, id: .dinerUUID, uuid: self.model.diner.dinerUUID!) { avail in
            self.model.avail = avail
        }
        TimeStack.shared.FetchWithID(entity: .time, id: .dinerUUID, uuid: self.model.diner.dinerUUID!) { times in
            self.model.time = times
        }
        ReservationHandler.shared.retrieveReservations()
        ReservationHandler.shared.group.notify(queue: .global(qos: .background)) {
            self.model.reservations = ReservationHandler.shared.reservations
        }
    }
    
    //MARK: - Main
    func bringScrollViewToFront(){
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.scrollView)
        }
    }
    
    //MARK: - closeDateView
    func closeDateView(){
        guard isDateViewOpen else{
            return
        }
        isDateViewOpen = false
        self.dateView.updateConstraint(attribute: .height, constant: 0)
    }
    
    //MARK: - Step 1
    @objc func promptDateView(){
        guard !isDateViewOpen else{
            closeDateView()
            return
        }
        isDateViewOpen = true
        self.dateView.updateConstraint(attribute: .height, constant: 450)
    }
    
    func hidePayment(){
        self.payment.updateConstraint(attribute: .height, constant: 0)
    }
    func showPayment(){
        self.payment.updateConstraint(attribute: .height, constant: 50)

    }
        
    //MARK: - Step 2
    @objc func promptReservationForm(){
        closeDateView()
        
        func bringSubviewForward(){
            self.view.bringSubviewToFront(self.reservationForm)
            self.reservationForm.fullname.becomeFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self.reservationForm.transform = .identity
            }
        }
        
        guard !self.model.isGuest else {
            let alertController = UIAlertController(title: "Would you like to register as user?", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.promptToRegister()
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                bringSubviewForward()
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        bringSubviewForward()
    }
    
    func removeRegisForm(){
        UIView.animate(withDuration: 0.3) {
            self.reservationForm.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        } completion: { _ in
            self.view.bringSubviewToFront(self.scrollView)
        }
    }
    
    @objc func promptToRegister(){
        let vc = RVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    

    //MARK: - Step 4
    @objc func promptPayment(){
        closeDateView()
        self.view.bringSubviewToFront(self.billingView)
        self.billingView.nameOnCard.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.billingView.transform = .identity
        }
    }
    
    func removeBilling(){
        UIView.animate(withDuration: 0.3) {
            self.billingView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        } completion: { _ in
            self.view.bringSubviewToFront(self.billingView)
        }
    }
    
    //MARK: - Step 5
    @objc func checkCredential(){
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        checkTable()
    }
       
}


