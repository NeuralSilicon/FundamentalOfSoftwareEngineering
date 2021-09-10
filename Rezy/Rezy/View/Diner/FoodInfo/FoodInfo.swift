
import UIKit

class FoodInfoView: UIView {
    
    var foodInfo:Food?{
        willSet{
            DispatchQueue.main.async {
                self.img.image = UIImage(named: self.foodInfo?.img ?? "")
                self.name.text = self.foodInfo?.name
                self.price.text = self.foodInfo?.price
                self.descriptions.text = self.foodInfo?.descriptions
            }
        }
    }
    
    var img:UIImageView={
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.layer.cornerRadius = .cornerRadius
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        return img
    }()

    var name:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 20, font: .AppleSDGothicNeo_SemiBold)
        return label
    }()
    
    var price:UILabel={
        let label = UILabel()
        label.Label(textColor: .systemOrange, textAlignment: .left, fontSize: 25, font: .AppleSDGothicNeo_Bold)
        return label
    }()
    
    var descriptions:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .center, fontSize: 15, font: .AppleSDGothicNeo_Light)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addsubviews(){
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = .systemGray6

        self.addSubview(img)
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            img.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant),
            img.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        self.addSubview(name)
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: img.bottomAnchor, constant: .topConstant),
            name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant),
            name.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(price)
        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: name.bottomAnchor, constant: .topConstant),
            price.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            price.widthAnchor.constraint(equalToConstant: 100),
            price.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(descriptions)
        NSLayoutConstraint.activate([
            descriptions.topAnchor.constraint(equalTo: name.bottomAnchor, constant: .topConstant),
            descriptions.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: .leftConstant),
            descriptions.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant),
            descriptions.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .bottomConstant),
        ])
        
    }
}
