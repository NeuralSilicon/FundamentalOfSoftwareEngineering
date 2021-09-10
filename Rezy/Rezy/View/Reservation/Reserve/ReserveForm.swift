
import UIKit


class ReserveForm: UIScrollView {
    
    var titleLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .systemOrange, textAlignment: .left, fontSize: 25, font: .AppleSDGothicNeo_SemiBold)
        label.text = "Who"
        return label
    }()
    
    var fullname:TextField={
        let text = TextField()
        text.placeholder = "Full name"
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
    
    var guestNumber:TextField={
        let text = TextField()
        text.placeholder = "Guest Number"
        text.tag = 2
        text.textColor = .Dark
        text.textAlignment = .left
        text.keyboardType = .numberPad
        return text
    }()
    
    var button:UIButton={
        let button = UIButton()
        button.Button(text: "Done")
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
    
    weak var parentPage:UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addsubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReserveForm{
    
    func addsubviews(){
        self.backgroundColor = .systemBackground
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false

        let view = self
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: .topConstant),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.addSubview(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.topAnchor, constant: .topConstant*2),
            back.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            back.widthAnchor.constraint(equalToConstant: 35),
            back.heightAnchor.constraint(equalToConstant: 35)
        ])
        back.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        
        view.addSubview(fullname)
        NSLayoutConstraint.activate([
            fullname.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .topConstant),
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
        
        
        view.insertSubview(guestNumber, belowSubview: phoneNumber)
        NSLayoutConstraint.activate([
            guestNumber.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: .topConstant),
            guestNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            guestNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            guestNumber.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            guestNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.insertSubview(button, belowSubview: guestNumber)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: guestNumber.bottomAnchor, constant: .topStandAloneConstant),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 140),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        button.addTarget(self, action: #selector(doneB), for: .touchUpInside)
        
        self.layoutIfNeeded()
                
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.delegate = self
                textfield.returnKeyType = .next
            }
        }
        
        if let parent = self.parentPage as? ReserveVC{
            fullname.text = parent.model.reservation.fullname
            phoneNumber.text = parent.model.reservation.phoneNumber
            guestNumber.text = String(parent.model.reservation.numberOfGuest)
        }
    }
    
    @objc func dismissPage(){
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.resignFirstResponder()
            }
        }
        if let parent = self.parentPage as? ReserveVC{
            parent.removeRegisForm()
        }
    }
    
    @objc private func doneB(){
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.resignFirstResponder()
            }
        }
        guard
            ValidateTextField.isTextEmpty(fullname),
            ValidateTextField.isTextEmpty(phoneNumber),
            ValidateTextField.isTextEmpty(guestNumber),
            
            ValidateTextField.isValidInput(fullname, 3, "Name is too short!"),
            ValidateTextField.isValidInput(phoneNumber, 10, "Phone number is too short!"),
            ValidateTextField.isValidInput(guestNumber, 1, "Guest can't be empty!"),
            ValidateTextField.isValidNumber(guestNumber, 1, "Guest can't be 0, it has to be at least 1!"),
              let guestNum = Int(self.guestNumber.text!)  else{
            return
        }
     
        if let parent = self.parentPage as? ReserveVC{
            
            parent.model.reservation.fullname = fullname.text!
            parent.model.reservation.numberOfGuest = guestNum
            parent.model.reservation.phoneNumber = phoneNumber.text!
            parent.underNameLabel.value = fullname.text!
            parent.removeRegisForm()
            
        }
    }
    
}

extension RangeReplaceableCollection  {
    var subSets: [SubSequence] {
        return isEmpty ? [SubSequence()] : dropFirst().subSets.lazy.flatMap { [$0, prefix(1) + $0] }
    }
}

extension ReserveForm:UITextFieldDelegate{

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
            guestNumber.becomeFirstResponder()
        case 2:
            guestNumber.resignFirstResponder()
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
            length = 2
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
