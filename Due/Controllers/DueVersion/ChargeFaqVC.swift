//
//  ChargeFaqVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

fileprivate let identifier = "Cell"

class ChargeFAQ: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arr = [[String: String]]()
    
    let back: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dúvidas frequentes"
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
        return tb
    }()
    
    let image: UIImageView = {
        let card = UIImageView()
        card.image = UIImage(named: "card")
        card.translatesAutoresizingMaskIntoConstraints = false
        card.contentMode = .scaleAspectFill
        return card
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupText()
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! StripeFAQCell
        let questions = arr.map{$0["question"]}
        let answers = arr.map{$0["answer"]}
        cell.titulo.text = questions[indexPath.row]
        cell.texto.text = answers[indexPath.row]
        return cell
    }
    
    func setup() {
        
        view.addSubview(back)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(image)
        view.addSubview(table)
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 25).isActive = true
        image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        image.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        
        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        table.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(StripeFAQCell.self, forCellReuseIdentifier: identifier)
        table.estimatedRowHeight = 44.0
        table.rowHeight = UITableViewAutomaticDimension
        table.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        table.allowsSelection = false
        table.separatorStyle = .none
        
    }
    
    func setupText() {
        
        let dic1 = ["question": "Processamento de transações", "answer": "O serviço de processamento de pagamentos é fornecido por uma empresa chamada Stripe, Inc, atuante em diversos países e já bem posicionada no mercado."]
        
        let dic2 = ["question": "Formas de pagamento", "answer": "No momento, as transações somente podem ser efetuadas por meio de cartão de crédito e à vista."]
        
        let dic3 = ["question": "Armazenamento de dados", "answer": "Após efetuar qualquer transação em nosso app, os dados do seu cartão são descartados."]
        
        let dic4 = ["question": "Proteção de dados", "answer": "Nós utilizamos SSL (Secure Sockets Layer) e criptografia para proteger os seus dados."]
        
        arr = [dic1, dic2, dic3, dic4]
        
    }
    
    class StripeFAQCell: UITableViewCell {
        
        let titulo: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.textColor = .black
            lbl.font = UIFont(name: "Avenir-Heavy", size: 17)
            lbl.lineBreakMode = .byWordWrapping
            lbl.numberOfLines = 2
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let texto: UITextView = {
            let txt = UITextView()
            txt.textColor = .darkGray
            txt.backgroundColor = .clear
            txt.font = UIFont(name: "Avenir-Roman", size: 15)
            txt.textAlignment = .justified
            txt.isEditable = false
            txt.isSelectable = false
            txt.isScrollEnabled = false
            txt.translatesAutoresizingMaskIntoConstraints = false
            return txt
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: "Cell")
            
            self.backgroundColor = .white
            addSubview(titulo)
            addSubview(texto)
            titulo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            titulo.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
            titulo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
            texto.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 2).isActive = true
            texto.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
            texto.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
            texto.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
