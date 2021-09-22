

import UIKit
import Firebase
import SkeletonView
import os

extension ReservedVC{
    
    func addsubviews(){
        
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant + .topConstant),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant*2),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant*2),
            searchField.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        searchField.delegate = self
        
        tableView.delegate = self; tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellid)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: .topConstant*2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant*2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant*2),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant)
        ])
        
        fetchDiners()
    }
    

    func fetchDiners(){
        
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton()
        view.showSkeleton()
        
        ReservationHandler.shared.retrieveReservations()
   
        ReservationHandler.shared.group.notify(queue: .global(qos: .background)) {
        
            DinerStack.shared.Fetch(entity: .diner) { diner in
                self.diners = []
                for reservation in ReservationHandler.shared.reservations{
                    if let item = diner.first(where: {$0.dinerUUID == UUID.init(uuidString: reservation.dinerUUID)}){
                        self.diners.append(Reserved(diner: item, reservation: reservation))
                    }
                }
                self.tableView.reloadData()
      
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.showSkeleton = false
                    self.tableView.stopSkeletonAnimation()
                    self.view.hideSkeleton()
                    self.tableView.reloadData()
                }
            }
        }
        

    }
    
}

extension ReservedVC:UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (searchisActive ? filter.count : diners.count)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchisActive ? (filter.count > 0 ? 1 : 0) : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as? SearchCell{
            let data = !searchisActive ? diners[indexPath.section].diner : filter[indexPath.section].diner
            let reservation = !searchisActive ? diners[indexPath.section].reservation : filter[indexPath.section].reservation

            
            let attrs = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Bold, size: 18)]
            let attributedString = NSMutableAttributedString(string:"Date: ", attributes:attrs)

            let attr = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Light, size: 18)]
            let normalString = NSMutableAttributedString(string:reservation.date, attributes:attr)
            attributedString.append(normalString)
            
            let attr2 = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Bold, size: 18)]
            let normalString2 = NSMutableAttributedString(string:" - Time: ", attributes:attr2)
            attributedString.append(normalString2)
            
            let attr3 = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Light, size: 18)]
            let normalString3 = NSMutableAttributedString(string:reservation.time, attributes:attr3)
            attributedString.append(normalString3)
            
            let attr4 = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Bold, size: 18)]
            let normalString4 = NSMutableAttributedString(string:"\nAddress: ", attributes:attr4)
            attributedString.append(normalString4)
            
            let attr5 = [NSAttributedString.Key.font : UIFont.custom(type: .AppleSDGothicNeo_Light, size: 18)]
            let normalString5 = NSMutableAttributedString(string:data.address ?? "", attributes:attr5)
            attributedString.append(normalString5)
            
            cell.address.attributedText = attributedString
            
            
            if data.url != "", let url = URL(string: data.url ?? ""), !showSkeleton{
                cell.hideAnimation()
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
                    cell.image.image = cachedImage
                } else {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            let imageToCache = UIImage(data: data)
                            self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                            cell.image.image = imageToCache
                        }
                    }.resume()
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = !searchisActive ? diners[indexPath.section].diner : filter[indexPath.section].diner
        
        var img = UIImage()
    
        if data.url != "", let url = URL(string: data.url ?? "") {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
                img = cachedImage
            } else {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data)
                        self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                        img = imageToCache!
                    }
                }.resume()
            }
        }
        
        UIView.animate(withDuration: 0.4) {
            tableView.deselectRow(at: indexPath, animated: true)
        } completion: { _ in
            let vc = ReservationInfo()
            vc.reservation = self.diners[indexPath.section].reservation
            vc.img = img
            vc.address = self.diners[indexPath.section].diner.address
            vc.parentPage = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }

    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchisActive{
            return
        }
        cell.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .beginFromCurrentState, animations: {
            cell.alpha = 1.0
        }, completion: nil)
    }
    
}


