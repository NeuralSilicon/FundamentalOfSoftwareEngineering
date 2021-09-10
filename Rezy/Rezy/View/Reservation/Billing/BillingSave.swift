
import UIKit

final class ValidateTextField{
    static func isTextEmpty(_ textfield:UITextField) -> Bool{
        guard let text = textfield.text else {return false}
        if text.isEmpty{
            textfield.addRightView(rightView: "rightVwWarning", tintColor: .red, errorMessage: "Can't be empty!")
            return false
        }
        return true
    }
    static func isValidInput(_ textfield:UITextField,_ length:Int,_ msg:String)->Bool{
        guard let text = textfield.text else {return false}
        if text.count < length{
            textfield.addRightView(rightView: "rightVwWarning", tintColor: .red, errorMessage: msg)
            return false
        }
        return true
    }
    static func isValidNumber(_ textfield:UITextField,_ num:Int,_ msg:String)->Bool{
        guard let text = textfield.text else {return false}
        if Int(text) ?? 0 < num{
            textfield.addRightView(rightView: "rightVwWarning", tintColor: .red, errorMessage: msg)
            return false
        }
        return true
    }
}

extension BillingView{
    
    @objc func saveBilling(){
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.resignFirstResponder()
            }
        }
        
        guard ValidateTextField.isTextEmpty(nameOnCard), ValidateTextField.isTextEmpty(cardNumber), ValidateTextField.isTextEmpty(expirationDate), ValidateTextField.isTextEmpty(ccv),
              ValidateTextField.isValidInput(cardNumber, 12, "Card number is too short!"),
              ValidateTextField.isValidInput(ccv, 3, "CCV is too short!")
              else{
                return
              }
        
        if !isAddressSwitch.isOn{
            guard
                ValidateTextField.isTextEmpty(registerationForm.fullname),
                ValidateTextField.isTextEmpty(registerationForm.phoneNumber),
                ValidateTextField.isTextEmpty(registerationForm.addresslineone),
                ValidateTextField.isTextEmpty(registerationForm.city),
                ValidateTextField.isTextEmpty(registerationForm.state),
                ValidateTextField.isTextEmpty(registerationForm.zipcode),

                ValidateTextField.isValidInput(registerationForm.fullname, 2, "Name is too short!"),
                ValidateTextField.isValidInput(registerationForm.phoneNumber, 10, "Phone number is too short!"),
                ValidateTextField.isValidInput(registerationForm.addresslineone, 5, "Address is too short!"),
                ValidateTextField.isValidInput(registerationForm.city, 2, "City is too short!"),
                ValidateTextField.isValidInput(registerationForm.zipcode, 5, "Zipcode is too short!")
            else{return}
        }
        
        credit.nameOnCard = nameOnCard.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.cardNumber = cardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.expirationDate = expirationDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.ccv = ccv.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        credit.fullname = registerationForm.fullname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.addressLineOne = registerationForm.addresslineone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.addressLineTwo = (registerationForm.addresslinetwo.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        credit.city = registerationForm.city.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.state = registerationForm.state.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.zipcode = registerationForm.zipcode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let parent = self.parentPage as? ReserveVC{
            credit.useruuid = parent.model.uuid
            parent.model.creditCard = credit
            parent.isBillingSameAsAddress = isAddressSwitch.isOn
            parent.removeBilling()
            parent.payment.value = "Ending in \(credit.cardNumber.lastThree)"
        }
    }

}

extension String {
    var lastThree: String {
        if case let chars = self.suffix(3), chars.count > 2 {
            return String(chars)
        }
        return ""
    }
    var hour:String{
        let chars = self.split(separator: ":")[0]
        return String(chars)
    }
}



