//
//  PhotosVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import Presentr

fileprivate let cellID = "photoCell"

class PhotosVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var photos = [Photo]()
    var ownerID = String()
    
    let zoomPhoto: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.dismissOnSwipe = false
        return customPresenter
    }()
    
    let indicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.activityIndicatorViewStyle = .gray
        ind.color = .blue
        ind.hidesWhenStopped = true
        return ind
    }()
    
    let alertContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(red: 55/255, green: 236/255, blue: 186/255, alpha: 0.8)
        vi.layer.cornerRadius = 8
        vi.alpha = 0
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let alertLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Foto salva"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let alertIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "ticksmall")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let back: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let share: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "addphoto"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Fotos"
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
    
    let table: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.showsVerticalScrollIndicator = false
        tb.separatorStyle = .none
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEventOwner()
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        fetchMessages()
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func fetchMessages() {
        indicator.startAnimating()
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("fotos").queryOrdered(byChild: "timestamp").observe(.value, with: { (snap) in
            self.photos = []
            if let fotos = snap.children.allObjects as? [DataSnapshot] {
                for foto in fotos {
                    if let data = foto.value as? [String: AnyObject] {
                        let fto = Photo(postID: foto.key, postData: data)
                        self.photos.append(fto)
                    }
                }
            }
            self.table.reloadData()
            self.indicator.stopAnimating()
        })
    }
    
    func fetchEventOwner() {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).observeSingleEvent(of: .value, with: { (snap) in
            guard let dict = snap.value as? [String: AnyObject] else { return }
            self.ownerID = dict["user"] as! String
        })
    }
    
    func setup() {
        
        view.addSubview(indicator)
        view.addSubview(back)
        view.addSubview(share)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(table)
        view.addSubview(alertContainer)
        
        indicator.center = view.center
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        share.centerYAnchor.constraint(equalTo: back.centerYAnchor, constant: 5).isActive = true
        share.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        share.heightAnchor.constraint(equalToConstant: 38).isActive = true
        share.widthAnchor.constraint(equalToConstant: 38).isActive = true
        share.addTarget(self, action: #selector(sharePhoto), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(PhotoCell.self, forCellReuseIdentifier: cellID)
        table.estimatedRowHeight = 300
        table.rowHeight = UITableViewAutomaticDimension
        table.tableFooterView = UIView()
        
        alertContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        alertContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        alertContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        alertContainer.addSubview(alertLbl)
        alertContainer.addSubview(alertIcon)
        alertLbl.centerXAnchor.constraint(equalTo: alertContainer.centerXAnchor).isActive = true
        alertLbl.centerYAnchor.constraint(equalTo: alertContainer.centerYAnchor).isActive = true
        alertIcon.centerYAnchor.constraint(equalTo: alertLbl.centerYAnchor).isActive = true
        alertIcon.leftAnchor.constraint(equalTo: alertLbl.rightAnchor, constant: 10).isActive = true
        
    }
    
    @objc func sharePhoto() {
        let vc = PhotoVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func savePhotoAlert() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertContainer.alpha = 1
        }) { (_) in
            let delay = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                UIView.animate(withDuration: 0.3, animations: { self.alertContainer.alpha = 0 })
            })
        }
    }
    
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PhotoCell
        cell.vc = self
        cell.delegate = self
        let photo = photos[indexPath.row]
        cell.configureCell(foto: photo)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        if editingStyle == .delete {
            if userID == ownerID {
                if let postID = photos[indexPath.row].postID, let url = photos[indexPath.row].imageUrl {
                    deletePhoto(id: postID, photoUrl: url)
                }
                photos.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } else {
                let alert = UIAlertController(title: "Acesso Restrito", message: "Somente os noivos têm acesso à esta área.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PhotoCell
        let zoom = PhotoZoomVC(image: cell.photo.image!)
        customPresentViewController(zoomPhoto, viewController: zoom, animated: true, completion: nil)
    }
    
    func deletePhoto(id: String, photoUrl: String) {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("fotos").child(id).removeValue()
        Storage.storage().reference(forURL: photoUrl).delete(completion: { (err) in
            if err != nil {
                print(err?.localizedDescription ?? "")
            }
        })
    }
    
    @objc func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Oops...", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        savePhotoAlert()
    }
    
}

extension PhotosVC: PhotoCellDelegate {
    func savePhoto(cell: PhotoCell) {
        guard let image = cell.photo.image else { return }
        guard let data = UIImagePNGRepresentation(image) else { return }
        guard let compressedImg = UIImage(data: data) else { return }
        UIImageWriteToSavedPhotosAlbum(compressedImg, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
}
