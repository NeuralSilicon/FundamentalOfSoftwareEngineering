

import UIKit

extension UpdateCreditCardVC{
    
    func addsubviews(){
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant + .topConstant),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])

        password.delegate = self
        view.addSubview(password)
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            password.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(passwordRequirement)
        NSLayoutConstraint.activate([
            passwordRequirement.topAnchor.constraint(equalTo: password.bottomAnchor, constant: .topConstant),
            passwordRequirement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            passwordRequirement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            passwordRequirement.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            passwordRequirement.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        view.addSubview(loadmore)
        NSLayoutConstraint.activate([
            loadmore.topAnchor.constraint(equalTo: passwordRequirement.bottomAnchor, constant: .topConstant),
            loadmore.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadmore.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            loadmore.heightAnchor.constraint(equalToConstant: 40),
        ])
        loadmore.addTarget(self, action: #selector(LoadMore), for: .touchUpInside)
    
    }
    
    @objc private func LoadMore(){

        if !checkUserPass(){
            let activity = UIAlertController(title: nil, message: "Password is either empty or is not correct", preferredStyle: .alert)
            activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(activity, animated: true, completion: nil)
            return
        }
        self.password.resignFirstResponder()
                
        billingView = BillingView(frame: self.view.bounds)
        billingView.parentPage = self
        billingView.saveCard.isHidden = true
        billingView.back.isHidden = true
        billingView.isAddressSwitch.isOn = false
        billingView.addressSwitch()
        billingView.clipsToBounds = true
        view.addSubview(billingView)
        NSLayoutConstraint.activate([
            billingView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            billingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            billingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            billingView.heightAnchor.constraint(equalToConstant: view.frame.height*0.8),
            billingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.billingView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.billingView.setScrollViewHeight()
            self.billingView.contentSize.height += 200
        })
        
        view.addSubview(update)
        NSLayoutConstraint.activate([
            update.topAnchor.constraint(equalTo: billingView.bottomAnchor),
            update.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            update.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            update.heightAnchor.constraint(equalToConstant: 40),
        ])
        update.addTarget(self, action: #selector(updateInformation), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5) {
            self.password.alpha = 0.0; self.loadmore.alpha = 0.0; self.passwordRequirement.alpha = 0.0
            self.billingView.transform = .identity
        }
        
        guard credit != nil else {
            self.update.Button(text: "Add")
            return
        }
        
        billingView.nameOnCard.text = credit.nameOnCard
        billingView.cardNumber.text = credit.cardNumber
        billingView.expirationDate.text = credit.expirationDate
        billingView.ccv.text = credit.ccv
        
        billingView.registerationForm.fullname.text = credit.fullname
        billingView.registerationForm.phoneNumber.text = credit.phoneNumber
        billingView.registerationForm.addresslineone.text = credit.addressLineOne
        billingView.registerationForm.addresslinetwo.text = credit.addressLineTwo
        billingView.registerationForm.city.text = credit.city
        billingView.registerationForm.state.text = credit.state
        billingView.registerationForm.zipcode.text = credit.zipcode
        
    }
    
    private func checkUserPass()->Bool{
        guard let password = password.text, let pass = UserDefaults.standard.value(forKey: "password") as? String else {return false}
        return pass == password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc func updateInformation(){
        
        guard ValidateTextField.isTextEmpty(billingView.nameOnCard), ValidateTextField.isTextEmpty(billingView.cardNumber), ValidateTextField.isTextEmpty(billingView.expirationDate), ValidateTextField.isTextEmpty(billingView.ccv),
              ValidateTextField.isValidInput(billingView.cardNumber, 12, "Card number is too short!"),
              ValidateTextField.isValidInput(billingView.ccv, 3, "CCV is too short!")
              else{
                return
              }
        
        guard
            ValidateTextField.isTextEmpty(billingView.registerationForm.fullname),
            ValidateTextField.isTextEmpty(billingView.registerationForm.phoneNumber),
            ValidateTextField.isTextEmpty(billingView.registerationForm.addresslineone),
            ValidateTextField.isTextEmpty(billingView.registerationForm.city),
            ValidateTextField.isTextEmpty(billingView.registerationForm.state),
            ValidateTextField.isTextEmpty(billingView.registerationForm.zipcode),

            ValidateTextField.isValidInput(billingView.registerationForm.fullname, 2, "Name is too short!"),
            ValidateTextField.isValidInput(billingView.registerationForm.phoneNumber, 10, "Phone number is too short!"),
            ValidateTextField.isValidInput(billingView.registerationForm.addresslineone, 5, "Address is too short!"),
            ValidateTextField.isValidInput(billingView.registerationForm.city, 2, "City is too short!"),
            ValidateTextField.isValidInput(billingView.registerationForm.zipcode, 5, "Zipcode is too short!")
        else{return}
        
        guard let fullname = billingView.registerationForm.fullname.text,
              let phonenumber = billingView.registerationForm.phoneNumber.text,
              let addressline1 = billingView.registerationForm.addresslineone.text,
              let addressline2 = billingView.registerationForm.addresslinetwo.text,
              let city = billingView.registerationForm.city.text,
              let state = billingView.registerationForm.state.text,
              let zipcode = billingView.registerationForm.zipcode.text
        else{
            print("One of the textfield has not been init")
            return}
        
        credit = CreditCard()
        credit.useruuid = DatabaseStack.shared.client.uuid
        credit.nameOnCard = billingView.nameOnCard.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.cardNumber = billingView.cardNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.expirationDate = billingView.expirationDate.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.ccv = billingView.ccv.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        credit.fullname = fullname.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.phoneNumber = phonenumber.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.addressLineOne = addressline1.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.addressLineTwo = addressline2.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.state = state.trimmingCharacters(in: .whitespacesAndNewlines)
        credit.zipcode = zipcode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        UserDefaults.standard.setValue(true, forKey: "creditcard")
        
        let modify = Modification()
        modify.delegate = self
        modify.updateBilling(credit: self.credit)
    }
}
