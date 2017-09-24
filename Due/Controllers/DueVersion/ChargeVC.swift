//
//  ChargeVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import Firebase

class ChargeVC: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var valores = ["Selecione", "50", "100", "150", "200", "250", "300", "350", "400", "450", "500", "600", "700", "800", "1000", "1500", "2000"]
    let picker = UIPickerView()
    let cardFront = CardFront()
    let cardBack = CardBack()
    let indicator = UIActivityIndicatorView()
    
    let gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = bourbon
        return grad
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Checkout"
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let faqBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("FAQ", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let container: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        return vi
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dados"
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let dataContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.layer.shadowColor = UIColor.darkGray.cgColor
        vi.layer.shadowOffset = CGSize(width: 0, height: 1.7)
        vi.layer.shadowRadius = 2.5
        vi.layer.shadowOpacity = 0.45
        vi.layer.cornerRadius = 4
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let nameIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "user")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let nameField: UITextField = {
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: "Avenir-Light", size: 18)
        name.placeholder = "Nome ou apelido"
        name.textColor = .darkGray
        name.backgroundColor = .clear
        return name
    }()
    
    let nameLine: UIView = {
        let vi = UIView()
        vi.backgroundColor = linewhite
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let payField: STPPaymentCardTextField = {
        let payField = STPPaymentCardTextField()
        payField.translatesAutoresizingMaskIntoConstraints = false
        payField.font = UIFont(name: "Avenir-Light", size: 18)
        payField.textColor = .darkGray
        payField.backgroundColor = .white
        payField.layer.opacity = 0.6
        payField.cornerRadius = 10
        payField.borderWidth = 0
        payField.numberPlaceholder = "Cartão nº"
        payField.expirationPlaceholder = "mm/aa"
        payField.clipsToBounds = true
        payField.layer.masksToBounds = true
        return payField
    }()
    
    let payLine: UIView = {
        let vi = UIView()
        vi.backgroundColor = linewhite
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let amountIcon: UILabel = {
        let icon = UILabel()
        icon.font = UIFont(name: "Avenir-Light", size: 20)
        icon.textColor = .lightGray
        icon.text = "R$"
        icon.backgroundColor = .clear
        icon.textAlignment = .center
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var amountField: UITextField = {
        var txt = UITextField()
        txt.backgroundColor = .clear
        txt.font = UIFont(name: "Avenir-Light", size: 18)
        txt.textColor = .darkGray
        txt.placeholder = "Valor desejado"
        txt.returnKeyType = .done
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let buyButton: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Confirmar", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.clipsToBounds = true
        btn.layer.masksToBounds = true
        return btn
    }()
    
    // MARK: VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        gradient.frame = buyButton.frame
        gradient.cornerRadius = buyButton.layer.cornerRadius
        view.layer.insertSublayer(gradient, at: 1)
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    // MARK: STRIPE PAYMENT METHODS
    
    @objc func requestPayment() {
        if nameField.text != "" && amountField.text != "" && payField.hasText && payField.isValid {
            SweetAlert().showAlert("Antes de finalizar...", subTitle: "Deseja confirmar a operacão?", style: AlertStyle.warning, buttonTitle: "Cancelar", buttonColor: UIColor.colorFromRGB(0xFF8989), otherButtonTitle: "Confirmar", otherButtonColor: UIColor.colorFromRGB(0x99B9f3)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    self.clearFields()
                } else {
                    showActivityIndicator(view: self.view, indicator: self.indicator)
                    self.generateToken()
                }
            }
        } else {
            let alerta = UIAlertController(title: "Ops!", message: "Por favor, prencha todos os campos", preferredStyle: .actionSheet)
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
        if eventModel.stripeAcc != nil {
            let params: Parameters = ["destination": eventModel.stripeAcc!, "stripeToken": token.tokenId, "amount": amountField.text!, "description": nameField.text!, "userEmail": details.email!]
            Alamofire.request(backendUrl, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
                print(response)
                if response.result.description == "SUCCESS" {
                    dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                        _ = SweetAlert().showAlert("Muito obrigado! ❤️", subTitle: "Seu presente será processado. Se tudo der certo, você receberá a confirmação por email.", style: AlertStyle.success)
                        self.clearFields()
                    })
                } else {
                    dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                        let errMessage = """
                    Não foi possível realizar a transação. Verifique os possíveis motivos clicando no botão "FAQ" acima.
                    """
                        _ = SweetAlert().showAlert("Oops...", subTitle: errMessage, style: AlertStyle.customImag(imageFile: "sad"), buttonTitle: "Ok")
                    })
                }
            })
        }
    }
    
    // MARK: UI VIEWS SETUP
    
    func setup() {
        
        var btnY: CGFloat?
        
        view.addSubview(container)
        container.frame.size = CGSize(width: view.frame.width * 0.67, height: view.frame.height * 0.23)
        container.center = CGPoint(x: view.frame.width / 2, y: view.frame.height * 0.35)
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            btnY = view.frame.height * 0.85
        } else if size < 414 && size > 320 {
            btnY = view.frame.height * 0.85
        } else if size <= 320 {
            btnY = view.frame.height * 0.9
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
        
        view.addSubview(backBtn)
        view.addSubview(faqBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(label)
        view.insertSubview(dataContainer, at: 0)
        view.addSubview(nameIcon)
        view.addSubview(nameField)
        view.addSubview(nameLine)
        view.addSubview(payField)
        view.addSubview(payLine)
        view.addSubview(amountIcon)
        view.addSubview(amountField)
        view.addSubview(buyButton)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        faqBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 4).isActive = true
        faqBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        faqBtn.addTarget(self, action: #selector(faq), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        label.bottomAnchor.constraint(equalTo: dataContainer.topAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        
        dataContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dataContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        dataContainer.topAnchor.constraint(equalTo: nameIcon.topAnchor, constant: -30).isActive = true
        dataContainer.bottomAnchor.constraint(equalTo: buyButton.centerYAnchor, constant: 0).isActive = true
        
        nameIcon.leftAnchor.constraint(equalTo: dataContainer.leftAnchor, constant: 25).isActive = true
        nameIcon.bottomAnchor.constraint(equalTo: payField.topAnchor, constant: -20).isActive = true
        nameIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        nameField.centerYAnchor.constraint(equalTo: nameIcon.centerYAnchor).isActive = true
        nameField.leftAnchor.constraint(equalTo: nameIcon.rightAnchor, constant: 12).isActive = true
        nameField.trailingAnchor.constraint(equalTo: payField.trailingAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameField.delegate = self
        
        nameLine.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 0).isActive = true
        nameLine.leadingAnchor.constraint(equalTo: nameIcon.leadingAnchor).isActive = true
        nameLine.trailingAnchor.constraint(equalTo: nameField.trailingAnchor).isActive = true
        nameLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        payField.leftAnchor.constraint(equalTo: dataContainer.leftAnchor, constant: 12).isActive = true
        payField.bottomAnchor.constraint(equalTo: amountIcon.topAnchor, constant: -20).isActive = true
        payField.rightAnchor.constraint(equalTo: dataContainer.rightAnchor, constant: -20).isActive = true
        payField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        payField.delegate = self
        
        payLine.topAnchor.constraint(equalTo: payField.bottomAnchor, constant: 2).isActive = true
        payLine.leadingAnchor.constraint(equalTo: nameIcon.leadingAnchor).isActive = true
        payLine.trailingAnchor.constraint(equalTo: payField.trailingAnchor).isActive = true
        payLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        amountIcon.leftAnchor.constraint(equalTo: dataContainer.leftAnchor, constant: 25).isActive = true
        amountIcon.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -25).isActive = true
        
        amountField.centerYAnchor.constraint(equalTo: amountIcon.centerYAnchor).isActive = true
        amountField.leftAnchor.constraint(equalTo: amountIcon.rightAnchor, constant: 12).isActive = true
        amountField.trailingAnchor.constraint(equalTo: payField.trailingAnchor).isActive = true
        amountField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        amountField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        
        let hgt = view.frame.height * 0.08
        buyButton.frame.size = CGSize(width: view.frame.width / 2, height: hgt)
        buyButton.frame.origin = CGPoint(x: view.frame.width * 0.25, y: btnY!)
        buyButton.layer.cornerRadius = hgt / 2
        buyButton.addTarget(self, action: #selector(requestPayment), for: .touchUpInside)
        
    }
    
    @objc func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func faq() {
        navigationController?.pushViewController(ChargeFAQ(), animated: true)
    }
    
    // MARK: PICKER DELEGATE AND DATA SOURCE
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valores[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            amountField.text = valores[row]
        } else {
            amountField.text = ""
        }
    }
    
    // MARK: CARD ANIMATION METHODS
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        flipCard()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        flipCardAgain()
    }
    
    func flipCard() {
        UIView.transition(from: cardFront, to: cardBack, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    func flipCardAgain() {
        UIView.transition(from: cardBack, to: cardFront, duration: 0.5, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    // MARK: KEYBOARD AND FIELDS METHODS
    
    func clearFields() {
        self.nameField.text = ""
        self.amountField.text = ""
        self.payField.clear()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
