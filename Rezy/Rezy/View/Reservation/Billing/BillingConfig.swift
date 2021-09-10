

import UIKit

extension BillingView{
    
    func addsubviews(){
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .systemBackground
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false

        let view = self
        //nameOnCard, cardNumber, expirationDate, ccv, isAddresstheSame, isAddressSwitch, registerationForm, saveCard
        
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
        
        view.addSubview(nameOnCard)
        NSLayoutConstraint.activate([
            nameOnCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .topConstant),
            nameOnCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            nameOnCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            nameOnCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            nameOnCard.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.insertSubview(cardNumber, belowSubview: nameOnCard)
        NSLayoutConstraint.activate([
            cardNumber.topAnchor.constraint(equalTo: nameOnCard.bottomAnchor, constant: .topConstant),
            cardNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            cardNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            cardNumber.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            cardNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        
        view.insertSubview(expirationDate, belowSubview: cardNumber)
        NSLayoutConstraint.activate([
            expirationDate.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: .topConstant),
            expirationDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            expirationDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            expirationDate.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            expirationDate.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        
        view.insertSubview(ccv, belowSubview: expirationDate)
        NSLayoutConstraint.activate([
            ccv.topAnchor.constraint(equalTo: expirationDate.bottomAnchor, constant: .topConstant),
            ccv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            ccv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            ccv.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            ccv.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        view.insertSubview(isAddresstheSame, belowSubview: ccv)
        NSLayoutConstraint.activate([
            isAddresstheSame.topAnchor.constraint(equalTo: ccv.bottomAnchor, constant: .topConstant),
            isAddresstheSame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            isAddresstheSame.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        view.insertSubview(isAddressSwitch, belowSubview: ccv)
        NSLayoutConstraint.activate([
            isAddressSwitch.topAnchor.constraint(equalTo: ccv.bottomAnchor, constant: .topConstant),
            isAddressSwitch.leadingAnchor.constraint(equalTo: isAddresstheSame.trailingAnchor, constant: .leftConstant),
            isAddressSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            isAddressSwitch.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            isAddressSwitch.widthAnchor.constraint(equalToConstant: 50)
        ])
        isAddressSwitch.addTarget(self, action: #selector(addressSwitch), for: .valueChanged)
        isAddressSwitch.isOn = true
        
        view.addSubview(registerationForm)
        NSLayoutConstraint.activate([
            registerationForm.topAnchor.constraint(equalTo: isAddresstheSame.bottomAnchor, constant: .topConstant),
            registerationForm.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerationForm.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerationForm.heightAnchor.constraint(equalToConstant:0),
            registerationForm.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
                
        view.insertSubview(saveCard, belowSubview: registerationForm)
        NSLayoutConstraint.activate([
            saveCard.topAnchor.constraint(equalTo: registerationForm.bottomAnchor),
            saveCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveCard.widthAnchor.constraint(equalToConstant: 140),
            saveCard.heightAnchor.constraint(equalToConstant: 40)
        ])
        saveCard.addTarget(self, action: #selector(saveBilling), for: .touchUpInside)
        
        self.layoutIfNeeded()
        
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.delegate = self
                textfield.returnKeyType = .next
            }
        }
        
    }
    
    @objc func addressSwitch(){
        registerationForm.updateConstraint(attribute: .height, constant: isAddressSwitch.isOn ? 0 : 380)
        self.setScrollViewHeight()
        registerationForm.parentPage = self.parentPage
        self.contentSize.height += 200
    }
    
    @objc func dismissPage(){
        for views in self.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.resignFirstResponder()
            }
        }
        for views in self.registerationForm.subviews{
            if views.isKind(of: TextField.self), let textfield = views as? TextField{
                textfield.resignFirstResponder()
            }
        }
        
        if let parent = self.parentPage as? ReserveVC{
            parent.removeBilling()
        }
    }
}

