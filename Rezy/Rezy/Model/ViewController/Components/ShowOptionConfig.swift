
import UIKit

extension ShowOption{
    
    //MARK: -Config Option
    func configOption(){
        guard options.count > 0 else {
            return
        }
    
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .topConstant),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: CGFloat(options.count * 52) + 150) //50 for each option and 75/2  for top space and for bottom space
        ])
        containerView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        
        self.layoutIfNeeded()
        
        //add pan gesture to containerview
        self.gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(_:)))
        self.gesture.cancelsTouchesInView = false
        self.containerView.addGestureRecognizer(gesture)
        gesture.delegate = self as? UIGestureRecognizerDelegate
        
    
        //create our stack to hold our texts or options
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.layer.cornerRadius = .cornerRadius
        vStack.layer.masksToBounds = false
        vStack.backgroundColor = UIColor.clear
        vStack.spacing = 5
        vStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .topConstant*2),
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .leftConstant),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: .rightConstant)
        ])
        
        containerView.layoutIfNeeded()
        
        //create a label for each txt
        var i = 0
        options.forEach { (txt) in
            
            //create our Hstack to hold our texts or options
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.backgroundColor = .clear
            hStack.layer.cornerRadius = .cornerRadius
            hStack.layer.masksToBounds = true
            hStack.layer.borderColor = UIColor.clear.cgColor
            hStack.layer.borderWidth = 1
            hStack.spacing = 8
            hStack.distribution = .fillProportionally
            hStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview(hStack)
            
            NSLayoutConstraint.activate([
                hStack.widthAnchor.constraint(equalToConstant: vStack.frame.width),
                hStack.heightAnchor.constraint(equalToConstant: 52)
            ])
            
            vStack.layoutIfNeeded()
            
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            hStack.addArrangedSubview(view)
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 8),
            ])
            
            
            let label = UILabel()
            label.text = " " + txt
            label.textColor = .Dark
            label.font = UIFont.custom(type: .AppleSDGothicNeo_Light, size: 20)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textAlignment = .left
            label.backgroundColor = .clear
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5
            label.isUserInteractionEnabled = true
            hStack.addArrangedSubview(label)
            let tap = MyTapGesture(target: self, action: #selector(self.options(sender:)))
            tap.tagNumber = i
            label.tag = i
            label.addGestureRecognizer(tap)
            labels.append(label)
            
            let img = UIImageView()
            img.translatesAutoresizingMaskIntoConstraints = false
            img.image = UIImage(systemName: "circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 16, weight: .medium))
            img.tintColor = .systemBlue
            img.contentMode = .scaleAspectFit
            hStack.addArrangedSubview(img)
            NSLayoutConstraint.activate([
                img.widthAnchor.constraint(equalToConstant: 20),
                img.heightAnchor.constraint(equalToConstant: 20)
            ])
            img.isHidden = true
            
            if self.showSelection{
                self.imgs.append(img)
                self.hstack.append(hStack)
                
                if i == self.selectedIndex{
                    img.isHidden = false
                    hStack.backgroundColor = showSelection ? .systemBlue.withAlphaComponent(0.1) : .clear
                    hStack.layer.borderColor = showSelection ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
                }else{
                    hStack.backgroundColor = .clear
                    hStack.layer.borderColor = UIColor.clear.cgColor
                }
                }
            
            i+=1
            
            let trailingview = UIView()
            trailingview.backgroundColor = .clear
            trailingview.translatesAutoresizingMaskIntoConstraints = false
            hStack.addArrangedSubview(trailingview)
            NSLayoutConstraint.activate([
                trailingview.widthAnchor.constraint(equalToConstant: 8)
            ])
        }
        
        containerView.addSubview(sublabel)
        NSLayoutConstraint.activate([
            sublabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: .rightConstant),
            sublabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .leftConstant),
            sublabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .bottomConstant),
            sublabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            vStack.bottomAnchor.constraint(equalTo: sublabel.topAnchor, constant: .bottomConstant)
        ])
            
        containerView.layoutIfNeeded()
        
        viewAppeared()
    }
    
    //MARK: -dimiss page
    @objc func dimissPage(){
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = .clear
        } completion: { (_) in
           //dismiss page
            self.deinitPage()
        }
    }
    
    
    //MARK: -Options
    @objc private func options(sender:MyTapGesture){
        DispatchQueue.main.async {
            for i in 0..<self.imgs.count{
                if i != sender.tagNumber{
                    self.imgs[i].isHidden = true
                    self.hstack[i].backgroundColor = .clear
                    self.hstack[i].layer.borderColor = UIColor.clear.cgColor
                }else{
                    self.imgs[i].isHidden = false
                    self.hstack[i].backgroundColor = self.showSelection ? .systemBlue.withAlphaComponent(0.1) : .clear
                    self.hstack[i].layer.borderColor = self.showSelection ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
                }
            }
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut) {
            self.backgroundColor = .clear
        } completion: { (_) in
            self.delegate?.index(for: sender.tagNumber)
            self.deinitPage()
        }
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var tagNumber = Int()
    var position = CGRect()
}
