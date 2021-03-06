//
//  SignupVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController, UITextFieldDelegate {
    
    let homeScreen = UINavigationController(rootViewController: HomeVC())
    
    let indicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.activityIndicatorViewStyle = .whiteLarge
        ind.hidesWhenStopped = true
        ind.translatesAutoresizingMaskIntoConstraints = false
        return ind
    }()
    
    let indicatorContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 0.6)
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Conta Due"
        lbl.textColor = dark
        lbl.backgroundColor = .clear
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 26)
        btn.setTitleColor(dark, for: UIControlState())
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let nameIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "hint")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let nameTxt: CustomTF = {
        let tf = CustomTF()
        tf.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        tf.placeholder = "Nome ou apelido"
        tf.textColor = .black
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        tf.layer.borderWidth = 0
        tf.layer.cornerRadius = 8
        tf.returnKeyType = .done
        tf.keyboardType = .default
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "email")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let emailTxt: CustomTF = {
        let tf = CustomTF()
        tf.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        tf.placeholder = "Email"
        tf.textColor = .black
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        tf.layer.borderWidth = 0
        tf.layer.cornerRadius = 8
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "password")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let passTxt: CustomTF = {
        let tf = CustomTF()
        tf.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        tf.placeholder = "Senha"
        tf.textColor = .black
        tf.font = UIFont(name: "Avenir-Light", size: 16)
        tf.layer.borderWidth = 0
        tf.layer.cornerRadius = 8
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Criar conta", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Já possui uma conta? Faça o login", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Light", size: 15)
        btn.setTitleColor(.darkGray, for: UIControlState())
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        setup()
        signupBtn.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignup() {
        guard let mail = emailTxt.text, let password = passTxt.text, let name = nameTxt.text else { return }
        Auth.auth().createUser(withEmail: mail, password: password, completion: { (user: User?, err) in
            self.indicateActivity()
            if err != nil {
                let alert = UIAlertController(title: "Hmm...", message: err?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.stopActivity {
                    return
                }
            }
            guard let uid = user?.uid else { return }
            let ref = Database.database().reference().child("Users").child(uid)
            let values = ["email": mail, "name": name]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "")
                    return
                }
                self.stopActivity {
                    self.present(self.homeScreen, animated: true, completion: nil)
                }
            })
        })
    }
    
    func setup() {
        
        view.addSubview(titulo)
        view.addSubview(closeBtn)
        view.addSubview(nameIcon)
        view.addSubview(nameTxt)
        view.addSubview(emailIcon)
        view.addSubview(emailTxt)
        view.addSubview(passIcon)
        view.addSubview(passTxt)
        view.addSubview(signupBtn)
        view.addSubview(loginBtn)
        view.addSubview(indicatorContainer)
        
        nameIcon.rightAnchor.constraint(equalTo: nameTxt.leftAnchor, constant: -10).isActive = true
        nameIcon.centerYAnchor.constraint(equalTo: nameTxt.centerYAnchor).isActive = true
        nameIcon.widthAnchor.constraint(equalToConstant: 27).isActive = true
        nameIcon.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        nameTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        nameTxt.bottomAnchor.constraint(equalTo: emailTxt.topAnchor, constant: -18).isActive = true
        nameTxt.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        nameTxt.heightAnchor.constraint(equalToConstant: 42).isActive = true
        nameTxt.delegate = self
        
        emailIcon.centerXAnchor.constraint(equalTo: nameIcon.centerXAnchor).isActive = true
        emailIcon.centerYAnchor.constraint(equalTo: emailTxt.centerYAnchor).isActive = true
        emailIcon.widthAnchor.constraint(equalToConstant: 23).isActive = true
        emailIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        emailTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        emailTxt.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -23).isActive = true
        emailTxt.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        emailTxt.heightAnchor.constraint(equalToConstant: 42).isActive = true
        emailTxt.delegate = self
        
        passIcon.centerXAnchor.constraint(equalTo: nameIcon.centerXAnchor).isActive = true
        passIcon.centerYAnchor.constraint(equalTo: passTxt.centerYAnchor).isActive = true
        passIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        passIcon.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        passTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        passTxt.topAnchor.constraint(equalTo: emailTxt.bottomAnchor, constant: 18).isActive = true
        passTxt.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        passTxt.heightAnchor.constraint(equalToConstant: 42).isActive = true
        passTxt.delegate = self
        
        let height = view.frame.height * 0.075
        signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        signupBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        signupBtn.topAnchor.constraint(equalTo: passTxt.bottomAnchor, constant: 30).isActive = true
        signupBtn.layer.cornerRadius = height / 2
        
        var btnY = CGFloat()
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            btnY = view.frame.height * 0.29
        } else {
            btnY = view.frame.height * 0.27
        }
        
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnY).isActive = true
        
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 3).isActive = true
        closeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        titulo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titulo.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 15).isActive = true
        
    }
    
    func indicateActivity() {
        view.addSubview(indicatorContainer)
        indicatorContainer.tag = 5
        indicatorContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        indicatorContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        indicatorContainer.layer.cornerRadius = 18
        indicatorContainer.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: indicatorContainer.centerYAnchor).isActive = true
        indicator.startAnimating()
    }
    
    func stopActivity(completion: () -> Void) {
        indicator.stopAnimating()
        view.viewWithTag(5)?.removeFromSuperview()
        completion()
    }
    
    // MARK: KEYBOARD METHODS
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


