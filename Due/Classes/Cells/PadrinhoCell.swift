//
//  PadrinhoCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

protocol PadrinhoCellDelegate {
    func deletePad(cell: PadrinhoCell)
    func editPad(cell: PadrinhoCell)
}

class PadrinhoCell: UICollectionViewCell, UITextViewDelegate {
    
    var model: Padrinho?
    var vc: PadrinhosVC!
    var delegate: PadrinhoCellDelegate?
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "red"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = linewhite
        img.layer.cornerRadius = 14
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let field: UITextView = {
        let txt = UITextView()
        txt.textAlignment = .justified
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = darker
        txt.backgroundColor = .clear
        txt.isEditable = false
        return txt
    }()
    
    let updateBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Editar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(deleteBtn)
        addSubview(photo)
        addSubview(field)
        addSubview(updateBtn)
        
        field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        field.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
        field.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 12).isActive = true
        field.bottomAnchor.constraint(equalTo: updateBtn.topAnchor, constant: -20).isActive = true
        field.delegate = self
        
        photo.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 0).isActive = true
        photo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        photo.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        photo.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        
        deleteBtn.trailingAnchor.constraint(equalTo: field.trailingAnchor, constant: 0).isActive = true
        deleteBtn.topAnchor.constraint(equalTo: photo.topAnchor, constant: 0).isActive = true
        deleteBtn.addTarget(self, action: #selector(deletePadrinho), for: .touchUpInside)
        
        let btnHeight = self.frame.height * 0.09
        updateBtn.frame.size = CGSize(width: self.frame.width / 2, height: btnHeight)
        updateBtn.center.x = self.frame.width / 2
        updateBtn.frame.origin.y = self.frame.height * 0.85
        updateBtn.layer.cornerRadius = btnHeight / 2
        updateBtn.addTarget(self, action: #selector(updatePadrinho), for: .touchUpInside)
        
    }
    
    @objc func updatePadrinho() {
        delegate?.editPad(cell: self)
    }
    
    @objc func deletePadrinho() {
        delegate?.deletePad(cell: self)
    }
    
    func configureCell(padrinho: Padrinho) {
        self.model = padrinho
        if let image = padrinho.photo, let message = padrinho.message {
            self.photo.loadImageUsingCacheWithUrlString(image)
            self.field.text = message
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

