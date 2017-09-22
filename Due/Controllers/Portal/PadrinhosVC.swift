//
//  PadrinhosVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellID = "cell"

class PadrinhosVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var arr = [Padrinho]()
    
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
        lbl.text = "Padrinhos"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let collec: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.isPagingEnabled = true
        col.showsHorizontalScrollIndicator = false
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "jacket")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Homenageie seus padrinhos e madrinhas!
        
        *Deslize para os lados para vê-los.
        """
        lbl.textColor  = .lightGray
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPadrinhos()
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(addBtn)
        view.addSubview(collec)
        view.addSubview(hintImg)
        view.addSubview(hintMessage)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 4).isActive = true
        
        addBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: 3).isActive = true
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addBtn.addTarget(self, action: #selector(addPadrinho), for: .touchUpInside)
        
        let lineY = view.frame.height * 0.32
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lineY).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collec.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(PadrinhoCell.self, forCellWithReuseIdentifier: cellID)
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        
        hintMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintMessage.topAnchor.constraint(equalTo: hintImg.bottomAnchor, constant: 18).isActive = true
        hintMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
    @objc func goBack() {
        navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
    }
    
    @objc func addPadrinho() {
        let vc = AddPadrinhoVC(previousPhotoUrl: "", message: "", childID: "")
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PadrinhoCell
        cell.vc = self
        cell.delegate = self
        let padrinho = arr[indexPath.item]
        cell.configureCell(padrinho: padrinho)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collec.frame.width, height: collec.frame.height)
    }
    
    // MARK: FETCH DATA FROM FIREBASE
    
    func fetchPadrinhos() {
        Database.database().reference().child("Codes").child(details.eventID!).child("padrinhos").observe(.value, with: { (snap) in
            self.arr = []
            if let padrinhos = snap.children.allObjects as? [DataSnapshot] {
                for padrinho in padrinhos {
                    if let data = padrinho.value as? [String: AnyObject] {
                        let pad = Padrinho(postID: padrinho.key, postData: data)
                        self.arr.append(pad)
                    }
                }
            }
            DispatchQueue.main.async {
                self.collec.reloadData()
                self.hideHints()
            }
        })
    }
    
    func hideHints() {
        if arr.count > 0 {
            hintImg.isHidden = true
            hintMessage.isHidden = true
        } else {
            hintImg.isHidden = false
            hintMessage.isHidden = false
        }
    }
    
    // MARK: DELETE DATA FROM FIREBASE
    
    func deletePhotos(index: Int) {
        if let postID = arr[index].postID, let url = arr[index].photo {
            Database.database().reference().child("Codes").child(details.eventID!).child("padrinhos").child(postID).removeValue()
            Storage.storage().reference(forURL: url).delete(completion: { (err) in
                if err != nil {
                    print(err?.localizedDescription ?? "")
                }
            })
        }
    }
    
}

// MARK: CELL DELEGATE METHODS

extension PadrinhosVC: PadrinhoCellDelegate {
    func deletePad(cell: PadrinhoCell) {
        SweetAlert().showAlert("Atenção...", subTitle: "Tem certeza que quer deletar este padrinho?", style: AlertStyle.warning, buttonTitle: "Cancelar", buttonColor: UIColor.colorFromRGB(0xFF8989), otherButtonTitle: "Confirmar", otherButtonColor: UIColor.colorFromRGB(0x99B9f3)) { (isOtherButton) -> Void in
            if isOtherButton == false {
                if let indexPath = self.collec.indexPath(for: cell) {
                    self.deletePhotos(index: indexPath.item)
                    self.arr.remove(at: indexPath.item)
                    self.collec.deleteItems(at: [indexPath])
                    self.hideHints()
                }
            }
        }
    }
    
    func editPad(cell: PadrinhoCell) {
        if collec.indexPath(for: cell) != nil {
            let vc = AddPadrinhoVC(previousPhotoUrl: cell.photo.imageUrlString!, message: cell.field.text, childID: (cell.model?.postID)!)
            present(vc, animated: true, completion: nil)
        }
    }
}
