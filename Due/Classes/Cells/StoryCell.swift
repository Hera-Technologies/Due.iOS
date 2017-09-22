//
//  StoryCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class StoryCell: UICollectionViewCell {
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "História do casal"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let storyField: UITextView = {
        let txt = UITextView()
        txt.textAlignment = .justified
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.textColor = darker
        txt.layer.borderColor = linewhite.cgColor
        txt.layer.borderWidth = 0.8
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let updateBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Atualizar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.clipsToBounds = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titulo)
        addSubview(storyField)
        addSubview(updateBtn)
        
        titulo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titulo.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        
        storyField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        storyField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        storyField.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 20).isActive = true
        storyField.bottomAnchor.constraint(equalTo: updateBtn.topAnchor, constant: -15).isActive = true
        
        let height = self.frame.height * 0.1
        updateBtn.frame.size = CGSize(width: self.frame.width / 2, height: height)
        updateBtn.center.x = self.frame.width / 2
        updateBtn.frame.origin.y = self.frame.height * 0.8
        updateBtn.layer.cornerRadius = height / 2
        updateBtn.addTarget(self, action: #selector(updateStory), for: .touchUpInside)
    }
    
    @objc func updateStory() {
        if storyField.text != nil {
            Database.database().reference().child("Codes").child(details.eventID!).child("story").updateChildValues(["texto": storyField.text!])
            _ = SweetAlert().showAlert("Muito bem!", subTitle: "Versão atualizada", style: .success, buttonTitle: "Ok")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

