
import UIKit

class DinerReviewView: UIView {
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 18, font: .AppleSDGothicNeo_Light)
        label.text = "Review:"
        return label
    }()
    
    var descriptions:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .left, fontSize: 18, font: .AppleSDGothicNeo_Light)
        return label
    }()
    
    var hstack:UIStackView={
        let hstack = UIStackView()
        hstack.alignment = .center
        hstack.distribution = .fillEqually
        hstack.axis = .horizontal
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
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
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant*2),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            label.widthAnchor.constraint(equalToConstant: 140),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.addSubview(hstack)
        NSLayoutConstraint.activate([
            hstack.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant*2),
            hstack.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: .leftConstant),
            hstack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant),
            hstack.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            hstack.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        for _ in 0..<([3,4,5].randomElement() ?? 5){
            let img = UIImageView()
            img.translatesAutoresizingMaskIntoConstraints = false
            img.backgroundColor = .clear
            img.contentMode = .center
            img.image = UIImage(systemName: "star.fill")?.applyingSymbolConfiguration(.init(pointSize: 20, weight: .medium))
            img.tintColor = .systemOrange
            hstack.addArrangedSubview(img)
            NSLayoutConstraint.activate([
                img.widthAnchor.constraint(equalToConstant: 20),
                img.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        self.addSubview(descriptions)
        NSLayoutConstraint.activate([
            descriptions.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            descriptions.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant*2),
            descriptions.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant + .rightConstant),
            descriptions.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: .bottomConstant + .bottomConstant)
        ])
        
    }
}
