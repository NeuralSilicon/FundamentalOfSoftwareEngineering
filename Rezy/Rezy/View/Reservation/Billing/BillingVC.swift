
import UIKit


class BillingView: UIScrollView {
    
    var titleLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .systemOrange, textAlignment: .left, fontSize: 25, font: .AppleSDGothicNeo_SemiBold)
        label.text = "Credit Card"
        return label
    }()
   
    var nameOnCard:TextField={
        let text = TextField()
        text.placeholder = "Name on card"
        text.tag = 0
        text.textColor = .Dark
        text.textAlignment = .left
        return text
    }()
    
    var cardNumber:TextField={
        let text = TextField()
        text.placeholder = "Card number"
        text.tag = 1
        text.textColor = .Dark
        text.textAlignment = .left
        text.keyboardType = .numberPad
        return text
    }()
    
    var expirationDate:TextField={
        let text = TextField()
        text.placeholder = "Expiration date"
        text.tag = 2
        text.textColor = .Dark
        text.textAlignment = .left
        text.keyboardType = .numberPad
        return text
    }()
    
    var ccv:TextField={
        let text = TextField()
        text.placeholder = "CCV"
        text.tag = 3
        text.textColor = .Dark
        text.textAlignment = .left
        text.keyboardType = .numberPad
        return text
    }()
    
    var isAddresstheSame:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .left, fontSize: 15, font: .AppleSDGothicNeo_SemiBold)
        label.text = "Billing address is the same as users address?"
        return label
    }()
    
    var isAddressSwitch:UISwitch={
       let switc = UISwitch()
        switc.isOn = false
        switc.onTintColor = .systemOrange
        switc.thumbTintColor = .white
        switc.translatesAutoresizingMaskIntoConstraints = false
        return switc
    }()
    
    var registerationForm:RegisterationForm={
        let form = RegisterationForm(frame: .zero)
        form.clipsToBounds = true
        return form
    }()
    
    var saveCard:UIButton={
        let button = UIButton()
        button.Button(text: "Save")
        return button
    }()
    
    var back:UIButton={
        let back = UIButton()
        back.Button(text: "")
        back.setImage(UIImage(systemName: "xmark")?.applyingSymbolConfiguration(.init(pointSize: 25, weight: .regular)), for: .normal)
        back.backgroundColor = .clear
        back.tintColor = .systemOrange
        return back
    }()
    
    var credit = CreditCard()
    weak var parentPage:UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addsubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewAppeared(){
        self.setScrollViewHeight()
    }
}



extension BillingView:UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            cardNumber.becomeFirstResponder()
        case 1:
            expirationDate.becomeFirstResponder()
        case 2:
            ccv.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        textField.layer.borderColor = UIColor.clear.cgColor
        var length = 0
        switch textField.tag {
        case 0:
            length = 50
        case 1:
            length = 12
        case 2:
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: r, with: string)

            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
            } else if updatedText.count == 2 {
                if updatedText <= "12" {
                    textField.text = "\(updatedText)/"
                }
                return false
            } else if updatedText.count == 5 {
                self.expDateValidation(dateStr: updatedText)
            } else if updatedText.count > 5 {
                return false
            }

            return true
        case 3:
            length = 3
        default:
            break
        }
        
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= length
   }
    
    

    func expDateValidation(dateStr:String) {

        // code was taken from https://stackoverflow.com/questions/51631530/format-uitextfield-mm-yy-as-expiration
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user

        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
            } else {
                self.showAlertController()
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                   print("Entered Date Is Right")
                } else {
                    self.showAlertController()
                }
            } else {
                self.showAlertController()
            }
        } else {
            self.showAlertController()
        }

    }
    
    func showAlertController(){
        let alert = UIAlertController(title: "Wrong Date", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        if let parent = self.parentPage as? ReserveVC{
            parent.present(alert, animated: true, completion: nil)
        }
    }
}
