//
//  CheckoutVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import Alamofire

class CheckoutVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    let cardFront = CardFront()
    let cardBack = CardBack()
    let indicator = UIActivityIndicatorView()
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Checkout"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let back: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(.black, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let faq: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("i", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 22)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 15
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let container: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        return vi
    }()
    
    let scrollView: UIScrollView = {
        let vi = UIScrollView()
        vi.showsVerticalScrollIndicator = false
        vi.backgroundColor = .white
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let title1: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dados"
        lbl.backgroundColor = offwhite
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let emailIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "grayemail")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var emailField: CustomTF = {
        let txt = CustomTF()
        txt.text = "Email: " + details.email!
        txt.font = UIFont(name: "Avenir-Book", size: 15)
        txt.backgroundColor = .clear
        txt.isUserInteractionEnabled = false
        txt.textColor = .black
        txt.layer.cornerRadius = 8
        txt.keyboardType = .emailAddress
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let linha: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let nameIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "user")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let nameField: CustomTF = {
        let txt = CustomTF()
        txt.text = "Nome: " + details.name!
        txt.font = UIFont(name: "Avenir-Book", size: 15)
        txt.backgroundColor = .clear
        txt.isUserInteractionEnabled = false
        txt.textColor = .black
        txt.layer.cornerRadius = 8
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let payField: STPPaymentCardTextField = {
        let txt = STPPaymentCardTextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = UIFont(name: "Avenir-Book", size: 15)
        txt.textColor = .black
        txt.backgroundColor = .clear
        txt.numberPlaceholder = "Cartão nº"
        txt.expirationPlaceholder = "mm/aa"
        txt.cvcPlaceholder = "cvc"
        txt.layer.borderWidth = 0
        return txt
    }()
    
    let title2: UILabel = {
        let lbl = UILabel()
        lbl.text = "Informações importantes"
        lbl.backgroundColor = offwhite
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let info: UITextView = {
        let txt = UITextView()
        txt.text = """
        ▫️ No momento, apenas cartões de crédito são aceitos.
        
        ▫️ Ao adquirir uma versão Due, você passará a ter acesso ao portal, onde poderá editá-la. Ela será vinculada ao email acima.
        
        ▫️ O prazo de validade da versão Due é de 3 meses. Fica a seu critério quando este período terá início.
        
        ▫️ Ao iniciar a versão, esta assumirá o status "online", e se tornará acessível para outros usuários.
        """
        txt.textColor = .darkGray
        txt.backgroundColor = .clear
        txt.font = UIFont(name: "Avenir-Light", size: 14)
        txt.textAlignment = .justified
        txt.isEditable = false
        txt.isSelectable = false
        txt.isScrollEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let buy: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("finalizar compra", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = linewhite
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        faq.addTarget(self, action: #selector(showFAQ), for: .touchUpInside)
        buy.addTarget(self, action: #selector(paymentSuccess), for: .touchUpInside)
        payField.delegate = self
        
    }
    
    func setup() {
        
        view.addSubview(container)
        container.frame.size = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.22)
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            container.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.23)
        } else if size < 414 && size > 320 {
            container.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.25)
        } else if size <= 320 {
            container.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.26)
        }
        cardFront.frame.size.width = container.frame.size.width
        cardFront.frame.size.height = container.frame.size.height
        cardFront.setup()
        cardFront.createGradientLayer()
        cardBack.frame.size.width = container.frame.size.width
        cardBack.frame.size.height = container.frame.size.height
        cardBack.setup()
        cardBack.createGradientLayer()
        container.addSubview(cardBack)
        container.addSubview(cardFront)
        
        view.addSubview(back)
        view.addSubview(titulo)
        view.addSubview(faq)
        view.addSubview(buy)
        view.addSubview(scrollView)
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titulo.centerYAnchor.constraint(equalTo: back.centerYAnchor, constant: 4).isActive = true
        faq.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        faq.centerYAnchor.constraint(equalTo: back.centerYAnchor).isActive = true
        faq.heightAnchor.constraint(equalToConstant: 30).isActive = true
        faq.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let height = view.frame.height * 0.08
        buy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buy.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        buy.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        buy.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 25).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: buy.topAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(title1)
        scrollView.addSubview(info)
        scrollView.addSubview(title2)
        scrollView.addSubview(emailIcon)
        scrollView.addSubview(emailField)
        scrollView.addSubview(linha)
        scrollView.addSubview(nameIcon)
        scrollView.addSubview(nameField)
        scrollView.addSubview(line)
        scrollView.addSubview(payField)
        
        title1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        title1.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        title1.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        title1.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        emailIcon.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        emailIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        emailIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        emailIcon.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 18).isActive = true
        emailField.centerYAnchor.constraint(equalTo: emailIcon.centerYAnchor).isActive = true
        emailField.leftAnchor.constraint(equalTo: emailIcon.rightAnchor, constant: 3).isActive = true
        emailField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        linha.topAnchor.constraint(equalTo: emailIcon.bottomAnchor, constant: 13).isActive = true
        linha.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        linha.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        linha.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        nameIcon.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        nameIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        nameIcon.topAnchor.constraint(equalTo: linha.bottomAnchor, constant: 12).isActive = true
        nameField.centerYAnchor.constraint(equalTo: nameIcon.centerYAnchor).isActive = true
        nameField.leftAnchor.constraint(equalTo: nameIcon.rightAnchor, constant: 3).isActive = true
        nameField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        line.topAnchor.constraint(equalTo: nameIcon.bottomAnchor, constant: 13).isActive = true
        line.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 12).isActive = true
        line.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        payField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 4).isActive = true
        payField.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 3).isActive = true
        payField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        title2.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        title2.topAnchor.constraint(equalTo: payField.bottomAnchor, constant: 12).isActive = true
        title2.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        title2.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        info.topAnchor.constraint(equalTo: title2.bottomAnchor, constant: 10).isActive = true
        info.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        info.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        info.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func showFAQ() {
        let faqVC = ChargeFAQ()
        self.navigationController?.pushViewController(faqVC, animated: true)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        flip()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        flipBack()
    }
    
    func flip() {
        UIView.transition(from: cardFront, to: cardBack, duration: 0.5, options: [.transitionFlipFromTop, .showHideTransitionViews])
    }
    
    func flipBack() {
        UIView.transition(from: cardBack, to: cardFront, duration: 0.5, options: [.transitionFlipFromBottom, .showHideTransitionViews])
    }
    
    // MARK: BEGINNING PURCHASE
    
    // Verify name, email and card fields
    
    func verifyFields() {
        if payField.hasText && payField.isValid {
            generateToken()
        } else {
            let alerta = UIAlertController(title: "Oops", message: "Por favor, indique um cartão de crédito válido", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(action)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    // Create STPToken with card data
    
    func generateToken() {
        let cardParams = STPCardParams()
        cardParams.number = payField.cardNumber
        cardParams.expMonth = payField.expirationMonth
        cardParams.expYear = payField.expirationYear
        cardParams.cvc = payField.cvc
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, err) in
            if err != nil {
                _ = SweetAlert().showAlert("Oops...", subTitle: err?.localizedDescription, style: .error)
                return
            }
            if let token = token {
                self.sendToken(token: token, completion: { (err: Error?) in
                    if err != nil {
                        _ = SweetAlert().showAlert("Oops...", subTitle: err?.localizedDescription, style: .error)
                        return
                    }
                })
            }
        }
    }
    
    // Submit STPToken
    
    func sendToken(token: STPToken, completion: (_ error: Error) -> ()) {
        let desc = "produto: Due V, " + nameField.text!
        let backendUrl: URL = URL(string: "https://herasoft.com.br/manager/product_checkout")!
        let params: Parameters = ["stripeToken": token.tokenId, "amount": 999, "description": desc, "userEmail": details.email!]
        Alamofire.request(backendUrl, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            if response.result.description == "SUCCESS" {
                self.paymentSuccess()
                _ = SweetAlert().showAlert("Muito obrigado! ❤️", subTitle: "Seu presente será processado. Se tudo der certo, você receberá a confirmação por email.", style: AlertStyle.success)
            } else {
                let errMessage = """
                Não foi possível realizar a transação. Verifique os possíveis motivos clicando no botão "i" acima.
                """
                _ = SweetAlert().showAlert("Oops...", subTitle: errMessage, style: AlertStyle.customImag(imageFile: "sad"), buttonTitle: "Ok")
            }
        })
        paymentSuccess()
    }
    
    @objc func paymentSuccess() {
        payField.clear()
        if let user = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("Users").child(user)
            let value = ["hasDue": true, "nameSet": false]
            ref.updateChildValues(value)
        }
        let success = ReceiptVC()
        self.navigationController?.pushViewController(success, animated: true)
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


