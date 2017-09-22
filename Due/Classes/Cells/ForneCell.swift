//
//  ForneCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

protocol ForneCellDelegate {
    func openFacebook(url: String)
    func openInstagram(url: String)
}

class ForneCell: UITableViewCell {
    
    var model: Forne!
    var vc: ForneVC?
    var otherVC: ForneListVC!
    var delegate: ForneCellDelegate?
    var facebookUrl: String?
    var instaUrl: String?
    
    let categoria: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Savoye LET", size: 30)
        lbl.textColor = .darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let fornecedor: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let faceBtn: UIButton = {
        let btn = UIButton()
        //        btn.setImage(UIImage(named: "face"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let instaBtn: UIButton = {
        let btn = UIButton()
        //        btn.setImage(UIImage(named: "insta"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        
        addSubview(categoria)
        addSubview(fornecedor)
        
        categoria.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        categoria.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        
        fornecedor.topAnchor.constraint(equalTo: categoria.bottomAnchor, constant: 8).isActive = true
        fornecedor.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        fornecedor.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        fornecedor.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
    }
    
    func tryFB() {
        if let url = facebookUrl {
            delegate?.openFacebook(url: url)
        }
    }
    
    func tryInsta() {
        if let url = instaUrl {
            delegate?.openInstagram(url: url)
        }
    }
    
    func configureCell(forne: Forne) {
        self.model = forne
        self.categoria.text = forne.categoria
        self.fornecedor.text = forne.fornecedor
        self.instaUrl = forne.instaUrl
        self.facebookUrl = forne.fbUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

