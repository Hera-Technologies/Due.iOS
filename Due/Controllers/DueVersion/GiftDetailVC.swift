//
//  GiftDetailVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/27/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import Alamofire 

class GiftDetailVC: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate {

    init(image: UIImage, name: String, desc: String, amount: String) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.name = name
        self.desc = desc
        self.amount = amount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let indicator = UIActivityIndicatorView()
    var image: UIImage?
    var name: String?
    var desc: String?
    var amount: String?
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "left"), for: .normal)
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = offwhite
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let descTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Descrição"
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let descMsg: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.textAlignment = .justified
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let amountLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lineTwo: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let nameIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "hint")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let nameField: UITextField = {
        let txt = UITextField()
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.placeholder = "Nome ou apelido"
        txt.textColor = darker
        txt.backgroundColor = .clear
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let payField: STPPaymentCardTextField = {
        let txt = STPPaymentCardTextField()
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.textColor = darker
        txt.backgroundColor = .clear
        txt.borderWidth = 0
        txt.numberPlaceholder = "cartão nº"
        txt.expirationPlaceholder = "mm/aa"
        txt.cvcPlaceholder = "cvc"
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let cardWarning: UILabel = {
        let lbl = UILabel()
        lbl.text = "*Somente cartões de crédito"
        lbl.textColor = darker
        lbl.textAlignment = .right
        lbl.font = UIFont(name: "Avenir-Roman", size: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let buyBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Confirmar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let warning: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        *Estes presentes servem apenas para dar uma ideia do que você estaria proporcionando ao casal.
        """
        lbl.textColor = darker
        lbl.textAlignment = .justified
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir-Roman", size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupData()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    func setupData() {
        if let img = image, let name = name, let desc = desc, let amt = amount {
            self.photo.image = img
            self.viewTitle.text = name
            self.descMsg.text = desc
            self.amountLbl.text = "Valor: \(amt)"
        }
    }
    
    func setup() {
        
        view.addSubview(photo)
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(descTitle)
        view.addSubview(descMsg)
        view.addSubview(amountLbl)
        view.addSubview(lineTwo)
        view.addSubview(nameIcon)
        view.addSubview(nameField)
        view.addSubview(payField)
        view.addSubview(cardWarning)
        view.addSubview(buyBtn)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photo.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        photo.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        photo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 15).isActive = true
        viewTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        descTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        
        descMsg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descMsg.topAnchor.constraint(equalTo: descTitle.bottomAnchor, constant: 8).isActive = true
        descMsg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        amountLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        amountLbl.topAnchor.constraint(equalTo: descMsg.bottomAnchor, constant: 8).isActive = true
        
        lineTwo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        lineTwo.topAnchor.constraint(equalTo: amountLbl.bottomAnchor, constant: 5).isActive = true
        lineTwo.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineTwo.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        nameIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameIcon.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 20).isActive = true
        nameIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        nameIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nameField.centerYAnchor.constraint(equalTo: nameIcon.centerYAnchor).isActive = true
        nameField.leftAnchor.constraint(equalTo: nameIcon.rightAnchor, constant: 12).isActive = true
        nameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameField.delegate = self
        
        payField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 7).isActive = true
        payField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 6).isActive = true
        payField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        payField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        payField.delegate = self
        
        cardWarning.topAnchor.constraint(equalTo: payField.bottomAnchor, constant: 0).isActive = true
        cardWarning.trailingAnchor.constraint(equalTo: payField.trailingAnchor).isActive = true
        
        let height = view.frame.height * 0.08
        var btnY: CGFloat?
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            btnY = view.frame.height * 0.32
        } else if size < 414 && size > 320 {
            btnY = view.frame.height * 0.35
        } else if size <= 320 {
            btnY = view.frame.height * 0.43
        }
        
        buyBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buyBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnY!).isActive = true
        buyBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        buyBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        buyBtn.layer.cornerRadius = height / 2
        buyBtn.addTarget(self, action: #selector(requestPayment), for: .touchUpInside)
        
        if size > 320 {
            view.addSubview(warning)
            warning.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            warning.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
            warning.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        }
        
    }
    
    @objc func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
// MARK: STRIPE PAYMENT METHODS
    
    @objc func requestPayment() {
        if nameField.text != "" && payField.hasText && payField.isValid {
            SweetAlert().showAlert("Antes de finalizar...", subTitle: "Deseja confirmar a operacão?", style: .warning, buttonTitle: "Cancelar", buttonColor: UIColor.colorFromRGB(0xFF8989), otherButtonTitle: "Confirmar", otherButtonColor: UIColor.colorFromRGB(0x99B9f3)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    self.clearFields()
                } else {
                    showActivityIndicator(view: self.view, indicator: self.indicator)
                    self.generateToken()
                }
            }
        } else {
            let alerta = UIAlertController(title: "Ops!", message: "Por favor, preencha ambos os campos", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(action)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    func generateToken() {
        let cardParams = STPCardParams()
        cardParams.number = self.payField.cardNumber
        cardParams.expMonth = self.payField.expirationMonth
        cardParams.expYear = self.payField.expirationYear
        cardParams.cvc = self.payField.cvc
        STPAPIClient.shared().createToken(withCard: cardParams, completion: { (token, error) in
            if let err = error {
                let alert = UIAlertController(title: "Oops...", message: err.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else if let token = token {
                self.submitToken(token: token, completion: { (error: Error?) in
                    if error != nil {
                        print(error ?? Error.self)
                        return
                    }
                })
            }
        })
    }
    
    func submitToken(token: STPToken, completion: (_ error: Error) -> ()) {
        let backendUrl: URL = URL(string: "https://herasoft.com.br/manager/donation")!
        let value = identifyNumbers(amount: amountLbl.text!)
        if eventModel.stripeAcc != nil {
            let params: Parameters = ["destination": eventModel.stripeAcc!, "stripeToken": token.tokenId, "amount": value, "description": nameField.text!, "userEmail": details.email!]
            Alamofire.request(backendUrl, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
                print(response)
                if response.result.description == "SUCCESS" {
                    dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                        _ = SweetAlert().showAlert("Muito obrigado! ❤️", subTitle: "Seu presente será processado. Se tudo der certo, você receberá a confirmação por email.", style: .success)
                        self.clearFields()
                    })
                } else {
                    dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                        let errMessage = """
                    Não foi possível realizar a transação. Verifique os possíveis motivos clicando no botão "FAQ" acima.
                    """
                        _ = SweetAlert().showAlert("Oops...", subTitle: errMessage, style: .customImag(imageFile: "sad"), buttonTitle: "Ok")
                    })
                }
            })
        }
    }
    
// MARK: KEYBOARD AND FIELDS METHODS
    
    func clearFields() {
        nameField.text = ""
        payField.clear()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}




