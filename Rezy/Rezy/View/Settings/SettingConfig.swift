

import UIKit
import MessageUI
import Firebase
import os

extension Setting:ReserveVCDelegate{
    func finishedRegisteration() {
        self.alert("Please Sign out and sign back in.", "You can't make reservation unless you do this!")
        DispatchQueue.main.async {
            self.button.isHidden = true
            self.signOut.isHidden = true
            self.label.text = "Settings"
            self.tableView.isHidden = false
        }
    }
    
    func addsubviews(){
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant + .topConstant),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 140),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        button.addTarget(self, action: #selector(openRegisteration), for: .touchUpInside)
        
        view.addSubview(signOut)
        NSLayoutConstraint.activate([
            signOut.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOut.topAnchor.constraint(equalTo: button.bottomAnchor, constant: .topConstant),
            signOut.widthAnchor.constraint(equalToConstant: 140),
            signOut.heightAnchor.constraint(equalToConstant: 40)
        ])
        signOut.addTarget(self, action: #selector(SignOut), for: .touchUpInside)
        
        tableView.delegate = self; tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: cellid)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topConstant),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant*2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant*2),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .bottomConstant)
        ])
        
        guard UserDefaults.standard.value(forKey: "guestid") != nil else{
            return
        }
        button.isHidden = false
        signOut.isHidden = false
        label.text = ""
        tableView.isHidden = true
    }
    
    @objc func openRegisteration(){
        let vc = RVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func SignOut(){
        UserDefaults.standard.setValue(nil, forKey: "uuid")
        UserDefaults.standard.setValue(nil, forKey: "password")
        UserDefaults.standard.setValue(nil, forKey: "loggedin")
        UserDefaults.standard.setValue(nil, forKey: "guestid")
        UserDefaults.standard.setValue(nil, forKey: "creditcard")
        
        Auth.auth().currentUser?.delete { error in
          if let error = error {
                print(error.localizedDescription)
          } else {
                print("user was deleted from cloud")
                NotificationCenter.default.post(name: .SignOut, object: nil)
          }
        }
    }
}

extension Setting:UITableViewDelegate, UITableViewDataSource{
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
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as? SettingCell{
            cell.label.text = ["Account","Privacy","Feedback"][indexPath.section]
            cell.image.image = UIImage(systemName:
                                        ["person.fill","hand.raised.fill","message.fill"][indexPath.section])?.applyingSymbolConfiguration(.init(pointSize: 12, weight: .light))
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            tableView.deselectRow(at: indexPath, animated: true)
        } completion: { _ in
            switch indexPath.section{
            case 0:
                let vc = AccountManagment()
                self.parent?.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = PrivacyVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                self.sendEmail()
            default:
                break
            }
        }

    }
}

extension Setting: MFMailComposeViewControllerDelegate{
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["cooper@gmail.com"])
            mail.setMessageBody("<p>Give us suggestions or tells us where you are having problem with the app to be addressed by our team.</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            os_log("Could not compose email")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

class SettingCell: UITableViewCell {
    
    var label:UILabel={
        let label = UILabel()
        label.Label(textColor: .Dark, textAlignment: .left, fontSize: 20, font: .AppleSDGothicNeo_Medium)
        return label
    }()
    
    var image:UIImageView={
       let img = UIImageView()
        img.backgroundColor = .clear
        img.tintColor = .Dark
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addsubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addsubviews(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = .cornerRadius
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = .clear
        self.contentView.layer.cornerRadius = .cornerRadius
        self.contentView.layer.masksToBounds = true
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 25),
            image.heightAnchor.constraint(equalToConstant: 25),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.layoutIfNeeded()
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .topConstant),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: .leftConstant),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .bottomConstant),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
    }
}
