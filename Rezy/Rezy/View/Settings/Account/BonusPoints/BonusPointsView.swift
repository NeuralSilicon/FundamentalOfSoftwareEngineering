

import UIKit

class BonusPointsView: UIView {
    
    var progressView: ProgressView!
    var bonus:Int = 10{
        willSet{
            self.bonusLabel.text = "Points: " + String(self.bonus)
        }
    }
    
    var fullname:UILabel={
       let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 20, font: .AppleSDGothicNeo_Medium)
        return label
    }()
    
    var bonusLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 20, font: .AppleSDGothicNeo_Medium)
        return label
    }()
    
    var subLabel:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .left, fontSize: 15, font: .AppleSDGothicNeo_Light)
        label.text = "You may redeem your points at any of our restaurants."
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewAppeared(){
        self.addSubviews()
    }
}

extension BonusPointsView{
    
    fileprivate func addSubviews(){
        self.backgroundColor = .systemGray6
        
        self.addSubview(fullname)
        NSLayoutConstraint.activate([
            fullname.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            fullname.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            fullname.heightAnchor.constraint(equalToConstant: 45),
            fullname.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        self.addSubview(bonusLabel)
        NSLayoutConstraint.activate([
            bonusLabel.topAnchor.constraint(equalTo: fullname.bottomAnchor, constant: .topConstant),
            bonusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            bonusLabel.heightAnchor.constraint(equalToConstant: 45),
            bonusLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        self.addSubview(subLabel)
        NSLayoutConstraint.activate([
            subLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .bottomConstant),
            subLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            subLabel.heightAnchor.constraint(equalToConstant: 40),
            subLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        progressView = ProgressView(frame: self.frame)
        progressView.center = self.center
        progressView.center.y = progressView.center.y/2
        progressView.center.x *= 1.5
        self.addSubview(progressView)
        progressView.createCircularPath()
        progressView.progressAnimation(value: bonus)
    }
}
