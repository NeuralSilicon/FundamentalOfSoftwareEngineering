
import UIKit

class LoginVC: UIViewController, RegisterationDelegate {
    func savedClient(value: Bool) {}
    func createdUser(value: Bool) {
        if value{
            let vc = Tabbar()
            let navig = UINavigationController(rootViewController: vc)
            navig.modalPresentationStyle = .fullScreen
            navig.modalTransitionStyle = .flipHorizontal
            navig.navigationBar.isHidden = true
            self.present(navig, animated: true, completion: nil)
        }else{
            let activity = UIAlertController(title: nil, message: "Failed to Login as Guest, try again later!", preferredStyle: .alert)
            activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        self.present(activity, animated: true, completion: nil)
        }
    }
     
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .white, textAlignment: .center, fontSize: 40, font: .AppleSDGothicNeo_Regular)
        label.text = "Rezy"
        return label
    }()

    var image:UIImageView={
        let img = UIImageView()
        let image = UIImage(named: "Burger")
        img.image = image?.Resize(targetSize: CGSize(width: image!.size.width * 0.5, height: image!.size.height * 0.5))
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var blur:UIVisualEffectView={
        let blur = UIVisualEffectView(frame: UIScreen.main.bounds)
        blur.effect = UIBlurEffect(style: .dark)
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }()
    
    var username:TextField={
        let text = TextField()
        text.placeholder = "Email Address"
        text.textColor = .white
        text.keyboardType = .emailAddress
        text.returnKeyType = .next
        text.tag = 0
        text.autocorrectionType = .no
        return text
    }()
    
    var password:TextField={
        let text = TextField()
        text.placeholder = "Password"
        text.textColor = .white
        text.isSecureTextEntry = true
        text.returnKeyType = .done
        text.tag = 1
        return text
    }()
    
    var login:UIButton={
        let button = UIButton()
        button.Button(text: "Login",UIColor.white)
        button.backgroundColor = .black
        return button
    }()
    
    var register:UIButton={
        let button = UIButton()
        button.Button(text: "Register", UIColor.white)
        button.backgroundColor = .black
        return button
    }()
        
    var passwordRecovery:UIButton={
        let button = UIButton()
        button.Button(text: "")
        button.backgroundColor = .clear
        button.setAttributedTitle(attribute(for: "Password Recovery", size: 18, font: .AppleSDGothicNeo_Regular, color: .Light), for: .normal)
        return button
    }()
    
    var privacy:UIButton={
        let button = UIButton()
        button.Button(text: "")
        button.backgroundColor = .clear
        button.setAttributedTitle(attribute(for: "Privacy and Agreement", size: 18, font: .AppleSDGothicNeo_Regular, color: .Light), for: .normal)
        return button
    }()
    
    var loginAsGuest:UIButton={
        let button = UIButton()
        button.Button(text: "Guest", UIColor.white)
        button.backgroundColor = .black
        return button
    }()
    
    var delegate:LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.alpha = 0
        addsubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1.0
        }
    }

}
