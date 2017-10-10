//
//  CoupleCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

protocol CoupleCellDelegate {
    func editCouple(cell: CoupleCell, child: String, name: String, photoUrl: String)
}

class CoupleCell: UICollectionViewCell {
    
    var delegate: CoupleCellDelegate?
    var vc: CoupleVC!
    
    let gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = bourbon
        return grad
    }()
    
    // MARK: NOIVA
    
    let brideContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let noivaTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Noiva"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let noivaEditBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let noivaTxt: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Nome da noiva"
        txt.textColor = .gray
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.isUserInteractionEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let noivaPic: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = offwhite
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: NOIVO
    
    let groomContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let noivoTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Noivo"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let noivoEditBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let noivoTxt: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Nome do noivo"
        txt.textColor = .gray
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.isUserInteractionEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let noivoPic: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = offwhite
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    func setup() {
        
        addSubview(brideContainer)
        addSubview(groomContainer)
        addSubview(noivaTitle)
        addSubview(noivaEditBtn)
        addSubview(noivaTxt)
        addSubview(noivaPic)
        addSubview(noivoTitle)
        addSubview(noivoEditBtn)
        addSubview(noivoTxt)
        addSubview(noivoPic)
        
        brideContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        brideContainer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        brideContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        brideContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        
        noivaTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        noivaTitle.bottomAnchor.constraint(equalTo: noivaTxt.topAnchor, constant: -8).isActive = true
        
        noivaEditBtn.leftAnchor.constraint(equalTo: noivaTitle.rightAnchor, constant: 10).isActive = true
        noivaEditBtn.centerYAnchor.constraint(equalTo: noivaTitle.centerYAnchor).isActive = true
        noivaEditBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        noivaEditBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        noivaEditBtn.addTarget(self, action: #selector(editBride), for: .touchUpInside)
        
        noivaTxt.centerYAnchor.constraint(equalTo: brideContainer.centerYAnchor, constant: 0).isActive = true
        noivaTxt.leadingAnchor.constraint(equalTo: noivaTitle.leadingAnchor, constant: 8).isActive = true
        
        let size = frame.width * 0.3
        noivaPic.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        noivaPic.centerYAnchor.constraint(equalTo: brideContainer.centerYAnchor, constant: 0).isActive = true
        noivaPic.widthAnchor.constraint(equalToConstant: size).isActive = true
        noivaPic.heightAnchor.constraint(equalToConstant: size).isActive = true
        noivaPic.layer.cornerRadius = size / 2
        
        groomContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        groomContainer.topAnchor.constraint(equalTo: brideContainer.bottomAnchor).isActive = true
        groomContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        groomContainer.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        
        noivoTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        noivoTitle.bottomAnchor.constraint(equalTo: noivoTxt.topAnchor, constant: -8).isActive = true
        
        noivoEditBtn.leftAnchor.constraint(equalTo: noivoTitle.rightAnchor, constant: 10).isActive = true
        noivoEditBtn.centerYAnchor.constraint(equalTo: noivoTitle.centerYAnchor).isActive = true
        noivoEditBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        noivoEditBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        noivoEditBtn.addTarget(self, action: #selector(editGroom), for: .touchUpInside)
        
        noivoTxt.centerYAnchor.constraint(equalTo: groomContainer.centerYAnchor).isActive = true
        noivoTxt.leadingAnchor.constraint(equalTo: noivoTitle.leadingAnchor, constant: 8).isActive = true
        
        noivoPic.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        noivoPic.centerYAnchor.constraint(equalTo: groomContainer.centerYAnchor, constant: 0).isActive = true
        noivoPic.widthAnchor.constraint(equalToConstant: size).isActive = true
        noivoPic.heightAnchor.constraint(equalToConstant: size).isActive = true
        noivoPic.layer.cornerRadius = size / 2
        
    }
    
    func fetchGroomData(groomPhoto: String, groomName: String) {
        noivoPic.loadImageUsingCacheWithUrlString(groomPhoto)
        noivoTxt.text = groomName
    }
    
    func fetchBrideData(bridePhoto: String, brideName: String) {
        noivaPic.loadImageUsingCacheWithUrlString(bridePhoto)
        noivaTxt.text = brideName
    }
    
    @objc func editBride() {
        if noivaTxt.text != "" && noivaPic.image != nil {
            delegate?.editCouple(cell: self, child: "Noiva", name: noivaTxt.text!, photoUrl: noivaPic.imageUrlString!)
        } else {
            delegate?.editCouple(cell: self, child: "Noiva", name: "", photoUrl: "")
        }
    }
    
    @objc func editGroom() {
        if noivoTxt.text != "" && noivoPic.image != nil {
            delegate?.editCouple(cell: self, child: "Noivo", name: noivoTxt.text!, photoUrl: noivoPic.imageUrlString!)
        } else {
            delegate?.editCouple(cell: self, child: "Noivo", name: "", photoUrl: "")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

