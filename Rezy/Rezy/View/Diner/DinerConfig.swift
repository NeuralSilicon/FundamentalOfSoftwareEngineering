
import UIKit

extension DinerVC{
    
    func addsubviews(){
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        scrollView.delegate = self
        scrollView.layer.cornerRadius = .cornerRadius
        
        
        scrollView.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: scrollView.topAnchor),
            image.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            image.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: view.frame.height * 0.3)
        ])
        image.image = img
        
        view.addSubview(back)
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant*2),
            back.widthAnchor.constraint(equalToConstant: 35),
            back.heightAnchor.constraint(equalToConstant: 35)
        ])
        back.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        
        scrollView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: view.frame.height * 0.25),
            infoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            infoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            infoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            infoView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.13)
        ])
        
        infoView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: infoView.topAnchor, constant: .topConstant),
            label.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        label.text = "Location:"
        
        infoView.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            addressLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: .leftConstant),
            addressLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: .rightConstant),
            addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        addressLabel.text = model.diner.address

        infoView.addSubview(makeReservation)
        NSLayoutConstraint.activate([
            makeReservation.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: .bottomConstant),
            makeReservation.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: .rightConstant),
            makeReservation.widthAnchor.constraint(equalToConstant: 140),
            makeReservation.heightAnchor.constraint(equalToConstant: 40)
        ])
        makeReservation.addTarget(self, action: #selector(openReserveVC), for: .touchUpInside)
        
        scrollView.addSubview(foodsView)
        NSLayoutConstraint.activate([
            foodsView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: .topConstant),
            foodsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            foodsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            foodsView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            foodsView.heightAnchor.constraint(equalToConstant: 100)
        ])
        foodsView.addsubviews()
        foodsView.parentPage = self
        
        scrollView.addSubview(foodInfoView)
        NSLayoutConstraint.activate([
            foodInfoView.topAnchor.constraint(equalTo: foodsView.bottomAnchor, constant: .topConstant),
            foodInfoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            foodInfoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            foodInfoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            foodInfoView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
        ])
        foodInfoView.addsubviews()
        
        scrollView.addSubview(dinerReviewView)
        NSLayoutConstraint.activate([
            dinerReviewView.topAnchor.constraint(equalTo: foodInfoView.bottomAnchor, constant: .topConstant),
            dinerReviewView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .leftConstant*2),
            dinerReviewView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: .rightConstant + .rightConstant),
            dinerReviewView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dinerReviewView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        dinerReviewView.descriptions.text = model.diner.reviews
        dinerReviewView.addsubviews()
    }
    

    @objc private func dismissPage(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func openReserveVC(){
        let vc = ReserveVC()
        vc.model = self.model
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
