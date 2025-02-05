

import UIKit
import Firebase

class RegisterationForm: UIScrollView {
    
    var fullname:TextField={
        let text = TextField()
        text.placeholder = "Full Name"
        text.tag = 0
        text.textColor = .Dark
        text.textAlignment = .left
        return text
    }()
    
    var phoneNumber:TextField={
        let text = TextField()
        text.placeholder = "Phone Number"
        text.tag = 1
        text.textColor = .Dark
        text.textAlignment = .left
        text.keyboardType = .numberPad
        return text
    }()
    
    var addresslineone:TextField={
        let text = TextField()
        text.placeholder = "Address Line 1"
        text.tag = 2
        text.textColor = .Dark
        text.textAlignment = .left
        return text
    }()
    
    var addresslinetwo:TextField={
        let text = TextField()
        text.placeholder = "Address Line 2 (optional)"
        text.tag = 3
        text.textColor = .Dark
        text.textAlignment = .left
        return text
    }()

    var city:TextField={
        let text = TextField()
        text.placeholder = "City"
        text.tag = 4
        text.textColor = .Dark
        text.textAlignment = .left
        return text
    }()
    
    var state:TextField={
        let text = TextField()
        text.placeholder = "  State"
        text.tag = 5
        text.textColor = .Dark
        text.textAlignment = .left
        text.isEnabled = true
        text.isUserInteractionEnabled = true
        return text
    }()
    
    var zipcode:TextField={
        let text = TextField()
        text.placeholder = "Zipcode"
        text.tag = 6
        text.textColor = .Dark
        text.keyboardType = .numberPad
        text.textAlignment = .left
        return text
    }()
    
    weak var parentPage:UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addsubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RegisterationForm{
    
    func addsubviews(){
        self.backgroundColor = .clear
        self.clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false

        let view = self
        
        view.addSubview(fullname)
        NSLayoutConstraint.activate([
            fullname.topAnchor.constraint(equalTo: view.topAnchor, constant: .topConstant),
            fullname.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            fullname.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            fullname.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            fullname.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.insertSubview(phoneNumber, belowSubview: fullname)
        NSLayoutConstraint.activate([
            phoneNumber.topAnchor.constraint(equalTo: fullname.bottomAnchor, constant: .topConstant),
            phoneNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            phoneNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            phoneNumber.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            phoneNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        
        view.insertSubview(addresslineone, belowSubview: phoneNumber)
        NSLayoutConstraint.activate([
            addresslineone.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: .topConstant),
            addresslineone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            addresslineone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            addresslineone.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            addresslineone.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.insertSubview(addresslinetwo, belowSubview: addresslineone)
        NSLayoutConstraint.activate([
            addresslinetwo.topAnchor.constraint(equalTo: addresslineone.bottomAnchor, constant: .topConstant),
            addresslinetwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            addresslinetwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            addresslinetwo.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            addresslinetwo.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.insertSubview(city, belowSubview: addresslinetwo)
        NSLayoutConstraint.activate([
            city.topAnchor.constraint(equalTo: addresslinetwo.bottomAnchor, constant: .topConstant),
            city.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            city.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            city.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            city.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        view.insertSubview(state, belowSubview: city)
        NSLayoutConstraint.activate([
            state.topAnchor.constraint(equalTo: city.bottomAnchor, constant: .topConstant),
            state.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            state.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            state.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            state.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        state.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropMenu)))
        
        self.layoutIfNeeded()
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 25, weight: .regular)))
        chevron.tintColor = .Indicator
        chevron.contentMode = .scaleAspectFill
        chevron.frame = CGRect(x: 0, y: 0, width: 25, height: state.frame.height)
        state.leftView = chevron
        
        
        view.insertSubview(zipcode, belowSubview: state)
        NSLayoutConstraint.activate([
            zipcode.topAnchor.constraint(equalTo: state.bottomAnchor, constant: .topConstant),
            zipcode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            zipcode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            zipcode.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            zipcode.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.delegate = self
                textfield.returnKeyType = .next
            }
        }
    }
    
    
    @objc func dropMenu(){
        for views in self.subviews{
            if views.isKind(of: TextField.self){
                views.resignFirstResponder()
            }
        }
        
        if let parent = self.parentPage{
            let origin = self.convert(state.frame.origin, to: parent.view)
            let dropDown = StateDropDown()
            dropDown.position = CGRect(origin: origin, size: state.frame.size)
            dropDown.addsubviews()
            dropDown.modalPresentationStyle = .overFullScreen
            dropDown.delegate = parent as? StateDelegate
            parent.present(dropDown, animated: true, completion: nil)
        }
    }

}

extension RegisterationForm:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            phoneNumber.becomeFirstResponder()
        case 1:
            addresslineone.becomeFirstResponder()
        case 2:
            addresslinetwo.becomeFirstResponder()
        case 3:
            city.becomeFirstResponder()
        case 4:
            dropMenu()
        case 5:
            zipcode.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var length = 0
        switch textField.tag {
        case 0:
            length = 50
        case 1:
            length = 10
        case 2:
            length = 100
        case 3:
            length = 100
        case 4:
            length = 100
        case 6:
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 5
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
}
