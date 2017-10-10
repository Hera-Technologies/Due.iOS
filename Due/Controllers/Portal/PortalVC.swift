//
//  PortalVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import Presentr

var nomeDoEvento: String?
fileprivate let cellID = "cell"

class PortalVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
// MARK: ALERTS
    
    let nameAlert: Presentr = {
        let width = ModalSize.fluid(percentage: 0.8)
        let height = ModalSize.fluid(percentage: 0.55)
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .crossDissolve
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 5
        customPresenter.backgroundColor = .lightGray
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dropShadow = PresentrShadow(shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 2.5)
        customPresenter.dismissOnTap = false
        customPresenter.dismissOnSwipe = false
        return customPresenter
    }()
    
    let nameChangeAlert: Presentr = {
        let pre = Presentr(presentationType: .topHalf)
        pre.backgroundColor = .lightGray
        pre.backgroundOpacity = 0.4
        pre.dropShadow = PresentrShadow(shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 2.5)
        return pre
    }()
    
    let renewAlert: Presentr = {
        let pre = Presentr(presentationType: .popup)
        pre.backgroundColor = .lightGray
        pre.backgroundOpacity = 0.4
        pre.dropShadow = PresentrShadow(shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 2.5)
        return pre
    }()
    
// MARK: ELEMENTS
    
    var progresso: [Float] = [0.0, 0.0, 0.0, 0.0]
    var aux: Bool = true
    
    let screens: [PortalButton] = {
        let main = PortalButton(titulo: "Tela Inicial", icon: "video", items: "7 itens")
        let padrinhos = PortalButton(titulo: "Padrinhos", icon: "padrinhos", items: "1 item")
        let evento = PortalButton(titulo: "Evento", icon: "map", items: "4 itens")
        let presentes = PortalButton(titulo: "Presentes", icon: "giftbox", items: "1 item")
        return [main, padrinhos, evento, presentes]
    }()
    
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
        lbl.text = "Portal"
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Black", size: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lineOne: UIView = {
        let ln = UIView()
        ln.backgroundColor = UIColor(red: 55/255, green: 236/255, blue: 186/255, alpha: 1)
        ln.layer.cornerRadius = 1
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let eventLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Evento"
        lbl.textColor  = .lightGray
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let eventNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        lbl.alpha = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let editBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 0
        return btn
    }()
    
    let lineTwo: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let powerIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "offline")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let statusLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Versão offline"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let messageLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Complete sua versão para deixá-la online."
        lbl.textColor = .gray
        lbl.textAlignment = .justified
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let container: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.layer.shadowColor = UIColor.gray.cgColor
        vi.layer.shadowOffset = CGSize(width: 0, height: 3)
        vi.layer.shadowRadius = 6
        vi.layer.shadowOpacity = 0.3
        vi.layer.cornerRadius = 15
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = dark
        lbl.text = "Início - Fim"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let switchBtn: SwitchBtn = {
        let sw = SwitchBtn()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    let renewBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "renew"), for: .normal)
        btn.isHidden = true
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let seeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "eye"), for: UIControlState())
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let guideBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "guide"), for: UIControlState())
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let collec: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.backgroundColor = .clear
        col.showsVerticalScrollIndicator = false
        col.translatesAutoresizingMaskIntoConstraints = false
        return col
    }()
    
    // MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        setup()
        
        if details.nameSet == false {
            let code = EventNameVC()
            customPresentViewController(nameAlert, viewController: code, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayDates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEventName(notification:)), name: NSNotification.Name(rawValue: "displayEventName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateExpDate(notification:)), name: NSNotification.Name(rawValue: "versionRenewed"), object: nil)
        let user = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(user!).observeSingleEvent(of: .value, with: { (snap) in
            guard let dict = snap.value as? [String : AnyObject] else { return }
            if let event = dict["eventName"] as? String {
                if event != "" {
                    self.animateContainer(eventName: event)
                }
            }
        })
    }
    
    // MARK: UI VIEWS SETUP
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(seeBtn)
        view.addSubview(viewTitle)
        view.addSubview(lineOne)
        view.addSubview(eventLbl)
        view.addSubview(eventNameLbl)
        view.addSubview(editBtn)
        view.addSubview(lineTwo)
        view.addSubview(powerIcon)
        view.addSubview(statusLbl)
        view.addSubview(messageLbl)
        view.addSubview(container)
        view.addSubview(timeLbl)
        view.addSubview(switchBtn)
        view.addSubview(renewBtn)
        view.addSubview(shareBtn)
        view.addSubview(guideBtn)
        view.addSubview(collec)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(backHome), for: .touchUpInside)
        
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: -3).isActive = true
        
        lineOne.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        lineOne.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 30).isActive = true
        lineOne.widthAnchor.constraint(equalToConstant: 20).isActive = true
        lineOne.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        eventLbl.leftAnchor.constraint(equalTo: lineOne.rightAnchor, constant: 6).isActive = true
        eventLbl.centerYAnchor.constraint(equalTo: lineOne.centerYAnchor).isActive = true
    
        eventNameLbl.topAnchor.constraint(equalTo: eventLbl.bottomAnchor, constant: 8).isActive = true
        eventNameLbl.leadingAnchor.constraint(equalTo: lineOne.centerXAnchor, constant: 0).isActive = true
        
        editBtn.centerYAnchor.constraint(equalTo: eventNameLbl.centerYAnchor).isActive = true
        editBtn.leftAnchor.constraint(equalTo: eventNameLbl.rightAnchor, constant: 10).isActive = true
        editBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        editBtn.addTarget(self, action: #selector(editEventName), for: .touchUpInside)
        
        lineTwo.leadingAnchor.constraint(equalTo: eventNameLbl.centerXAnchor, constant: 0).isActive = true
        lineTwo.topAnchor.constraint(equalTo: eventNameLbl.bottomAnchor, constant: 8).isActive = true
        lineTwo.trailingAnchor.constraint(equalTo: editBtn.trailingAnchor, constant: 0).isActive = true
        lineTwo.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        powerIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        powerIcon.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 25).isActive = true
        powerIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        powerIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        
        statusLbl.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 18).isActive = true
        statusLbl.leftAnchor.constraint(equalTo: powerIcon.rightAnchor, constant: 12).isActive = true
        
        messageLbl.topAnchor.constraint(equalTo: statusLbl.bottomAnchor, constant: 4).isActive = true
        messageLbl.leadingAnchor.constraint(equalTo: statusLbl.leadingAnchor).isActive = true
        messageLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: powerIcon.bottomAnchor, constant: 25).isActive = true
        container.heightAnchor.constraint(equalToConstant: 75).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92).isActive = true
        
        timeLbl.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 15).isActive = true
        timeLbl.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        switchBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        switchBtn.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -15).isActive = true
        switchBtn.heightAnchor.constraint(equalToConstant: 31).isActive = true
        switchBtn.widthAnchor.constraint(equalToConstant: 51).isActive = true
        switchBtn.layer.cornerRadius = 15.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkVersionCompletion))
        switchBtn.addGestureRecognizer(tap)
        
        renewBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        renewBtn.leftAnchor.constraint(equalTo: timeLbl.rightAnchor, constant: 10).isActive = true
        renewBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        renewBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        renewBtn.addTarget(self, action: #selector(renewVersion), for: .touchUpInside)
        
        shareBtn.leadingAnchor.constraint(equalTo: timeLbl.leadingAnchor).isActive = true
        shareBtn.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 15).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shareBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        seeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        seeBtn.centerYAnchor.constraint(equalTo: shareBtn.centerYAnchor).isActive = true
        seeBtn.heightAnchor.constraint(equalToConstant: 32).isActive = true
        seeBtn.widthAnchor.constraint(equalToConstant: 33).isActive = true
        seeBtn.addTarget(self, action: #selector(seeEvent), for: .touchUpInside)
        
        guideBtn.trailingAnchor.constraint(equalTo: switchBtn.trailingAnchor, constant: 0).isActive = true
        guideBtn.centerYAnchor.constraint(equalTo: shareBtn.centerYAnchor).isActive = true
        guideBtn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        guideBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        guideBtn.addTarget(self, action: #selector(showGuide), for: .touchUpInside)
        
        collec.topAnchor.constraint(equalTo: seeBtn.bottomAnchor, constant: 0).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collec.delegate = self
        collec.dataSource = self
        collec.register(PortalCell.self, forCellWithReuseIdentifier: cellID)
        
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            timeLbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        }
        
    }
    
    @objc func share() {
        if let name = eventNameLbl.text {
            let message = """
            Baixe o Due para ver a versão do nosso casamento! O código de acesso é \(name)
            
            https://play.google.com/store/apps/details?id=com.herasoft.due
            
            https://itunes.apple.com/br/app/due/id1221772362?l=en&mt=8
            """
            let actionSheet = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            actionSheet.popoverPresentationController?.sourceView = self.view
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @objc func renewVersion() {
        nomeDoEvento = eventNameLbl.text
        let vc = RenewVC()
        customPresentViewController(renewAlert, viewController: vc, animated: true, completion: nil)
    }
    
    @objc func showGuide() {
        self.navigationController?.pushViewController(GuideVC(), animated: true)
    }
    
    // MARK: FETCH EVENT
    
    @objc func updateEventName(notification: NSNotification) {
        if let newName = newEventName {
            animateContainer(eventName: newName)
            Database.database().reference().child("Codes").child(details.eventID!).child("eventName").setValue(newName)
        }
    }
    
    func animateContainer(eventName: String) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.eventNameLbl.text = eventName
            self.eventNameLbl.alpha = 1
            self.editBtn.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func seeEvent() {
        let firstEvent = details.eventID
        eventModel.eventCode = firstEvent
        let vc = LoadingVC()
        present(vc, animated: true, completion: nil)
    }
    
// MARK: EDIT EVENT NAME
    
    @objc func editEventName() {
        nomeDoEvento = eventNameLbl.text
        let nameChange = NameChangeVC()
        customPresentViewController(nameChangeAlert, viewController: nameChange, animated: true, completion: nil)
    }
    
    @objc func backHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
// MARK: INITIATE DUE VERSION
    
    @objc func checkVersionCompletion() {
        if aux == false {
            _ = SweetAlert().showAlert("Oops...", subTitle: "Você precisa completar sua versão para poder iniciá-la", style: .error)
        } else {
            confirmInit()
        }
    }
    
    func confirmInit() {
        SweetAlert().showAlert("Iniciar versão?", subTitle: "Sua versão se tornará acessível para outros usuários, dando início ao prazo de 3 meses. Esta ação não pode ser desfeita.", style: AlertStyle.warning, buttonTitle: "Cancelar", buttonColor: UIColor.colorFromRGB(0xFF8989), otherButtonTitle:  "Confirmar", otherButtonColor: UIColor.colorFromRGB(0x99B9f3)) { (isOtherButton) -> Void in
            if !isOtherButton {
                self.initVersion()
                _ = SweetAlert().showAlert("Versão online!", subTitle: "Sua versão agora está online! Compartilhe o app com amigos e familiares para que a vejam! O prazo de 3 meses começa agora.", style: AlertStyle.success)
            }
        }
    }
    
    func initVersion() {
        switchBtn.moveBall()
        let date = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let today = formatter.string(from: currentDate)
        let exp = formatter.string(from: date!)
        
        details.dateStart = today
        details.dateEnd = exp
        
        let values = ["dateStart": today, "dateEnd": exp]
        Database.database().reference().child("Codes").child(details.eventID!).updateChildValues(values)
        displayDates()
    }
    
    func displayDates() {
        if let startDate = details.dateStart, let endDate = details.dateEnd {
            timeLbl.text = "\(startDate) - \(endDate)"
            statusLbl.text = "Versão online"
            messageLbl.text = "Compartilhe o app com seus convidados!"
            switchBtn.isUserInteractionEnabled = false
            switchBtn.moveBall()
            powerIcon.image = #imageLiteral(resourceName: "online")
            renewBtn.isHidden = false
            renewBtn.isEnabled = true
        }
    }
    
    @objc func updateExpDate(notification: NSNotification) {
        if let newExpDate = details.dateEnd, let startDate = details.dateStart {
            timeLbl.text = "\(startDate) - \(newExpDate)"
        }
    }
    
// MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PortalCell
        cell.delegate = self
        cell.model = screens[indexPath.item]
        setProgress {
            let progress = self.progresso[indexPath.item]
            cell.progressBar.setProgress(progress, animated: true)
            let intValue = Int(cell.progressBar.progress * 100)
            cell.progressLbl.text = "\(intValue)%"
            for num in self.progresso {
                if num < 1.0 {
                    self.aux = false
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w: CGFloat?
        var h: CGFloat?
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            w = view.frame.width * 0.45
            h = view.frame.height * 0.17
        } else if size < 414 && size > 320 {
            w = view.frame.width * 0.45
            h = view.frame.height * 0.17
        } else if size <= 320 {
            w = view.frame.width * 0.43
            h = view.frame.height * 0.17
        }
        return CGSize(width: w!, height: h!)
    }
    
// MARK: FETCH VERSION PROGRESS
    
    func setProgress(completion: @escaping () -> Void) {
        progresso = [0.0, 0.0, 0.0, 0.0]
        fetchFirstScreens {
            self.fetchSecondScreen {
                self.fetchEventScreens {
                    completion()
                }
            }
        }
    }
    
    func fetchFirstScreens(completion: @escaping () -> Void) {
        guard let eventID = details.eventID else { return }
        var progress: Float = 0.0
        let ref = Database.database().reference().child("Codes").child(eventID)
        ref.observe(.value, with: { (snap) in
            if snap.hasChild("stripeAccount") {
                self.progresso[3] = 1.0
                let data = snap.value as? [String: Any]
                details.stripeAcc = data!["stripeAccount"] as? String
            }
        })
        ref.child("video").observe(.value, with: { (snap) in
            progress += Float(snap.childrenCount)
        })
        ref.child("story").observe(.value, with: { (snap) in
            progress += Float(snap.childrenCount)
        })
        ref.observe(.value, with: { (snap) in
            if snap.hasChild("slideshow") {
                progress += 1.0
            }
            self.progresso[0] = (progress / 10) * 1.429
            completion()
        })
    }
    
    func fetchSecondScreen(completion: @escaping () -> Void) {
        guard let eventID = details.eventID else { return }
        Database.database().reference().child("Codes").child(eventID).observe(.value, with: { (snap) in
            if snap.hasChild("padrinhos") {
                self.progresso[1] = 1.0
            }
            completion()
        })
    }
    
    func fetchEventScreens(completion: @escaping () -> Void) {
        guard let eventID = details.eventID else { return }
        Database.database().reference().child("Codes").child(eventID).child("evento").observe(.value, with: { (snap) in
            var progress: Float = 0.0
            progress += Float(snap.childrenCount)
            self.progresso[2] = (progress / 10) * 2.5
            completion()
        })
        
    }
    
}


extension PortalVC: PortalCellDelegate {
    func transition(cell: PortalCell) {
        if let index = collec.indexPath(for: cell) {
            switch index.item {
            case 0: self.navigationController?.pushViewController(MainVC(), animated: true)
            case 1: self.navigationController?.pushViewController(PadrinhosVC(), animated: true)
            case 2: self.navigationController?.pushViewController(EventoVC(), animated: true)
            default: self.navigationController?.pushViewController(GiftsVC(), animated: true)
            }
        }
    }
}










