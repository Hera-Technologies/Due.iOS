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
    
    let line1: UIView = {
        let ln = UIView()
        ln.backgroundColor = .white
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let emailIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "emailsmall")
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
        tf.textAlignment = .left
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "locksmall")
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
        tf.textAlignment = .left
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let forgotPassBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Senha?", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Light", size: 14)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Entrar", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let signupLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Primeira vez aqui?"
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Criar conta", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let fbBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("f", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Black", size: 30)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let googleBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("g+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Baskerville", size: 30)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
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
        view.addSubview(line1)
        view.addSubview(emailIcon)
        view.addSubview(emailTxt)
        view.addSubview(passIcon)
        view.addSubview(passTxt)
        view.addSubview(forgotPassBtn)
        view.addSubview(loginBtn)
        view.addSubview(signupLbl)
        view.addSubview(fbBtn)
        view.addSubview(googleBtn)
        view.addSubview(signupBtn)
        
        faqBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        faqBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        faqBtn.addTarget(self, action: #selector(showFAQ), for: .touchUpInside)
        
        let distance = view.frame.size.height / 3.3
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -distance).isActive = true
        logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        logo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        emailIcon.leadingAnchor.constraint(equalTo: line1.leadingAnchor, constant: 5).isActive = true
        emailIcon.centerYAnchor.constraint(equalTo: emailTxt.centerYAnchor).isActive = true
        emailTxt.leftAnchor.constraint(equalTo: emailIcon.rightAnchor, constant: 13).isActive = true
        emailTxt.bottomAnchor.constraint(equalTo: line1.topAnchor, constant: 0).isActive = true
        emailTxt.widthAnchor.constraint(equalTo: line1.widthAnchor, multiplier: 1).isActive = true
        emailTxt.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        emailTxt.delegate = self
        
        let lineY = view.frame.height * 0.07
        line1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lineY).isActive = true
        line1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        passIcon.leadingAnchor.constraint(equalTo: line1.leadingAnchor, constant: 5).isActive = true
        passIcon.centerYAnchor.constraint(equalTo: passTxt.centerYAnchor).isActive = true
        passTxt.topAnchor.constraint(equalTo: line1.bottomAnchor, constant: 0).isActive = true
        passTxt.rightAnchor.constraint(equalTo: forgotPassBtn.leftAnchor, constant: -8).isActive = true
        passTxt.leftAnchor.constraint(equalTo: passIcon.rightAnchor, constant: 13).isActive = true
        passTxt.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        passTxt.delegate = self
        
        forgotPassBtn.trailingAnchor.constraint(equalTo: line1.trailingAnchor).isActive = true
        forgotPassBtn.centerYAnchor.constraint(equalTo: passTxt.centerYAnchor).isActive = true
        forgotPassBtn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        let hgt = view.frame.height * 0.07
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.topAnchor.constraint(equalTo: passTxt.bottomAnchor, constant: 25).isActive = true
        loginBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        loginBtn.layer.cornerRadius = hgt / 2
        loginBtn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        let lblY = view.frame.height * 0.2
        signupLbl.leadingAnchor.constraint(equalTo: line1.leadingAnchor).isActive = true
        signupLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: lblY).isActive = true
        
        signupBtn.centerYAnchor.constraint(equalTo: signupLbl.centerYAnchor).isActive = true
        signupBtn.leftAnchor.constraint(equalTo: signupLbl.rightAnchor, constant: 8).isActive = true
        signupBtn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        let y = view.frame.height * 0.37
        let size: CGFloat = 65
        fbBtn.trailingAnchor.constraint(equalTo: line1.trailingAnchor).isActive = true
        fbBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y).isActive = true
        fbBtn.widthAnchor.constraint(equalToConstant: size).isActive = true
        fbBtn.heightAnchor.constraint(equalToConstant: size).isActive = true
        fbBtn.layer.cornerRadius = size / 2
        fbBtn.addTarget(self, action: #selector(loginWithFB), for: .touchUpInside)
        
        googleBtn.rightAnchor.constraint(equalTo: fbBtn.leftAnchor, constant: -35).isActive = true
        googleBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: y).isActive = true
        googleBtn.widthAnchor.constraint(equalToConstant: size).isActive = true
        googleBtn.heightAnchor.constraint(equalToConstant: size).isActive = true
        googleBtn.layer.cornerRadius = size / 2
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
        navigationController?.pushViewController(FaqVC(), animated: true)
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
            print(error.localizedDescription)
            return
        }
        if let idToken = user.authentication.idToken, let token = user.authentication.accessToken {
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: token)
            Auth.auth().signIn(with: credentials, completion: { (user, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "")
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
                _ = SweetAlert().showAlert("Oops...", subTitle: "Não foi possível logar com o Facebook", style: .error, buttonTitle: "Ok")
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
                print(err?.localizedDescription ?? "")
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


