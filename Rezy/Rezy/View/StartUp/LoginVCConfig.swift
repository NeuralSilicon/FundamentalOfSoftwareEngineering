

import UIKit

extension LoginVC{
    
    
    func addsubviews(){
        
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .topStandAloneConstant*2),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .leftConstant),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .rightConstant),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
            
        view.addSubview(blur)
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .topStandAloneConstant*2),
            blur.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blur.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            blur.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        let blurView = blur.contentView
        
        username.delegate = self
        blurView.addSubview(username)
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: blurView.topAnchor, constant: .topStandAloneConstant),
            username.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            username.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: .leftConstant*4),
            username.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: .rightConstant*4),
            username.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        password.delegate = self
        blurView.addSubview(password)
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: username.bottomAnchor, constant: .topConstant),
            password.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            password.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: .leftConstant*4),
            password.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: .rightConstant*4),
            password.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        blurView.addSubview(login)
        NSLayoutConstraint.activate([
            login.topAnchor.constraint(equalTo: password.bottomAnchor, constant: .topStandAloneConstant),
            login.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            login.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            login.heightAnchor.constraint(equalToConstant: 40),
        ])
        login.addTarget(self, action: #selector(SignIn), for: .touchUpInside)
        
        blurView.addSubview(register)
        NSLayoutConstraint.activate([
            register.topAnchor.constraint(equalTo: login.bottomAnchor, constant: .topConstant),
            register.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            register.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            register.heightAnchor.constraint(equalToConstant: 40),
        ])
        register.addTarget(self, action: #selector(SignUp), for: .touchUpInside)
        
        
        blurView.addSubview(passwordRecovery)
        NSLayoutConstraint.activate([
            passwordRecovery.topAnchor.constraint(equalTo: register.bottomAnchor, constant: .topConstant*2),
            passwordRecovery.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            passwordRecovery.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            passwordRecovery.heightAnchor.constraint(equalToConstant: 40),
        ])
        passwordRecovery.addTarget(self, action: #selector(passwordReset), for: .touchUpInside)
        
        blurView.addSubview(privacy)
        NSLayoutConstraint.activate([
            privacy.topAnchor.constraint(equalTo: passwordRecovery.bottomAnchor),
            privacy.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            privacy.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            privacy.heightAnchor.constraint(equalToConstant: 40),
        ])
        privacy.addTarget(self, action: #selector(privacyPage), for: .touchUpInside)
        
        blurView.addSubview(loginAsGuest)
        NSLayoutConstraint.activate([
            loginAsGuest.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: .bottomConstant - .topStandAloneConstant),
            loginAsGuest.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            loginAsGuest.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            loginAsGuest.heightAnchor.constraint(equalToConstant: 40),
        ])
        loginAsGuest.addTarget(self, action: #selector(SignInAsGuest), for: .touchUpInside)
        
        blurView.layoutSubviews()
    }
    
    @objc private func SignInAsGuest(){

        self.loginAsGuest.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            self.loginAsGuest.transform = .identity
        }
        
        let regist = Registeration()
        regist.delegate = self
        regist.createGuest()
    }
    
    
    @objc private func SignIn(){
        guard let username = username.text, let password = password.text else {return}
        self.login.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            self.login.transform = .identity
        }
        
        let signin = Login(username: username, password: password)
        delegate = signin.delegate
        signin.fetchUser { succeeded in
            if succeeded{
                let vc = Tabbar()
                let navig = UINavigationController(rootViewController: vc)
                navig.modalPresentationStyle = .fullScreen
                navig.modalTransitionStyle = .flipHorizontal
                navig.navigationBar.isHidden = true
                self.present(navig, animated: true, completion: nil)
            }else{
                let activity = UIAlertController(title: nil, message: "Failed to Login, Email/Password is wrong", preferredStyle: .alert)
                activity.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                self.present(activity, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func SignUp(){
        let vc = ReVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func SignInApple(){
        
    }
    
    @objc private func passwordReset(){
        let vc = ResetPassword()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func privacyPage(){
        let vc = PrivacyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            password.becomeFirstResponder()
        }else{
            password.resignFirstResponder()
        }
        return true
    }
    
}
