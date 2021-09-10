
import UIKit

class Setting: UIViewController {
    
    let cellid:String = "SettingCell"
    
    var tableView:UITableView={
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .clear
        table.layer.cornerRadius = .cornerRadius
        table.layer.masksToBounds = true
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .center, fontSize: 30, font: .AppleSDGothicNeo_Medium)
        label.text = "Setting"
        return label
    }()
    
    var button:UIButton={
        let button = UIButton()
        button.isHidden = true
        button.Button(text: "Register")
        return button
    }()
    
    var signOut:UIButton={
        let button = UIButton()
        button.isHidden = true
        button.Button(text: "Sign out")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addsubviews()
        
        DispatchQueue.global(qos: .background).async {
            DatabaseStack.shared.RetrieveClient()
        }
    }
}
