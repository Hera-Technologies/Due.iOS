//
//  ForneListVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/25/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellID = "cell"

class ForneListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arr = [Forne]()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(.black, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Fornecedores"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let previousBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Anterior", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-heavy", size: 18)
        btn.setTitleColor(.black, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(.black, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
        tb.allowsSelection = true
        tb.separatorColor = linewhite
        return tb
    }()
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "service")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Organize os fornecedores envolvidos na realização do seu evento!
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
        fetchForne()
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(previousBtn)
        view.addSubview(addBtn)
        view.addSubview(line)
        view.addSubview(table)
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
        
        addBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: 3).isActive = true
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addBtn.addTarget(self, action: #selector(addForne), for: .touchUpInside)
        
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
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        hintMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintMessage.topAnchor.constraint(equalTo: hintImg.bottomAnchor, constant: 18).isActive = true
        hintMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
    @objc func addForne() {
        let vc = EditForneVC(categoria: "", fornecedor: "", childID: "")
        present(vc, animated: true, completion: nil)
    }
    
    @objc func previousScreen() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack() {
        navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
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
                self.hideHints()
            })
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ForneCell
        cell.otherVC = self
        cell.selectionStyle = .none
        let forn = arr[indexPath.row]
        cell.configureCell(forne: forn)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ForneCell
        let child = cell.model.childID
        let category = cell.categoria.text
        let forne = cell.fornecedor.text
        let vc = EditForneVC(categoria: category!, fornecedor: forne!, childID: child!)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let childID = arr[indexPath.row].childID
            Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("fornecedores").child(childID!).removeValue()
            arr.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            hideHints()
        }
    }
    
}
