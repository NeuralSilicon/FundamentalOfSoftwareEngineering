
import  UIKit

class UpdateCreditCardVC: UIViewController, ModificationDelegate, StateDelegate {
    
    func succeeded(value: Bool) {
        guard value else{
            let activity = UIAlertController(title: nil, message: "Failed to update your information, try again later!", preferredStyle: .alert)
            activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(activity, animated: true, completion: nil)
            return
        }
        let activity = UIAlertController(title: nil, message: "Updated", preferredStyle: .alert)
        activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(activity, animated: true, completion: nil)
    }

    func selectedStated(with abbreviation: String) {
        DispatchQueue.main.async{
            self.billingView.registerationForm.state.text = "  " + abbreviation
        }
    }
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .center, fontSize: 30, font: .AppleSDGothicNeo_Medium)
        label.text = "Billing Information"
        return label
    }()
    
    var password:TextField={
        let text = TextField()
        text.placeholder = "Password"
        text.textAlignment = .left
        text.textColor = .Dark
        text.tag = 1
        text.returnKeyType = .next
        text.isSecureTextEntry = true
        return text
    }()
    
    var passwordRequirement:UILabel={
        let label = UILabel()
        label.Label(textColor: .Light, textAlignment: .center, fontSize: 15, font: .AppleSDGothicNeo_Regular)
        label.text = "Password is required to update/add the information"
        return label
    }()
    
    var loadmore:UIButton={
        let button = UIButton()
        button.Button(text: "Check Password")
        return button
    }()
 
    var update:UIButton={
        let button = UIButton()
        button.Button(text: "Update")
        return button
    }()
    
    var billingView:BillingView={
        let billing = BillingView()
        return billing
    }()
    var credit:CreditCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addsubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard credit == nil else {
            return
        }
        DatabaseStack.shared.DownloadUserInfo()
        DatabaseStack.shared.group.notify(queue: .main) {
            self.credit = DatabaseStack.shared.creditcard
        }
    }
}

extension UpdateCreditCardVC:UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addRightView(rightView: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            password.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}

