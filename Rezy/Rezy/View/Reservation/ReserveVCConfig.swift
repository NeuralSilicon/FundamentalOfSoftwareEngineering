
import UIKit
import os

extension ReserveVC{
    
    func addSubviews(){
                
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        scrollView.contentSize.width = self.view.frame.width
        
        scrollView.addSubview(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .topConstant),
            back.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            back.widthAnchor.constraint(equalToConstant: 35),
            back.heightAnchor.constraint(equalToConstant: 35)
        ])
        back.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        
        scrollView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .topConstant),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        scrollView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .topStandAloneConstant),
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant),
            dateLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promptDateView)))
        
        dateView.parentPage = self
        scrollView.addSubview(dateView)
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: .topConstant),
            dateView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant),
            dateView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant),
            dateView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dateView.heightAnchor.constraint(equalToConstant: 0)
        ])
        dateView.datePickerChanged()
        
        scrollView.addSubview(underNameLabel)
        NSLayoutConstraint.activate([
            underNameLabel.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: .topConstant),
            underNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant),
            underNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant),
            underNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            underNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        underNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promptReservationForm)))
        
        
        scrollView.addSubview(payment)
        NSLayoutConstraint.activate([
            payment.topAnchor.constraint(equalTo: underNameLabel.bottomAnchor, constant: .topConstant*2),
            payment.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant),
            payment.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant),
            payment.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            payment.heightAnchor.constraint(equalToConstant: 0)
        ])
        payment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promptPayment)))
                
        scrollView.addSubview(reserveIt)
        NSLayoutConstraint.activate([
            reserveIt.topAnchor.constraint(equalTo: payment.bottomAnchor, constant: .topConstant*2),
            reserveIt.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant),
            reserveIt.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant),
            reserveIt.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            reserveIt.heightAnchor.constraint(equalToConstant: 45)
        ])
        reserveIt.addTarget(self, action: #selector(checkCredential), for: .touchUpInside)
        
        
        reservationForm.parentPage = self
        view.insertSubview(reservationForm, belowSubview: scrollView)
        NSLayoutConstraint.activate([
            reservationForm.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant),
            reservationForm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            reservationForm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            reservationForm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant)
        ])
        reservationForm.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        
        billingView.parentPage = self
        view.insertSubview(billingView, belowSubview: reservationForm)
        NSLayoutConstraint.activate([
            billingView.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant),
            billingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            billingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            billingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant),
        ])
        billingView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        
        wrapUp.parentPage = self
        view.insertSubview(wrapUp, belowSubview: billingView)
        NSLayoutConstraint.activate([
            wrapUp.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant),
            wrapUp.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapUp.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapUp.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        wrapUp.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        
        scrollView.layoutIfNeeded()
    }
    
    //titleLabel, back, datelabel, dateview, undernameLabel, reservationForm, payment, billingView, reserveIt
    
    @objc private func dismissPage(){
        self.dismiss(animated: true, completion: nil)
    }
    
        
}
