
import UIKit

class AccountManagment: UIViewController {
    
    let cellid = "SettingCell"
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
        label.text = "Account Management"
        return label
    }()
    
    var option:ShowOption!
    
    var bonusView:BonusPointsView={
        let view = BonusPointsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = .cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addsubviews()
    }
    
    func addsubviews(){
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant + .topConstant),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        view.addSubview(bonusView)
        NSLayoutConstraint.activate([
            bonusView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            bonusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            bonusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            bonusView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
        ])
        
        tableView.delegate = self; tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: cellid)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bonusView.bottomAnchor, constant: .topConstant),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant*2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant*2),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant)
        ])
        
        
        DatabaseStack.shared.group.notify(queue: .main) {
            let client = DatabaseStack.shared.client
            self.bonusView.fullname.text = client?.fullname ?? ""
            self.bonusView.bonus = Int(client?.points ?? "10") ?? 10
            self.bonusView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                self.bonusView.viewAppeared()
            }
        }
    }

}

extension AccountManagment:OptionDelegate{
    func index(for index: Int) {
        let options = ["Cash","Credit Card","Check"]
        
        UserDefaults.standard.setValue(options[index], forKey: "paymentmethod")
        DatabaseStack.shared.client.preferredPayment = options[index]
        Modification.init(client: DatabaseStack.shared.client).updatePaymentMethod()
    }
}


extension AccountManagment:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as? SettingCell{
            cell.label.text = ["Update information","Update/Add Credit Card","Payment method","Reset password","Delete account","Sign out"][indexPath.section]
            cell.image.image = UIImage(systemName:
                                        ["person.fill","creditcard","creditcard.fill","key.fill","person.fill.xmark", "xmark.circle.fill"][indexPath.section])?.applyingSymbolConfiguration(.init(pointSize: 15, weight: .regular))
            if indexPath.section == 4{
                cell.label.textColor = .systemRed
                cell.image.tintColor = .systemRed
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            tableView.deselectRow(at: indexPath, animated: true)
        } completion: { _ in
            switch indexPath.section{
            case 0:
                let vc = UpdateInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
//                guard UserDefaults.standard.value(forKey: "creditcard") != nil else {
//                    
//                    return}
                let vc = UpdateCreditCardVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                self.showOption()
            case 3:
                let vc = ResetPassword()
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                self.deleteAccount()
            case 5:
                self.signingOut()
            default:
                break
            }
        }

    }
    
    func showOption(){
        option = ShowOption(frame: UIScreen.main.bounds)
        option.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(option)
        NSLayoutConstraint.activate([
            option.topAnchor.constraint(equalTo: view.topAnchor),
            option.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            option.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            option.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        option.options = ["Cash","Credit Card", "Check"]
        option.sublabel.text = "Restaurant will be informed of your payment method."
        if let payment = UserDefaults.standard.value(forKey: "paymentmethod") as? String{
            option.selectedIndex = ["Cash","Credit Card", "Check"].firstIndex(where: {$0==payment})!
        }
        option.showSelection = true
        option.delegate = self
        option.configOption()
        option.viewAppeared()
    }
    
    func signingOut(){
        let activity = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.signOut()
        }
        let no = UIAlertAction(title:"No", style: .cancel)
        activity.addAction(yes) ; activity.addAction(no)
        self.present(activity, animated: true, completion: nil)
    }
}
