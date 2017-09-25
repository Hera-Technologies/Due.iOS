//
//  GiftsVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Alamofire

fileprivate let cellID = "cell"

class GiftsVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var arr = [Donation]()
    let indicator = UIActivityIndicatorView()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let guideBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("guia", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Presentes"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let totalLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = darker
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let formBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "form"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "box")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Seus presentes aparecerão aqui.
        
        *Para receber presentes, crie sua conta Stripe, clicando no botão acima.
        """
        lbl.textColor  = .lightGray
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let collec: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.showsVerticalScrollIndicator = false
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGifts()
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        disableFromBtn()
    }
    
    // MARK: UI SETUP, NAVIGATION METHODS AND OTHERS
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(guideBtn)
        view.addSubview(viewTitle)
        view.addSubview(totalLbl)
        view.addSubview(formBtn)
        view.addSubview(line)
        view.addSubview(collec)
        view.insertSubview(hintImg, at: 0)
        view.insertSubview(hintMessage, at: 0)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 4).isActive = true
        
        guideBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        guideBtn.centerYAnchor.constraint(equalTo: viewTitle.centerYAnchor).isActive = true
        guideBtn.addTarget(self, action: #selector(showGuide), for: .touchUpInside)
        
        let lineY = view.frame.height * 0.32
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lineY).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        totalLbl.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -2).isActive = true
        totalLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        formBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -8).isActive = true
        formBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        formBtn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        formBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        formBtn.addTarget(self, action: #selector(openFormUrl), for: .touchUpInside)
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        hintMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintMessage.topAnchor.constraint(equalTo: hintImg.bottomAnchor, constant: 18).isActive = true
        hintMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        collec.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collec.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collec.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        collec.register(GiftCell.self, forCellWithReuseIdentifier: cellID)
        collec.dataSource = self
        collec.delegate = self
        
    }
    
    @objc func openFormUrl() {
        let nav = UINavigationController(rootViewController: FormVC())
        present(nav, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
    }
    
    @objc func showGuide() {
        present(GiftsGuideVC(), animated: true, completion: nil)
    }
    
    func disableFromBtn() {
        if details.stripeAcc != nil {
            self.formBtn.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
            self.formBtn.isEnabled = false
        }
    }
    
    func hideHints() {
        if arr.count > 0 {
            hintImg.isHidden = true
            hintMessage.isHidden = true
        }
    }
    
    // MARK: FETCH DONATIONS LIST
    
    func fetchGifts() {
        arr = []
        guard let url = URL(string: "https://herasoft.com.br/manager/gifts") else { return }
        guard let acc = details.stripeAcc else { return }
        showActivityIndicator(view: view, indicator: indicator)
        Alamofire.request(url, method: .post, parameters: ["acc": acc]).responseJSON(completionHandler: { (response) in
            dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {})
            if response.result.description == "SUCCESS" {
                if let res = response.result.value as? [[String: Any]] {
                    self.parseResponse(res: res)
                }
            } else {
                _ = SweetAlert().showAlert("Oops...", subTitle: "Não foi possível listar seus presentes.", style: .customImag(imageFile: "sad"), buttonTitle: "Ok")
            }
        })
    }
    
    func parseResponse(res: [[String: Any]]) {
        var total = 0
        for dict in res {
            guard let amount = dict["amount"] as? Int else { return }
            total += amount
            let donation = Donation(json: dict)
            self.arr.append(donation)
            DispatchQueue.main.async {
                self.collec.reloadData()
                self.hideHints()
            }
        }
        totalLbl.text = "Total: R$" + String(describing: total) + ",00"
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GiftCell
        cell.vc = self
        cell.configure(model: arr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat?
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            height = view.frame.height * 0.2
        } else if size < 414 && size > 320 {
            height = view.frame.height * 0.22
        } else if size <= 320 {
            height = view.frame.height * 0.24
        }
        return CGSize(width: view.frame.width * 0.9, height: height!)
    }
    
    // MARK: COLLECTION VIEW CELL
    
    class GiftCell: UICollectionViewCell {
        
        var model: Donation?
        var vc: GiftsVC?
        
        let logo: UIImageView = {
            let img = UIImageView()
            img.image = UIImage(named: "gradicon")
            img.contentMode = .scaleAspectFit
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let createdIcon: UIImageView = {
            let img = UIImageView()
            img.image = UIImage(named: "calendar")
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let createdLbl: UILabel = {
            let lbl = UILabel()
            lbl.textColor = dark
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 15)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let availableIcon: UIImageView = {
            let img = UIImageView()
            img.image = UIImage(named: "deposit")
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let availableLbl: UILabel = {
            let lbl = UILabel()
            lbl.textColor = dark
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 15)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let amountLbl: UILabel = {
            let lbl = UILabel()
            lbl.textColor = darker
            lbl.textAlignment = .left
            lbl.font = UIFont(name: "Avenir-Light", size: 25)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let statusLbl: UILabel = {
            let lbl = UILabel()
            lbl.textColor = dark
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 15)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let nameIcon: UIImageView = {
            let img = UIImageView()
            img.image = UIImage(named: "hint")
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let nameLbl: UILabel = {
            let lbl = UILabel()
            lbl.textColor = dark
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = offwhite
            layer.cornerRadius = 10
            clipsToBounds = true
            layer.shadowColor = UIColor.darkGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowRadius = 6
            layer.shadowOpacity = 0.3
            setup()
        }
        
        func setup() {
            
            addSubview(logo)
            addSubview(nameLbl)
            addSubview(createdIcon)
            addSubview(createdLbl)
            addSubview(availableIcon)
            addSubview(availableLbl)
            addSubview(statusLbl)
            addSubview(nameIcon)
            addSubview(amountLbl)
            
            logo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
            logo.widthAnchor.constraint(equalToConstant: 30).isActive = true
            logo.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            availableLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
            availableLbl.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 0).isActive = true
            
            availableIcon.rightAnchor.constraint(equalTo: availableLbl.leftAnchor, constant: -6).isActive = true
            availableIcon.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 0).isActive = true
            availableIcon.heightAnchor.constraint(equalToConstant: 22).isActive = true
            availableIcon.widthAnchor.constraint(equalToConstant: 22).isActive = true
            
            createdLbl.rightAnchor.constraint(equalTo: availableIcon.leftAnchor, constant: -12).isActive = true
            createdLbl.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 0).isActive = true
            
            createdIcon.rightAnchor.constraint(equalTo: createdLbl.leftAnchor, constant: -6).isActive = true
            createdIcon.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: -1).isActive = true
            createdIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
            createdIcon.widthAnchor.constraint(equalToConstant: 23).isActive = true
            
            amountLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5).isActive = true
            amountLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
            
            statusLbl.centerYAnchor.constraint(equalTo: amountLbl.centerYAnchor, constant: 0).isActive = true
            statusLbl.leftAnchor.constraint(equalTo: amountLbl.rightAnchor, constant: 10).isActive = true
            
            nameIcon.rightAnchor.constraint(equalTo: nameLbl.leftAnchor, constant: -10).isActive = true
            nameIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
            nameIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
            nameIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
            
            nameLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
            nameLbl.bottomAnchor.constraint(equalTo: nameIcon.bottomAnchor).isActive = true
            
        }
        
        func configure(model: Donation) {
            self.model = model
            self.createdLbl.text = model.created
            self.availableLbl.text = model.available
            self.amountLbl.text = model.amount
            self.statusLbl.text = model.status
            self.nameLbl.text = model.username
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
