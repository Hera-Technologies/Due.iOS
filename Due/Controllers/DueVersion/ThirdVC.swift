//
//  ThirdVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

fileprivate let cellID = "cell"

class ThirdVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: ELEMENTS
    
    struct CellConfig {
        var icon: UIImage
        var label: String
        var message: String
    }
    
    let arr: [CellConfig] = {
        let pht = CellConfig(icon: #imageLiteral(resourceName: "moments"), label: "Momentos", message: "A história do casamento em um só lugar. Acompanhe e faça parte, compartilhando seus momentos também!")
        let msg = CellConfig(icon: #imageLiteral(resourceName: "messages"), label: "Mensagens", message: "Leia mensagens enviadas aos noivos e não deixe de escrever a sua!")
        let inf = CellConfig(icon: #imageLiteral(resourceName: "event"), label: "Evento", message: "Fique por dentro dos detalhes do evento. Encontre informações aos convidados aqui.")
        return [pht, msg, inf]
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Casamento"
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
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.showsVerticalScrollIndicator = false
        col.translatesAutoresizingMaskIntoConstraints = false
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            layout.minimumLineSpacing = 40
        } else if size < 414 && size > 320 {
            layout.minimumLineSpacing = 35
        } else if size <= 320 {
            layout.minimumLineSpacing = 30
        }
        return col
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setup() {
        
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(collec)
        
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
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -49).isActive = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(EventCell.self, forCellWithReuseIdentifier: cellID)
        
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            collec.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: 12, right: 0)
        } else if size < 414 && size > 320 {
            collec.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 12, right: 0)
        } else if size <= 320 {
            collec.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 12, right: 0)
        }
        
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EventCell
        cell.cellConfig = arr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EventCell
        switch indexPath.item {
        case 0:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(PhotosVC(), animated: true)
            })
        case 1:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(MessagesVC(), animated: true)
            })
        default:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(EventVC(), animated: true)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height * 0.25)
    }
    
    func animateCell(cell: EventCell, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            cell.transform = CGAffineTransform.identity
        }) { (boo) in
            completion()
        }
    }
    
    // MARK: COLLECTION VIEW CELL
    
    class EventCell: UICollectionViewCell {
        
        var cellConfig: CellConfig? {
            didSet {
                guard let cellConfig = cellConfig else { return }
                icon.image = cellConfig.icon
                label.text = cellConfig.label
                message.text = cellConfig.message
            }
        }
        
        let icon: UIImageView = {
            let img = UIImageView()
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let label: UILabel = {
            let lbl = UILabel()
            lbl.textColor = dark
            lbl.font = UIFont(name: "Avenir-Heavy", size: 22)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let message: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .gray
            lbl.textAlignment = .justified
            lbl.font = UIFont(name: "Avenir-Roman", size: 18)
            lbl.numberOfLines = 0
            lbl.adjustsFontSizeToFitWidth = true
            lbl.minimumScaleFactor = 0.5
            return lbl
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .white
            layer.cornerRadius = 16
            layer.shadowColor = UIColor.darkGray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 6
            layer.shadowOpacity = 0.3
            
            addSubview(icon)
            addSubview(label)
            addSubview(message)
            
            let iconSize = self.frame.width * 0.22
            let anchor = iconSize / 3
            icon.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
            icon.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
            icon.topAnchor.constraint(equalTo: self.topAnchor, constant: -anchor).isActive = true
            icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
            
            label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            
            message.center = CGPoint(x: self.frame.width * 0.07, y: self.frame.height * 0.42)
            message.frame.size = CGSize(width: self.frame.width * 0.87, height: self.frame.height * 0.45)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
