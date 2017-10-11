//
//  InitialVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Presentr
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class InitialVC: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    lazy var gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.frame = self.view.bounds
        grad.colors = bourbon
        return grad
    }()
    
    let signupAlert: Presentr = {
        let customPresenter = Presentr(presentationType: .popup)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.backgroundColor = .lightGray
        customPresenter.backgroundOpacity = 0.5
        customPresenter.cornerRadius = 8
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    let faqBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("FAQ", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "whiteicon")
        img.contentMode = .scaleAspectFit
        img.alpha = 0
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let emailContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.alpha = 0.35
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let emailIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "whitemail")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let emailTxt: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.placeholder = "Email"
        tf.textColor = .white
        tf.font = UIFont(name: "Avenir-Roman", size: 18)
        tf.textAlignment = .right
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.alpha = 0.35
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let passIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "whitepass")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let passTxt: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.placeholder = "Senha"
        tf.textColor = .white
        tf.font = UIFont(name: "Avenir-Roman", size: 18)
        tf.textAlignment = .right
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let loginBtn: BounceButton = {
        let btn = BounceButton()
        btn.setImage(#imageLiteral(resourceName: "loginbtn"), for: .normal)
        btn.backgroundColor = UIColor(red: 184/255, green: 233/255, blue: 134/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let forgotPassBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Senha?", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Criar conta", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let orLbl: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "orlbl")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let fbBtn: BounceButton = {
        let btn = BounceButton()
        btn.setImage(#imageLiteral(resourceName: "fblogin"), for: .normal)
        btn.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let googleBtn: BounceButton = {
        let btn = BounceButton()
        btn.setImage(#imageLiteral(resourceName: "googlelogin"), for: .normal)
        btn.backgroundColor = UIColor(red: 253/255, green: 90/255, blue: 110/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        setup()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UI SETUP
    
    func setup() {
        
        view.addSubview(faqBtn)
        view.addSubview(logo)
        view.addSubview(emailContainer)
        view.addSubview(emailIcon)
        view.addSubview(emailTxt)
        view.addSubview(passContainer)
        view.addSubview(passIcon)
        view.addSubview(passTxt)
        view.addSubview(forgotPassBtn)
        view.addSubview(loginBtn)
        view.addSubview(fbBtn)
        view.addSubview(orLbl)
        view.addSubview(googleBtn)
        view.addSubview(signupBtn)
        
        let logoY = view.frame.height * 0.3
        let containerY = view.frame.height * 0.05
        let hgt = view.frame.height * 0.075
        
        faqBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        faqBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        faqBtn.addTarget(self, action: #selector(showFAQ), for: .touchUpInside)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -logoY).isActive = true
        logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        logo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        emailContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -containerY).isActive = true
        emailContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        emailContainer.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        emailContainer.layer.cornerRadius = hgt / 2
        
        emailIcon.centerYAnchor.constraint(equalTo: emailContainer.centerYAnchor).isActive = true
        emailIcon.leftAnchor.constraint(equalTo: emailContainer.leftAnchor, constant: 25).isActive = true
        emailIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        emailIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        emailTxt.centerYAnchor.constraint(equalTo: emailContainer.centerYAnchor).isActive = true
        emailTxt.rightAnchor.constraint(equalTo: emailContainer.rightAnchor, constant: -25).isActive = true
        emailTxt.leftAnchor.constraint(equalTo: emailIcon.rightAnchor, constant: 15).isActive = true
        emailTxt.delegate = self
        
        passContainer.topAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 12).isActive = true
        passContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        passContainer.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        passContainer.layer.cornerRadius = hgt / 2
        
        passIcon.centerYAnchor.constraint(equalTo: passContainer.centerYAnchor).isActive = true
        passIcon.centerXAnchor.constraint(equalTo: emailIcon.centerXAnchor).isActive = true
        passIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
        passIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        passTxt.centerYAnchor.constraint(equalTo: passContainer.centerYAnchor).isActive = true
        passTxt.rightAnchor.constraint(equalTo: passContainer.rightAnchor, constant: -25).isActive = true
        passTxt.leftAnchor.constraint(equalTo: passIcon.rightAnchor, constant: 15).isActive = true
        passTxt.delegate = self
        
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: passContainer.bottomAnchor, constant: 25).isActive = true
        loginBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        loginBtn.layer.cornerRadius = hgt / 2
        loginBtn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        signupBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 8).isActive = true
        signupBtn.leadingAnchor.constraint(equalTo: loginBtn.leadingAnchor, constant: 15).isActive = true
        signupBtn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        forgotPassBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 8).isActive = true
        forgotPassBtn.trailingAnchor.constraint(equalTo: loginBtn.trailingAnchor, constant: -15).isActive = true
        forgotPassBtn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        let lblY = view.frame.height * 0.3
        
        orLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        orLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: lblY).isActive = true
        
        fbBtn.leadingAnchor.constraint(equalTo: loginBtn.leadingAnchor, constant: 0).isActive = true
        fbBtn.topAnchor.constraint(equalTo: orLbl.bottomAnchor, constant: 20).isActive = true
        fbBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        fbBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        fbBtn.layer.cornerRadius = hgt / 2
        fbBtn.addTarget(self, action: #selector(loginWithFB), for: .touchUpInside)
        
        googleBtn.trailingAnchor.constraint(equalTo: loginBtn.trailingAnchor).isActive = true
        googleBtn.topAnchor.constraint(equalTo: orLbl.bottomAnchor, constant: 20).isActive = true
        googleBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        googleBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        googleBtn.layer.cornerRadius = hgt / 2
        googleBtn.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.logo.alpha = 1
        })
        
    }
    
    @objc func signup() {
        let signup = SignupVC()
        customPresentViewController(signupAlert, viewController: signup, animated: true, completion: nil)
    }
    
    @objc func showFAQ() {
        self.navigationController?.pushViewController(FaqVC(), animated: true)
    }
    
    // MARK: KEYBOARD METHODS
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: NORMAL LOGIN AND PASSWORD RESET
    
    func autoLogin() {
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                let homeScreen = UINavigationController(rootViewController: HomeVC())
                self.present(homeScreen, animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleLogin() {
        guard let emaill = emailTxt.text, let password = passTxt.text else { return }
        Auth.auth().signIn(withEmail: emaill, password: password, completion: { (user, err) in
            if err != nil {
                let errorAlert = UIAlertController(title: "Hmm...", message: err?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                errorAlert.addAction(ok)
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            let homeScreen = UINavigationController(rootViewController: HomeVC())
            self.present(homeScreen, animated: true, completion: nil)
        })
    }
    
    func resetPassword() {
        if emailTxt.text != nil {
            Auth.auth().sendPasswordReset(withEmail: emailTxt.text!, completion: { (error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Oops"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Email enviado"
                    message = "Verifique sua caixa de entrada para redefinir sua senha"
                    self.emailTxt.text = ""
                }
                let resetAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                resetAlert.addAction(ok)
                self.present(resetAlert, animated: true, completion: nil)
            })
        } else {
            let noEmail = UIAlertController(title: "Oops", message: "Por favor, indique um endereço de email", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            noEmail.addAction(ok)
            self.present(noEmail, animated: true, completion: nil)
        }
    }
    
    // MARK: GOOGLE LOGIN
    
    @objc func loginWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            _ = SweetAlert().showAlert("Oops...", subTitle: "Não foi possível fazer o login.", style: .error, buttonTitle: "Ok")
            return
        }
        if let idToken = user.authentication.idToken, let token = user.authentication.accessToken {
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: token)
            Auth.auth().signIn(with: credentials, completion: { (user, err) in
                if err != nil {
                    _ = SweetAlert().showAlert("Oops...", subTitle: "Não foi possível fazer o login.", style: .error, buttonTitle: "Ok")
                    return
                }
                guard let uid = user?.uid else { return }
                let ref = Database.database().reference().child("Users").child(uid)
                ref.updateChildValues(["email": user?.email as Any, "name": user?.displayName as Any])
                if let photo = user?.photoURL {
                    let url = photo.absoluteString
                    let value = ["photo": url]
                    ref.updateChildValues(value)
                }
            })
        }
    }
    
    // MARK: FACEBOOK LOGIN
    
    @objc func loginWithFB() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                _ = SweetAlert().showAlert("Oops...", subTitle: "Não foi possível fazer o login.", style: .error, buttonTitle: "Ok")
                return
            }
            guard let result = result else { return }
            guard let token = result.token else { return }
            guard let tokenStr = token.tokenString else { return }
            self.createFBUser(token: tokenStr)
        }
    }
    
    func createFBUser(token: String) {
        let credentials = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credentials) { (user, err) in
            if err != nil {
                _ = SweetAlert().showAlert("Oops...", subTitle: "Não foi possível fazer o login.", style: .error, buttonTitle: "Ok")
                return
            }
            guard let uid = user?.uid else { return }
            let ref = Database.database().reference().child("Users").child(uid)
            ref.updateChildValues(["email": user?.email as Any, "name": user?.displayName as Any])
            if let photo = user?.photoURL {
                let url = photo.absoluteString
                let value = ["photo": url]
                ref.updateChildValues(value)
            }
        }
    }
    
}


