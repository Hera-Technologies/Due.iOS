//
//  GiftsGuideVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

fileprivate let cellID = "cell"

class GiftsGuideVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let arr = [
        """
    Criamos este guia informativo a fim de trazer esclarecimentos aos noivos acerca do modo de funcionamento dos presentes virtuais no Due.

    Prezamos muito pela satisfação dos nossos usuários e, por isso, os tratamos com honestidade e transparência.
    """,
        
        """
    A Stripe, Inc é a empresa responsável pelo processamento das transações financeiras que ocorrem no Due. Por esta razão, faz-se necessário que os noivos criem uma conta Stripe, indicando a conta bancária para a qual os presentes deverão ser transferidos.
    
    Apesar de se tratar de uma empresa americana, todas as transações realizadas no Due se dão na moeda brasileira (BRL), não havendo qualquer imposto relativo à operações internacionais ou conversão com o dólar americano (USD).

    No momento, a Stripe aceita apenas cartões de crédito.
    """,
        
        """
    A tela anterior à esta se presta a apresentar uma lista dos presentes recebidos.

    O valor que se encontra no topo da tela refere-se à soma de todos os presentes que os noivos receberam até o momento.

    A Stripe é a responsável por depositar os valores na conta bancária do casal e, no Brasil, eles efetuam os depósitos 30 dias após a realização da transação financeira.

    Na tela anterior, é possível notar que cada presente possui os seguintes dados:

    - Valor do presente, já descontada a taxa Due de 2%.
    - Data em que a transação foi realizada (ao lado do calendário).
    - Data em que o valor será depositado na conta dos noivos (ao lado da seta).
    - Status. Caso o presente já tenha sido depositado na conta dos noivos, o status aparecerá como "pago". Caso contrário, "pendente".
    - Nome da pessoa que presenteou o casal.
    """,
        
        """
    O Due cobra uma taxa operacional de 2% sobre cada presente virtual.

    Em uma situação hipotética, se um convidado presenteia um casal com R$100,00 (cem reais), 2% deste valor, ou seja, R$2,00 serão retidos pelo Due à título desta taxa, e os R$98,00 (noventa e oito reais) restantes serão transferidos para a conta Stripe daquele casal.

    Após o período de 30 dias já mencionado, tal valor será depositado pela Stripe na conta bancária dos noivos.
    """
        
    ]
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Presentes Virtuais"
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(red: 47/255, green: 128/255, blue: 237/255, alpha: 1)
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let table: UITableView = {
        let tb = UITableView()
        tb.allowsSelection = false
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(viewTitle)
        view.addSubview(table)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        viewTitle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        table.topAnchor.constraint(equalTo: viewTitle.bottomAnchor).isActive = true
        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(GiftGuideCell.self, forCellReuseIdentifier: cellID)
        table.estimatedRowHeight = 44.0
        table.rowHeight = UITableViewAutomaticDimension
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Objetivo"
        case 1: return "Stripe"
        case 2: return "Presentes"
        default: return "Taxas"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! GiftGuideCell
        switch indexPath.section {
        case 0: cell.message.text = arr[0]
        case 1: cell.message.text = arr[1]
        case 2: cell.message.text = arr[2]
        default: cell.message.text = arr[3]
        }
        return cell
    }
    
    // MARK: TABLE VIEW CELL
    
    class GiftGuideCell: UITableViewCell {
        
        let message: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .gray
            lbl.font = UIFont(name: "Avenir-Roman", size: 16)
            lbl.textAlignment = .justified
            lbl.numberOfLines = 0
            lbl.lineBreakMode = .byWordWrapping
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: cellID)
            
            addSubview(message)
            message.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            message.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            message.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
            message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

