

import UIKit
import Firebase
import SkeletonView
import os

extension SearchDiners{
    
    
    func addsubviews(){
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant + .topConstant),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: .rightConstant*2),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30)
        ])
        button.addTarget(self, action: #selector(dismissPage), for: .touchUpInside)
        
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant + .topConstant),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant*2),
            searchField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: .rightConstant*2),
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
    
    @objc private func dismissPage(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func fetchDiners(){
        
        tableView.isSkeletonable = true
        tableView.showAnimatedSkeleton()
        view.showSkeleton()
        

        DispatchQueue.global(qos: .background).async{

            DinerStack.shared.Fetch(entity: .diner) { diner in
                self.diners = diner
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

extension SearchDiners:UITableViewDelegate, UITableViewDataSource{
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
            let data = !searchisActive ? diners[indexPath.section] : filter[indexPath.section]
            
            cell.address.text = data.address
           
            if data.url != "", let url = URL(string: data.url ?? ""), !self.showSkeleton {
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
        
        let data = !searchisActive ? diners[indexPath.section] : filter[indexPath.section]
        
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
            let vc = DinerVC()
            vc.model.diner = data
            vc.img = img
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchisActive{
            return
        }
        cell.transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
}


class SearchCell: UITableViewCell {
        
    var image:UIImageView={
       let img = UIImageView()
        img.isSkeletonable = true
        img.backgroundColor = .clear
        img.tintColor = .Dark
        img.contentMode = .scaleToFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = .cornerRadius
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 0.5
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var view:UIView={
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = .cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var address:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 18, font: .AppleSDGothicNeo_Medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addsubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        address.text = nil
    }
    
    private func addsubviews(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = .cornerRadius
        
        
        contentView.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .bottomConstant + .bottomConstant),
            image.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        contentView.layoutIfNeeded()
        
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .leftConstant*2),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .rightConstant + .rightConstant),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 250 * 0.2)
        ])

        view.addSubview(address)
        NSLayoutConstraint.activate([
            address.topAnchor.constraint(equalTo: view.topAnchor, constant: .topConstant),
            address.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            address.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant),
            address.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            address.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        self.isSkeletonable = true
        image.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: .systemGray6, secondaryColor: .black), animation:  SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight), transition: .crossDissolve(0.5))
        view.isHidden = true
    }
    
    func hideAnimation(){
        image.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        view.isHidden = false
    }
}
