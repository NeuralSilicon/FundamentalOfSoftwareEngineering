
import UIKit

class LabelView: UIView {
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .systemOrange, textAlignment: .left, fontSize: 22, font: .AppleSDGothicNeo_Regular)
        return label
    }()
    
    var label2:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .right, fontSize: 20, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    var image:UIImageView={
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.forward")?.applyingSymbolConfiguration(.init(pointSize: 15, weight: .light))
        image.tintColor = .Light
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var value:String=""{
        willSet{
            DispatchQueue.main.async {
                self.label2.text = self.value
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews(){
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.backgroundColor = .systemGray6
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .bottomConstant),
            label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        self.addSubview(label2)
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            label2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .bottomConstant),
            label2.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: .leftConstant),
            label2.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        self.addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: .leftConstant),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant),
            image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 25),
            image.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
