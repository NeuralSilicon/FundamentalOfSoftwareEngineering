
import UIKit

class DateView: UIView {

    var datePicker:UIDatePicker={
       let datePicker = UIDatePicker()
        datePicker.calendar = .current
        datePicker.locale = .current
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .red
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    weak var parentPage:UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubivews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubivews(){
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        
        self.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
    }
    
    @objc func datePickerChanged() {
        guard let parent = self.parentPage as? ReserveVC else{
            return
        }
        let toDate = datePicker.date
        let validateDate = Calendar.current.dateComponents([.day], from: Date(), to: toDate)
        if validateDate.day ?? 0 < 0 {
            parent.alert("Date cannot be before today!")
            return
        }
        let date = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: toDate)
        parent.model.reservation.date = String("\(date.month!), \(date.day!), \(date.year!)")
        parent.model.reservation.time = String("\(date.hour!): \(date.minute!)")
        parent.dateLabel.value = "\(date.month!), \(date.day!), \(date.year!) - \(date.hour!): \(date.minute!)"
        
        checkIfneedCreditCard(date: toDate, value: parent.model.reservation.date) ? parent.showPayment() : parent.hidePayment()
    }
    
    func checkIfneedCreditCard(date:Date, value:String) -> Bool{
        let holidays:[String] = [toDate(1,1,2021), toDate(1,18,2021), toDate(2,15,2021)
        , toDate(5,9,2021),toDate(1,31,2021), toDate(6,18,2021), toDate(6,20,2021)
        , toDate(7,4,2021),toDate(7,5,2021), toDate(9,6,2021), toDate(10,11,2021)
        , toDate(11,25,2021), toDate(11,26,2021), toDate(12,24,2021), toDate(12,25,2021)
        , toDate(12,27,2021),toDate(12,30,2021), toDate(12,31,2021)
        ]
        guard let parent = self.parentPage as? ReserveVC else {return false}
        guard (Calendar.current.isDateInWeekend(date) || holidays.contains(value))
        else{
            parent.isCreditCardNeeded = false
            parent.model.reservation.noShowCharge = false
            return false
        }
        parent.isCreditCardNeeded = true
        parent.model.reservation.noShowCharge = true
        return  UserDefaults.standard.value(forKey: "creditcard") == nil ? true : false
    }
    
    func toDate(_ month:Int,_ day:Int,_ year:Int)->String{
        return String("\(month), \(day), \(year)")
    }
    
    func toHour(_ hour:Int, _ minute:Int) -> String{
        return String("\(hour): \(minute)")
    }
}
