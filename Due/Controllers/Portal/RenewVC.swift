//
//  RenewVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import Alamofire

class RenewVC: UIViewController, STPPaymentCardTextFieldDelegate {
    
    let logo: UILabel = {
        let lbl = UILabel()
        lbl.text = "D"
        lbl.textColor  = linewhite
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        lbl.layer.borderColor = linewhite.cgColor
        lbl.layer.borderWidth = 1
        lbl.font = UIFont(name: "Avenir-Light", size: 30)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let closeBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let questionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Por quantos meses quer prolongar sua versão?"
        lbl.textColor  = darker
        lbl.textAlignment = .justified
        lbl.font = UIFont(name: "Avenir-Light", size: 25)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.2
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let stepper: UIStepper = {
        let step = UIStepper()
        step.value = 1
        step.minimumValue = 1
        step.maximumValue = 3
        step.tintColor = dark
        step.translatesAutoresizingMaskIntoConstraints = false
        return step
    }()
    
    let numberLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "1"
        lbl.textColor = darker
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 60)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let monthLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "mês"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lineOne: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let totalLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "total"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let amountLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "R$ 5,99"
        lbl.textColor = darker
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
    
    let payField: STPPaymentCardTextField = {
        let txt = STPPaymentCardTextField()
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.textColor = darker
        txt.backgroundColor = .clear
        txt.numberPlaceholder = "Cartão nº"
        txt.expirationPlaceholder = "mm/aa"
        txt.cvcPlaceholder = "cvc"
        txt.layer.borderWidth = 0
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let buyBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Confirmar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    func setup() {
        
        view.addSubview(logo)
        view.addSubview(closeBtn)
        view.addSubview(questionLbl)
        view.addSubview(stepper)
        view.addSubview(numberLbl)
        view.addSubview(monthLbl)
        view.addSubview(lineOne)
        view.addSubview(totalLbl)
        view.addSubview(amountLbl)
        view.addSubview(lineTwo)
        view.addSubview(payField)
        view.addSubview(buyBtn)
        
        let size = view.frame.width * 0.15
        let logoY = view.frame.height * 0.26
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -logoY).isActive = true
        logo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        logo.widthAnchor.constraint(equalToConstant: size).isActive = true
        logo.heightAnchor.constraint(equalToConstant: size).isActive = true
        logo.layer.cornerRadius = size / 2
        
        closeBtn.topAnchor.constraint(equalTo: logo.topAnchor, constant: -12).isActive = true
        closeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        questionLbl.frame = CGRect(x: 15, y: view.frame.height * 0.12, width: view.frame.width * 0.7, height: 65)
        
        stepper.bottomAnchor.constraint(equalTo: monthLbl.bottomAnchor).isActive = true
        stepper.leadingAnchor.constraint(equalTo: lineOne.leadingAnchor).isActive = true
        stepper.addTarget(self, action: #selector(changeMonths), for: .valueChanged)
        
        numberLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numberLbl.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 18).isActive = true
        numberLbl.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        monthLbl.leftAnchor.constraint(equalTo: numberLbl.rightAnchor, constant: 20).isActive = true
        monthLbl.bottomAnchor.constraint(equalTo: numberLbl.bottomAnchor, constant: -2).isActive = true
        
        lineOne.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineOne.topAnchor.constraint(equalTo: numberLbl.bottomAnchor, constant: 15).isActive = true
        lineOne.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.88).isActive = true
        lineOne.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        totalLbl.leadingAnchor.constraint(equalTo: lineOne.leadingAnchor, constant: 4).isActive = true
        totalLbl.topAnchor.constraint(equalTo: lineOne.bottomAnchor, constant: 15).isActive = true
        
        amountLbl.topAnchor.constraint(equalTo: lineOne.bottomAnchor, constant: 15).isActive = true
        amountLbl.trailingAnchor.constraint(equalTo: lineOne.trailingAnchor).isActive = true
        
        lineTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineTwo.topAnchor.constraint(equalTo: amountLbl.bottomAnchor, constant: 15).isActive = true
        lineTwo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.88).isActive = true
        lineTwo.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        payField.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 12).isActive = true
        payField.leadingAnchor.constraint(equalTo: lineOne.leadingAnchor, constant: -10).isActive = true
        payField.trailingAnchor.constraint(equalTo: lineOne.trailingAnchor).isActive = true
        payField.delegate = self
        
        let height = view.frame.height * 0.07
        buyBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buyBtn.topAnchor.constraint(equalTo: payField.bottomAnchor, constant: 20).isActive = true
        buyBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        buyBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        buyBtn.layer.cornerRadius = height / 2
        buyBtn.addTarget(self, action: #selector(verifyFields), for: .touchUpInside)
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeMonths() {
        let value = Int(stepper.value)
        numberLbl.text = String(value)
        switch numberLbl.text! {
        case "1":
            monthLbl.text = "mês"
            amountLbl.text = "R$ 5,99"
        case "2":
            monthLbl.text = "meses"
            amountLbl.text = "R$ 10,99"
        case "3":
            monthLbl.text = "meses"
            amountLbl.text = "R$ 14,99"
        default:
            break
        }
    }
    
    // MARK: KEYBOARD METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: BEGINNING PURCHASE
    
    // 1. Verify card field for text and valid card data
    
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
    
    // 2. Create secure token with card data and send it to our backend app
    
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
    
    // 3. Submit token to our node.js app
    
    func sendToken(token: STPToken, completion: (_ error: Error) -> ()) {
        let value = identifyNumbers(amount: amountLbl.text!)
        let desc = "Versão prolongada por " + numberLbl.text! + " mês/meses"
        let backendUrl: URL = URL(string: "https://herasoft.com.br/manager/product_checkout")!
        let params: Parameters = ["stripeToken": token.tokenId, "description": desc, "userEmail": details.email!, "amount": value]
        Alamofire.request(backendUrl, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            if response.result.description == "SUCCESS" {
                self.renewVersion()
                self.payField.clear()
                _ = SweetAlert().showAlert("Muito obrigado! ❤️", subTitle: "Seu presente será processado. Se tudo der certo, você receberá a confirmação por email.", style: .success)
            } else {
                _ = SweetAlert().showAlert("Oops...", subTitle: "Sentimos muito. Não foi possível realizar a transação.", style: .customImag(imageFile: "sad"), buttonTitle: "Ok")
            }
        })
    }
    
    // Add time to Due version
    
    func renewVersion() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        if let dateStart = details.dateEnd {
            if let start = formatter.date(from: dateStart) {
                let endDate = Calendar.current.date(byAdding: .month, value: Int(numberLbl.text!)!, to: start)
                let exp = formatter.string(from: endDate!)
                details.dateEnd = exp
                Database.database().reference().child("Codes").child(details.eventID!).updateChildValues(["dateEnd": exp])
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "versionRenewed"), object: nil)
                _ = SweetAlert().showAlert("Tudo certo!", subTitle: "O prazo de validade da sua versão foi prolongado com sucesso!", style: AlertStyle.success, buttonTitle: "Ok", action: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
}

