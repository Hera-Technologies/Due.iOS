//
//  FourthVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase 

fileprivate let cellID = "cell"

class FourthVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var arr = [Gift]()
    let indicator = UIActivityIndicatorView()
    
    let faqBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("FAQ", for: .normal)
        btn.setTitleColor(dark, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Presentes"
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
    
    let collec: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
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
        navigationController?.isNavigationBarHidden = true
    }
    
    func setup() {
        
        view.addSubview(faqBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(collec)
        
        faqBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true 
        faqBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        faqBtn.addTarget(self, action: #selector(faq), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.38
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(GiftCell.self, forCellWithReuseIdentifier: cellID)
        collec.contentInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
    }
    
    @objc func faq() {
        present(ChargeFAQ(), animated: true, completion: nil)
    }
    
    func fetchGifts() {
        showActivityIndicator(view: view, indicator: indicator)
        Database.database().reference().child("Gifts").observe(.value, with: { (snap) in
            self.arr = []
            if let gifts = snap.children.allObjects as? [DataSnapshot] {
                for gift in gifts {
                    if let data = gift.value as? [String: Any] {
                        let present = Gift(data: data)
                        self.arr.append(present)
                    }
                }
            }
            DispatchQueue.main.async {
                dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                    self.collec.reloadData()
                })
            }
        })
    }
    
// MARK: COLLECTIONVIEW DELEGATE AND DATA SOURCE

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collec.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GiftCell
        cell.vc = self
        cell.configureCell(model: arr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = view.frame.width * 0.42
        let h = view.frame.width * 0.4
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GiftCell
        if let image = cell.photo.image, let name = cell.giftLbl.text, let desc = cell.desc, let amount = cell.priceLbl.text {
            let vc = GiftDetailVC(image: image, name: name, desc: desc, amount: amount)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}




