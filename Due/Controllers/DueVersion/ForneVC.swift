//
//  ForneVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/25/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellID = "cell"

class ForneVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arr = [Forne]()
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(.black, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Fornecedores"
        lbl.textColor = .black
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
        tb.separatorColor = linewhite
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchForne()
        view.backgroundColor = .white
        setup()
    }
    
    func fetchForne() {
        Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("fornecedores").observe(.value, with: { (snap) in
            self.arr = []
            if let fornecedores = snap.children.allObjects as? [DataSnapshot] {
                for fornecedor in fornecedores {
                    if let data = fornecedor.value as? [String: AnyObject] {
                        let forne = Forne(childID: fornecedor.key, postData: data)
                        self.arr.append(forne)
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                self.table.reloadData()
            })
        })
    }
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(table)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(ForneCell.self, forCellReuseIdentifier: cellID)
        table.estimatedRowHeight = 44
        table.rowHeight = UITableViewAutomaticDimension
        table.tableFooterView = UIView()
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ForneCell
        cell.vc = self
        cell.delegate = self
        let forn = arr[indexPath.row]
        cell.configureCell(forne: forn)
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: OPEN SOCIAL MIDIA

extension ForneVC: ForneCellDelegate {
    func openFacebook(url: String) {
        if let fbUrl = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(fbUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(fbUrl)
            }
        }
    }
    
    func openInstagram(url: String) {
        if let instaUrl = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(instaUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(instaUrl)
            }
        }
    }
    
}
