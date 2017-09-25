//
//  HomeVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import Presentr

fileprivate var cellID = "Cell"

class HomeVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: SPECIAL ELEMENTS
    
    var vieww = DiagonalView()
    let picker = UIImagePickerController()
    var selectedImage = UIImage()
    let indicatorView = LoadingView()
    
    let gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = bourbon
        return grad
    }()
    
    let access: Presentr = {
        let width = ModalSize.fluid(percentage: 0.8)
        let height = ModalSize.fluid(percentage: 0.5)
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 5
        customPresenter.blurBackground = true
        customPresenter.dropShadow = PresentrShadow(shadowColor: .lightGray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 2.5)
        return customPresenter
    }()
    
    // MARK: OTHER ELEMENTS
    
    let arr: [HomeCellConfig] = {
        let product = HomeCellConfig(icon: #imageLiteral(resourceName: "luz"), title: "Produto", message: "Adquira uma versão Due para o seu casamento")
        let access = HomeCellConfig(icon: #imageLiteral(resourceName: "chave"), title: "Acesso", message: "Clique aqui para acessar um evento")
        let portal = HomeCellConfig(icon: #imageLiteral(resourceName: "caneta"), title: "Portal", message: "Clique aqui para editar sua versão Due")
        return [product, access, portal]
    }()
    
    let logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "whiteicon")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let menu: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "more"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let profilePic: NetworkImageView = {
        let vi = NetworkImageView()
        vi.contentMode = .scaleAspectFill
        vi.backgroundColor = .white
        vi.layer.masksToBounds = true
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.image = UIImage(named: "hint")
        return vi
    }()
    
    let edit: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "camera"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let username: UILabel = {
        let lbl = UILabel()
        lbl.textColor = darker
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Black", size: 30)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    let useremail: UILabel = {
        let lbl = UILabel()
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    let collec: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.showsHorizontalScrollIndicator = false
        col.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    let copyRights: UILabel = {
        let lbl = UILabel()
        lbl.text = "2017 Hera Technologies"
        lbl.textColor  = dark
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteExpiredEvents()
        setup()
        view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDetails(completion: dismissLoading)
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        view.layer.insertSublayer(gradient, at: 0)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: DELETE EXPIRED EVENTS
    
    func deleteExpiredEvents() {
        let ref = Database.database().reference().child("Codes")
        ref.observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            guard let dict = snapshot.value as? [String: Any] else { return }
            if let exp = dict["dateEnd"] as? String {
                let currentDate = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let expDate = formatter.date(from: exp)
                switch currentDate.compare(expDate!) {
                case .orderedDescending:
                    if let user = dict["user"] as? String {
                        self.deleteEventFromUserNode(user: user)
                    }
                    ref.child(id).removeValue()
                default:
                    break
                }
            }
        })
    }
    
    func deleteEventFromUserNode(user: String) {
        let ref = Database.database().reference().child("Users").child(user)
        ref.child("eventName").removeValue()
        ref.child("hasDue").removeValue()
        ref.child("nameSet").removeValue()
        
        let user = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("Users").child(user!)
        userRef.observe(.value, with: { (snap) in
            guard let dict = snap.value as? [String : AnyObject] else { return }
            if let hasDue = dict["hasDue"] as? Bool {
                details.hasDue = hasDue
            }
        })
    }
    
    // MARK: FETCH USER DETAILS
    
    func fetchDetails(completion: @escaping () -> Void) {
        showActivityIndicator(uiView: self.view)
        if let user = Auth.auth().currentUser?.uid {
            Database.database().reference().child("Users").child(user).observe(.value, with: { (snap) in
                guard let data = snap.value as? [String: AnyObject] else { return }
                if let photo = data["photo"] as? String {
                    self.profilePic.loadImageUsingCacheWithUrlString(photo)
                    details.profilePhoto = photo
                }
                let name = data["name"] as? String
                let email = data["email"] as? String
                details.name = name
                details.email = email
                self.username.text = name
                self.useremail.text = email
                let hasDue = data["hasDue"] as? Bool
                let nameSet = data["nameSet"] as? Bool
                let eventID = data["eventID"] as? String
                let eventName = data["eventName"] as? String
                details.hasDue = hasDue
                details.nameSet = nameSet
                details.eventID = eventID
                details.eventName = eventName
                self.fetchDates()
                completion()
            })
        }
    }
    
    func fetchDates() {
        if let firstEvent = details.eventID {
            Database.database().reference().child("Codes").child(firstEvent).observeSingleEvent(of: .value, with: { (snap) in
                guard let dict = snap.value as? [String: AnyObject] else { return }
                let start = dict["dateStart"] as? String
                let end = dict["dateEnd"] as? String
                details.dateStart = start
                details.dateEnd = end
            })
        }
    }
    
    // MARK: EDIT PROFILE PICTURE
    
    @objc func editProfilePic() {
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImage = editedImage as! UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImage = originalImage as! UIImage
        }
        if let theImage = selectedImage as UIImage? {
            profilePic.image = theImage
            updatePhoto(image: theImage, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func updatePhoto(image: UIImage, completion: @escaping () -> Void) {
        if let user = Auth.auth().currentUser?.uid {
            if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
                Storage.storage().reference().child("ProfilePhotos").child(user).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        if let currentUser = Auth.auth().currentUser?.uid {
                            let ref = Database.database().reference().child("Users").child(currentUser)
                            let value = ["photo": imageUrl]
                            ref.updateChildValues(value)
                            completion()
                        }
                    }
                })
            }
        }
    }
    
    // MARK: UI SETUP
    
    func setup() {
        
        view.addSubview(vieww)
        view.addSubview(menu)
        view.addSubview(logo)
        view.addSubview(profilePic)
        view.addSubview(edit)
        view.addSubview(username)
        view.addSubview(useremail)
        view.addSubview(collec)
        view.addSubview(copyRights)
        
        vieww.translatesAutoresizingMaskIntoConstraints = false
        vieww.backgroundColor = .clear
        vieww.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vieww.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        vieww.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        vieww.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        menu.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        menu.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        menu.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: menu.centerYAnchor).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        username.frame = CGRect(x: 15, y: view.frame.height * 0.2, width: view.frame.width * 0.55, height: 40)
        
        useremail.frame = CGRect(x: 20, y: view.frame.height * 0.26, width: view.frame.width * 0.54, height: 20)
        
        let photoY = view.frame.size.height * 0.19
        let size = view.frame.size.width * 0.3
        profilePic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        profilePic.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -photoY).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: size).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: size).isActive = true
        profilePic.layer.cornerRadius = size / 2
        
        edit.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: -20).isActive = true
        edit.leftAnchor.constraint(equalTo: profilePic.rightAnchor, constant: -25).isActive = true
        edit.heightAnchor.constraint(equalToConstant: 35).isActive = true
        edit.widthAnchor.constraint(equalToConstant: 35).isActive = true
        edit.addTarget(self, action: #selector(editProfilePic), for: .touchUpInside)
        
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        collec.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.47).isActive = true
        collec.bottomAnchor.constraint(equalTo: copyRights.topAnchor, constant: -5).isActive = true
        collec.register(HomeScreenCell.self, forCellWithReuseIdentifier: cellID)
        collec.delegate = self
        collec.dataSource = self
        
        copyRights.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyRights.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        
    }
    
    @objc func openMenu() {
        navigationController?.pushViewController(SettingsVC(), animated: true)
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeScreenCell
        cell.cellConfig = arr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.size.height * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HomeScreenCell
        switch indexPath.row {
        case 0:
            animateCell(cell: cell, completion: {
                self.comprar()
            })
        case 1:
            animateCell(cell: cell, completion: {
                self.acessarEvento()
            })
        default:
            animateCell(cell: cell, completion: {
                self.openPortal()
            })
        }
    }
    
    // MARK: COLLECTION VIEW CELL FUNCTIONS
    
    func animateCell(cell: HomeScreenCell, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            cell.transform = CGAffineTransform.identity
        }) { (boo) in
            completion()
        }
    }
    
    func acessarEvento() {
        let code = AccessVC()
        customPresentViewController(access, viewController: code, animated: true, completion: nil)
    }
    
    func comprar() {
        if details.hasDue == true {
            let alert = UIAlertController(title: "Oops...", message: "Você já possui uma versão Due", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            let contato = SaleVC()
            navigationController?.pushViewController(contato, animated: true)
        }
    }
    
    func openPortal() {
        if details.hasDue == true {
            navigationController?.pushViewController(GuideVC(), animated: true)
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Parece que você não possui uma versão Due. Gostaria de obter uma?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Sim", style: .default, handler: { (action) in
                let contato = SaleVC()
                self.navigationController?.pushViewController(contato, animated: true)
            })
            let no = UIAlertAction(title: "Não", style: .default, handler: nil)
            alert.addAction(no)
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: LOADING VIEW
    
    func showActivityIndicator(uiView: UIView) {
        indicatorView.tag = 5
        indicatorView.frame = uiView.frame
        indicatorView.center = uiView.center
        uiView.addSubview(indicatorView)
    }
    
    func dismissLoading() {
        if let taggedView = self.view.viewWithTag(5) {
            UIView.animate(withDuration: 0.3, animations: {
                taggedView.alpha = 0
            })
        }
    }
    
}

