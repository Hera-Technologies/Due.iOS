//
//  PhotoAlbumVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellID = "cell"

class PhotoAlbumVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var photosArr: [AlbumPhoto] = []
    var editBtnTapped: Bool = false
    var isExpanded = false
    
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
        lbl.text = "Album"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let previousBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Anterior", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-heavy", size: 18)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let editBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Editar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-heavy", size: 18)
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
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "photos")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Pressione o botão "+" para adicionar fotos ao seu album
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
        layout.minimumLineSpacing = 15
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.showsVerticalScrollIndicator = false
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    // MARK: VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPhotos()
    }
    
    // MARK: UI VIEWS SETUP
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(previousBtn)
        view.addSubview(editBtn)
        view.addSubview(addBtn)
        view.addSubview(line)
        view.addSubview(collec)
        view.addSubview(hintImg)
        view.addSubview(hintMessage)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 4).isActive = true
        
        let lineY = view.frame.height * 0.32
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lineY).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        previousBtn.bottomAnchor.constraint(equalTo: line.topAnchor).isActive = true
        previousBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        previousBtn.addTarget(self, action: #selector(previousScreen), for: .touchUpInside)
        
        editBtn.bottomAnchor.constraint(equalTo: line.topAnchor).isActive = true
        editBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        editBtn.addTarget(self, action: #selector(editPhotos), for: .touchUpInside)
        
        addBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: 3).isActive = true
        addBtn.rightAnchor.constraint(equalTo: editBtn.leftAnchor, constant: -15).isActive = true
        addBtn.addTarget(self, action: #selector(addPhotos), for: .touchUpInside)
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        hintMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintMessage.topAnchor.constraint(equalTo: hintImg.bottomAnchor, constant: 18).isActive = true
        hintMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(AlbumPhotoCell.self, forCellWithReuseIdentifier: cellID)
        collec.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
    }
    
    // MARK: FETCHING, ADDING AND EDITING PHOTOS
    
    func disableEditBtn() {
        if photosArr.count == 0 {
            editBtnTapped = false
            addBtn.isEnabled = true
            hintImg.isHidden = false
            hintMessage.isHidden = false
        }
    }
    
    func fetchPhotos() {
        Database.database().reference().child("Codes").child(details.eventID!).child("slideshow").observe(.value, with: { (snap) in
            self.photosArr = []
            if let photos = snap.children.allObjects as? [DataSnapshot] {
                for photo in photos {
                    if let data = photo.value as? [String: AnyObject] {
                        let item = AlbumPhoto(postID: photo.key, postData: data)
                        self.photosArr.append(item)
                    }
                }
            }
            DispatchQueue.main.async {
                self.collec.reloadData()
                self.hideHints()
            }
        })
    }
    
    @objc func addPhotos() {
        let vc = AddPhotoVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func editPhotos() {
        if photosArr.count > 0 {
            editBtnTapped = !editBtnTapped
            addBtn.isEnabled = !editBtnTapped
            let indexPaths = collec.indexPathsForVisibleItems
            for index in indexPaths {
                if let cell = collec.cellForItem(at: index) as? AlbumPhotoCell {
                    cell.deleteBtn.isHidden = !editBtnTapped
                }
            }
        }
    }
    
    func deletePhotos(index: Int) {
        if let postID = photosArr[index].postID, let url = photosArr[index].imageUrl {
            Database.database().reference().child("Codes").child(details.eventID!).child("slideshow").child(postID).removeValue()
            Storage.storage().reference(forURL: url).delete(completion: { (err) in
                if err != nil {
                    print(err?.localizedDescription ?? "")
                }
            })
        }
    }
    
    func hideHints() {
        if photosArr.count > 0 {
            hintImg.isHidden = true
            hintMessage.isHidden = true
        } else {
            hintImg.isHidden = false
            hintMessage.isHidden = false
        }
    }
    
    // MARK: NAVIGATION METHODS
    
    @objc func previousScreen() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AlbumPhotoCell
        cell.vc = self
        cell.delegate = self
        let photo = photosArr[indexPath.item]
        cell.configureCell(foto: photo)
        cell.deleteBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat?
        if UIScreen.main.bounds.width <= 320 {
            width = collec.frame.width * 0.44
        } else {
            width = collec.frame.width * 0.45
        }
        return CGSize(width: width!, height: view.frame.height * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AlbumPhotoCell
        if isExpanded == false {
            cell.superview?.bringSubview(toFront: cell)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                cell.frame = collectionView.bounds
                cell.layer.cornerRadius = 0
                collectionView.isScrollEnabled = false
                self.view.layoutIfNeeded()
                self.isExpanded = !self.isExpanded
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                cell.layer.cornerRadius = 18
                collectionView.isScrollEnabled = true
                collectionView.reloadItems(at: [indexPath])
                self.view.layoutIfNeeded()
                self.isExpanded = !self.isExpanded
            }, completion: nil)
        }
    }
    
}

extension PhotoAlbumVC: AlbumPhotoCellDelegate {
    func deletePhoto(cell: AlbumPhotoCell) {
        if let indexPath = collec.indexPath(for: cell) {
            deletePhotos(index: indexPath.item)
            photosArr.remove(at: indexPath.item)
            collec.deleteItems(at: [indexPath])
            disableEditBtn()
            hideHints()
        }
    }
}
