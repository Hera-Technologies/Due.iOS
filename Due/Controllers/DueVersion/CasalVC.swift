//
//  CasalVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class CasalVC: UIViewController {
    
    // MARK: ELEMENTS
    
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
        lbl.text = "História dos noivos"
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
    
    let hubPhoto: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = offwhite
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hubName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "SnellRoundhand-Black", size: 20)
        lbl.textColor = darker
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let bridePhoto: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.backgroundColor = offwhite
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let brideName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "SnellRoundhand-Black", size: 20)
        lbl.textColor = darker
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let topLine: UIView = {
        let vi = UIView()
        vi.backgroundColor = linewhite
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let bottomLine: UIView = {
        let vi = UIView()
        vi.backgroundColor = linewhite
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let texto: UITextView = {
        let txt = UITextView()
        txt.textAlignment = .justified
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.backgroundColor = .clear
        txt.textColor = .gray
        txt.isEditable = false
        txt.isSelectable = false
        txt.isScrollEnabled = true
        txt.showsVerticalScrollIndicator = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    // MARK: VIEWDIDLOAD AND WILLAPPEAR
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 251/255, alpha: 1)
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    // MARK: SETUP
    
    func setup() {
        
        if let hubP = eventModel.hubPhoto, let hubN = eventModel.hubName {
            hubPhoto.loadImageUsingCacheWithUrlString(hubP)
            hubName.text = hubN
        }
        
        if let brideP = eventModel.bridePhoto, let brideN = eventModel.brideName {
            bridePhoto.loadImageUsingCacheWithUrlString(brideP)
            brideName.text = brideN
        }
        
        if let story = eventModel.story {
            texto.text = story
        }
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(hubPhoto)
        view.addSubview(hubName)
        view.addSubview(bridePhoto)
        view.addSubview(brideName)
        view.addSubview(topLine)
        view.addSubview(bottomLine)
        view.addSubview(texto)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        let photoSizeAndX = view.frame.width * 0.25
        hubPhoto.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        hubPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: photoSizeAndX).isActive = true
        hubPhoto.widthAnchor.constraint(equalToConstant: photoSizeAndX).isActive = true
        hubPhoto.heightAnchor.constraint(equalToConstant: photoSizeAndX).isActive = true
        hubPhoto.layer.cornerRadius = photoSizeAndX / 2
        
        hubName.topAnchor.constraint(equalTo: hubPhoto.bottomAnchor, constant: 3).isActive = true
        hubName.centerXAnchor.constraint(equalTo: hubPhoto.centerXAnchor).isActive = true
        
        bridePhoto.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        bridePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -photoSizeAndX).isActive = true
        bridePhoto.widthAnchor.constraint(equalToConstant: photoSizeAndX).isActive = true
        bridePhoto.heightAnchor.constraint(equalToConstant: photoSizeAndX).isActive = true
        bridePhoto.layer.cornerRadius = photoSizeAndX / 2
        
        brideName.topAnchor.constraint(equalTo: bridePhoto.bottomAnchor, constant: 3).isActive = true
        brideName.centerXAnchor.constraint(equalTo: bridePhoto.centerXAnchor).isActive = true
        
        topLine.topAnchor.constraint(equalTo: brideName.bottomAnchor, constant: 20).isActive = true
        topLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        topLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        texto.topAnchor.constraint(equalTo: topLine.topAnchor, constant: 5).isActive = true
        texto.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        texto.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: 0).isActive = true
        texto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bottomLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        bottomLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
