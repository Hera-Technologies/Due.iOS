//
//  GuideVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class GuideVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    fileprivate let cellID = "cell"
    
    struct GuidePage {
        let imageName: String
        let label: String
        let message: String
    }
    
    let pages: [GuidePage] = {
        
        let msgOne = """
        Antes de começar a editar sua versão, escolham um nome para ela.
        """
        let first = GuidePage(imageName: "jigsaw", label: "Bem vindos ao Portal", message: msgOne)
        
        let msgTwo = """
        Uma vez completa, vocês poderão "ligar" a versão e torná-la acessível a outros usuários.
        """
        let second = GuidePage(imageName: "onoff", label: "Online / Offline", message: msgTwo)
        
        let msgThree = """
        Uma vez que a versão estiver online, compartilhem o app com seus convidados para que possam acessá-la!
        """
        let third = GuidePage(imageName: "login", label: "Lembrem-se", message: msgThree)
        
        let msgFour = """
        Os 3 meses começam a contar somente quando a versão ficar online. Após este prazo, a versão será deletada.
        """
        let fourth = GuidePage(imageName: "clock", label: "No seu tempo", message: msgFour)
        
        return [first, second, third, fourth]
    }()
    
    let skipBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Pular", for: UIControlState())
        btn.setTitleColor(.darkGray, for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
    
    let portalBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Começar", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 22)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.alpha = 0
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var control: UIPageControl = {
        let ctr = UIPageControl()
        ctr.pageIndicatorTintColor = linewhite
        ctr.currentPageIndicatorTintColor = .darkGray
        ctr.numberOfPages = self.pages.count
        ctr.translatesAutoresizingMaskIntoConstraints = false
        return ctr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    var controlBottomAnchor: NSLayoutConstraint?
    var skipRightAnchor: NSLayoutConstraint?
    
    func setup() {
        
        view.addSubview(collec)
        view.addSubview(control)
        view.addSubview(skipBtn)
        view.addSubview(portalBtn)
        
        skipRightAnchor = skipBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        skipRightAnchor?.isActive = true
        skipBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        skipBtn.addTarget(self, action: #selector(openPortal), for: .touchUpInside)
        
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        collec.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        collec.register(GuideCell.self, forCellWithReuseIdentifier: cellID)
        collec.delegate = self
        collec.dataSource = self
        
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        control.heightAnchor.constraint(equalToConstant: 30).isActive = true
        control.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        controlBottomAnchor = control.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        controlBottomAnchor?.isActive = true
        
        let position = view.frame.size.height * 0.38
        let hgt = view.frame.height * 0.075
        portalBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        portalBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: position).isActive = true
        portalBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        portalBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        portalBtn.layer.cornerRadius = hgt / 2
        portalBtn.addTarget(self, action: #selector(openPortal), for: .touchUpInside)
        
    }
    
    @objc func openPortal() {
        navigationController?.pushViewController(PortalVC(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GuideCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height * 1.1)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNum = Int(targetContentOffset.pointee.x / view.frame.width)
        control.currentPage = pageNum
        
        if pageNum == pages.count - 1 {
            controlBottomAnchor?.constant = 40
            skipRightAnchor?.constant = 50
            UIView.animate(withDuration: 0.5, animations: {
                self.portalBtn.alpha = 1
            })
        } else {
            controlBottomAnchor?.constant = -8
            skipRightAnchor?.constant = -20
            portalBtn.alpha = 0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    class GuideCell: UICollectionViewCell {
        
        var page: GuidePage? {
            didSet {
                guard let page = page else { return }
                icon.image = UIImage(named: page.imageName)
                label.text = page.label
                message.text = page.message
            }
        }
        
        lazy var gradient: CAGradientLayer = {
            let grad = CAGradientLayer()
            grad.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            return grad
        }()
        
        let icon: UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let label: UILabel = {
            let lbl = UILabel()
            lbl.textColor  = dark
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Black", size: 28)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let message: UILabel = {
            let lbl = UILabel()
            lbl.textColor  = .gray
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
            lbl.numberOfLines = 0
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.insertSublayer(gradient, at: 0)
            setup()
        }
        
        func setup() {
            
            addSubview(icon)
            addSubview(label)
            addSubview(message)
            
            let iconY = self.frame.size.height * 0.2
            icon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -iconY).isActive = true
            icon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.38).isActive = true
            icon.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.38).isActive = true
            
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
            
            message.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            message.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12).isActive = true
            message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}


