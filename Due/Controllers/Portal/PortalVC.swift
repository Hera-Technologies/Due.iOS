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
    
    let buttons: [PortalButton] = {
        let main = PortalButton(titulo: "Tela Inicial", icon: "video", items: "7 itens")
        let padrinhos = PortalButton(titulo: "Padrinhos", icon: "padrinhos", items: "1 item")
        let evento = PortalButton(titulo: "Evento", icon: "map", items: "4 itens")
        let presentes = PortalButton(titulo: "Presentes", icon: "cart", items: "1 item")
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
    
    let seeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "eye"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Portal"
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Black", size: 30)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let event: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 24)
        lbl.alpha = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let edit: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "edit"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.alpha = 0
        return btn
    }()
    
    let statusLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = .gray
        lbl.text = "status:"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let status: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = darker
        lbl.text = "offline"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let startLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = .gray
        lbl.text = "início em:"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let start: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = darker
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let endLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = .gray
        lbl.text = "válida até:"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Book", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let end: UILabel = {
        let lbl = UILabel()
        lbl.textColor  = darker
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let initBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Iniciar", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let renewBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Renovar", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = UIColor(red: 55/255, green: 236/255, blue: 186/255, alpha: 1)
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.isHidden = true
        btn.isEnabled = false
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
    
    let control: UIPageControl = {
        let ctr = UIPageControl()
        ctr.pageIndicatorTintColor = linewhite
        ctr.currentPageIndicatorTintColor = .darkGray
        ctr.numberOfPages = 4
        ctr.translatesAutoresizingMaskIntoConstraints = false
        return ctr
    }()
    
    // MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
        view.addSubview(line)
        view.addSubview(event)
        view.addSubview(edit)
        view.addSubview(statusLbl)
        view.addSubview(status)
        view.addSubview(startLbl)
        view.addSubview(start)
        view.addSubview(endLbl)
        view.addSubview(end)
        view.addSubview(initBtn)
        view.addSubview(renewBtn)
        view.addSubview(shareBtn)
        view.addSubview(collec)
        view.addSubview(control)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(backHome), for: .touchUpInside)
        
        seeBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 4).isActive = true
        seeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        seeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        seeBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        seeBtn.addTarget(self, action: #selector(seeEvent), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        shareBtn.centerYAnchor.constraint(equalTo: viewTitle.centerYAnchor).isActive = true
        shareBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shareBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        let eventY = view.frame.height * 0.25
        event.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -eventY).isActive = true
        event.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        edit.centerYAnchor.constraint(equalTo: event.centerYAnchor).isActive = true
        edit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        edit.heightAnchor.constraint(equalToConstant: 30).isActive = true
        edit.widthAnchor.constraint(equalToConstant: 30).isActive = true
        edit.addTarget(self, action: #selector(editEventName), for: .touchUpInside)
        
        var lblY: CGFloat?
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            lblY = view.frame.height * 0.16
        } else {
            lblY = view.frame.height * 0.18
        }
        statusLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lblY!).isActive = true
        statusLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        status.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        status.centerYAnchor.constraint(equalTo: statusLbl.centerYAnchor).isActive = true
        
        startLbl.topAnchor.constraint(equalTo: statusLbl.bottomAnchor, constant: 15).isActive = true
        startLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        start.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        start.centerYAnchor.constraint(equalTo: startLbl.centerYAnchor).isActive = true
        
        endLbl.topAnchor.constraint(equalTo: startLbl.bottomAnchor, constant: 15).isActive = true
        endLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        end.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        end.centerYAnchor.constraint(equalTo: endLbl.centerYAnchor).isActive = true
        
        let height = view.frame.height * 0.07
        initBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        initBtn.topAnchor.constraint(equalTo: endLbl.bottomAnchor, constant: 25).isActive = true
        initBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        initBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        initBtn.layer.cornerRadius = height / 2
        initBtn.addTarget(self, action: #selector(checkIfVersionIsCompleteBeforeInit), for: .touchUpInside)
        
        renewBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        renewBtn.topAnchor.constraint(equalTo: endLbl.bottomAnchor, constant: 25).isActive = true
        renewBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        renewBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        renewBtn.layer.cornerRadius = height / 2
        renewBtn.addTarget(self, action: #selector(renewVersion), for: .touchUpInside)
        
        control.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        control.topAnchor.constraint(equalTo: initBtn.bottomAnchor, constant: 20).isActive = true
        control.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        collec.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 0).isActive = true
        collec.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collec.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collec.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collec.delegate = self
        collec.dataSource = self
        collec.register(PortalCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    @objc func share() {
        if let name = event.text {
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
        nomeDoEvento = event.text
        let vc = RenewVC()
        customPresentViewController(renewAlert, viewController: vc, animated: true, completion: nil)
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
            self.event.text = eventName
            self.event.alpha = 1
            self.edit.alpha = 1
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
        nomeDoEvento = event.text
        let nameChange = NameChangeVC()
        customPresentViewController(nameChangeAlert, viewController: nameChange, animated: true, completion: nil)
    }
    
    @objc func backHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: INITIATE DUE VERSION
    
    @objc func checkIfVersionIsCompleteBeforeInit() {
        if aux == false {
            _ = SweetAlert().showAlert("Oops...", subTitle: "Você precisa completar sua versão para poder iniciá-la", style: .error)
        } else {
            confirmInit()
        }
    }
    
    func confirmInit() {
        SweetAlert().showAlert("Iniciar versão?", subTitle: "Sua versão se tornará acessível para outros usuários, dando início ao prazo de 3 meses.", style: AlertStyle.warning, buttonTitle: "Cancelar", buttonColor: UIColor.colorFromRGB(0xFF8989), otherButtonTitle:  "Confirmar", otherButtonColor: UIColor.colorFromRGB(0x99B9f3)) { (isOtherButton) -> Void in
            if !isOtherButton {
                self.initVersion()
                _ = SweetAlert().showAlert("Versão online!", subTitle: "Sua versão agora está online! Compartilhe o app com amigos e familiares para que a vejam! O prazo de 3 meses começa agora.", style: AlertStyle.success)
            }
        }
    }
    
    func initVersion() {
        let date = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let today = formatter.string(from: currentDate)
        let exp = formatter.string(from: date!)
        
        details.dateStart = today
        details.dateEnd = exp
        
        let values = ["dateStart": today, "dateEnd": exp]
        Database.database().reference().child("Codes").child(details.eventID!).updateChildValues(values)
        displayDates()
    }
    
    func displayDates() {
        if let dateStart = details.dateStart, let dateEnd = details.dateEnd {
            start.text = dateStart
            end.text = dateEnd
            status.text = "online"
            initBtn.isHidden = true
            initBtn.isEnabled = false
            renewBtn.isHidden = false
            renewBtn.isEnabled = true
        }
        
    }
    
    @objc func updateExpDate(notification: NSNotification) {
        if let newExpDate = details.dateEnd {
            end.text = newExpDate
        }
    }
    
    // MARK: COLLECTION VIEW DELEGATE AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PortalCell
        cell.vc = self
        setProgress {
            let progress = self.progresso[indexPath.item]
            cell.progressBar.setProgress(progress, animated: true)
            cell.progressLbl.text = "\(cell.progressBar.progress * 100)%"
            for num in self.progresso {
                if num < 1.0 {
                    self.aux = false
                }
            }
        }
        cell.configureCell(button: buttons[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PortalCell
        switch indexPath.item {
        case 0:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(MainVC(), animated: true)
            })
        case 1:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(PadrinhosVC(), animated: true)
            })
        case 2:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(EventoVC(), animated: true)
            })
        default:
            animateCell(cell: cell, completion: {
                self.navigationController?.pushViewController(GiftsVC(), animated: true)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collec.frame.width, height: collec.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNum = Int(targetContentOffset.pointee.x / view.frame.width)
        control.currentPage = pageNum
    }
    
    func animateCell(cell: PortalCell, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            cell.transform = CGAffineTransform.identity
        }) { (boo) in
            completion()
        }
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


