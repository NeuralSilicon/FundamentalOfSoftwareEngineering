
//sayra (:
import UIKit

class WrapUp: UIView {

    //displays text 
    var label:UILabel={
        let text = UILabel()
        text.Label(textColor: .Dark, textAlignment: .left, fontSize: 25, font: .AppleSDGothicNeo_SemiBold)
        text.text = "Finishing up the Reservation..."
        return text
    }()
    
    //shows the progress of the task
    var progressBar: ProgressBarView={
        let bar = ProgressBarView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    weak var parentPage:UIViewController!
    
    override init(frame: CGRect) { //CGRECT contains locatio and demesion of rect
        super.init(frame: frame)
        self.addSubivews()
    }
    
    //unconditionally prints a message and stops the execution
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //formating subviews on screen
    private func addSubivews(){
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: .topConstant),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(equalToConstant: 200)
        ])
        self.layoutIfNeeded()
        
        progressBar.center = self.center
        self.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 100),
            progressBar.widthAnchor.constraint(equalToConstant: 100)
        ])
        self.layoutIfNeeded()
        progressBar.simpleShape()
    }

}
