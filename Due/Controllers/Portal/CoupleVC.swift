//
//  CoupleVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let coupleID = "couple"
fileprivate let storyID = "story"

class CoupleVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var storyText: String?
    var brideName: String?
    var bridePhoto: String?
    var groomName: String?
    var groomPhoto: String?
    
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
        lbl.text = "Noivos"
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
    
    let nextBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Próxima", for: UIControlState())
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
    
    let control: UIPageControl = {
        let ctr = UIPageControl()
        ctr.pageIndicatorTintColor = linewhite
        ctr.currentPageIndicatorTintColor = .gray
        ctr.numberOfPages = 2
        ctr.translatesAutoresizingMaskIntoConstraints = false
        return ctr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCouple()
        fetchStory()
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(previousBtn)
        view.addSubview(nextBtn)
        view.addSubview(line)
        view.addSubview(collec)
        view.addSubview(control)
        
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
        
        nextBtn.bottomAnchor.constraint(equalTo: line.topAnchor).isActive = true
        nextBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nextBtn.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        collec.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(CoupleCell.self, forCellWithReuseIdentifier: coupleID)
        collec.register(StoryCell.self, forCellWithReuseIdentifier: storyID)
        
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        control.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        control.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    @objc func previousScreen() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func nextScreen() {
        navigationController?.pushViewController(PhotoAlbumVC(), animated: true)
    }
    
    @objc func goBack() {
        navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: FETCH DATA FROM FIREBASE
    
    func fetchStory() {
        Database.database().reference().child("Codes").child(details.eventID!).child("story").observe(.value, with: { (snap) in
            guard let data = snap.value as? [String: AnyObject] else { return }
            let story = data["texto"] as? String
            self.storyText = story
            DispatchQueue.main.async {
                self.collec.reloadData()
            }
        })
    }
    
    func fetchCouple() {
        let ref = Database.database().reference().child("Codes").child(details.eventID!).child("story")
        ref.child("noiva").observeSingleEvent(of: .value, with: { (snap) in
            if let data = snap.value as? [String: AnyObject] {
                let name = data["nome"] as? String
                let photo = data["foto"] as? String
                self.brideName = name
                self.bridePhoto = photo
            }
            DispatchQueue.main.async {
                self.collec.reloadData()
            }
        })
        ref.child("noivo").observeSingleEvent(of: .value, with: { (snap) in
            if let data = snap.value as? [String: AnyObject] {
                let name = data["nome"] as? String
                let photo = data["foto"] as? String
                self.groomName = name
                self.groomPhoto = photo
            }
            DispatchQueue.main.async {
                self.collec.reloadData()
            }
        })
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        switch indexPath.section {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: coupleID, for: indexPath) as! CoupleCell
            (cell as! CoupleCell).delegate = self
            (cell as! CoupleCell).vc = self
            if let bridePhoto = bridePhoto, let brideName = brideName {
                (cell as! CoupleCell).fetchBrideData(bridePhoto: bridePhoto, brideName: brideName)
            }
            if let groomPhoto = groomPhoto, let groomName = groomName {
                (cell as! CoupleCell).fetchGroomData(groomPhoto: groomPhoto, groomName: groomName)
            }
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: storyID, for: indexPath) as! StoryCell
            (cell as! StoryCell).storyField.text = storyText
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collec.frame.width, height: collec.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNum = Int(targetContentOffset.pointee.x / view.frame.width)
        control.currentPage = pageNum
    }
    
}

extension CoupleVC: CoupleCellDelegate {
    func editCouple(cell: CoupleCell, child: String, name: String, photoUrl: String) {
        if collec.indexPath(for: cell) != nil {
            let vc = EditCoupleVC(child: child, photo: photoUrl, name: name)
            present(vc, animated: true, completion: nil)
        }
    }
}
