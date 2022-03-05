//
//  MainVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/25/21.
//

import Foundation
import SwiftUI
import XLPagerTabStrip

var addRecharge = false

class MainVC: ButtonBarPagerTabStripViewController {
    @IBOutlet open var loaderView: ErrorView!
    
    @IBOutlet open var viewContainer: UIView!
    @IBOutlet open var viewNoPermission: UIView!
    
    @IBOutlet open var btnCenter: UIButton!
    @IBOutlet open var lblCenter: UILabel!
    @IBOutlet open var lblTextError: UILabel!
    
    @IBOutlet open var imageCenter: UIImageView!
    @IBOutlet weak var viewRecharge: RechargePopupVC!
    var barButton: UIBarButtonItem!
    var user: User!
    var subAccountTabs: [Int] = []
    var VCs: [UIViewController] = []
    var hasPermission = false
    var hasRecharge = false
    var rechargeIndex = -1
    var isRechargedOpen = false
    var dateFrom = ""
    var dateTo = ""
    var dateFromD = ""
    var dateToD = ""
    var loadProfile = false
    var showww = ""
    override func viewDidLoad() {
        user = DataService.getUserData()
        let permissions = user.reseller?.PermissionsArr.filter{$0.Enabled}
        for item in permissions ?? []{
            print("joePerm",item.id ?? 0, item.name ?? "")
        }
        print("rrrrrrrrr",user.reseller?.AccessType)
        print("rrrrrrrrr",user.reseller?.authenticationType)
        print(user.accountType)
        print(user.reseller?.AccessType)
        if user.accountType == Roles.SUB_ACCOUNT.rawValue{
            setupSubAccountTabs()
        }else{
            setupPager()
        }
        loadSettings()
        showww = SETTINGS.first{$0.propertyKey == SETTING_KEYS.IOS_ENABLE_RECHARGE.rawValue}?.PropertyValue ?? "FALSE"

        super.viewDidLoad()
        self.setPagerOrientation()
        self.setupViews()
        addRightButton()
        let imageview = UIImageView()
        setImageView(forImageView: imageview, andURL: WhiteLabelLocal.shared.getLocalWhiteLabelList()?.logoPath ?? "", andPlaceHolderImage: "")

        imageview.frame = CGRect(x: 0, y: 0, width: 40, height: 60)
        imageview.contentMode = .scaleAspectFit
        imageview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 60).isActive = true

        navigationItem.titleView = imageview
        NotificationCenter.default.addObserver(self, selector: #selector(setButton), name: .tapSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rechargeTapped(_:)), name: .rechargeSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBalance), name: .reloadBalance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideRechargePopup), name: .hideRechargePopup, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func reloadBalance(_ notification: NSNotification) {
        addRightButton()
    }
    @objc private func hideRechargePopup(_ notification: NSNotification) {
        if user.accountType != Roles.SUB_ACCOUNT.rawValue{
            self.moveToViewController(at: 0, animated: false)
            setSelectedTab()
        }else{
            let index = self.currentIndex
            let indexPath = IndexPath(item: index, section: 0)
            let cell: ButtonBarViewCell = self.buttonBarView.cellForItem(at: indexPath) as! ButtonBarViewCell
            cell.label.textColor = .secondryColor
            cell.imageView.tintColor = .secondryColor
            self.moveToViewController(at: 0, animated: false)
            
        }
    }
    
    func loadSettings(){
        if SETTINGS.count == 0{
            GeneralAPIs.getSettings {
                print("chechhhhhhh \(SETTINGS)")
            } _: { (err) in
            }
        }else{
            print("hhhhhhh \(SETTINGS)")
        }
    }
    
    func setupViews(){
        self.viewRecharge.delegate = self
        if user.accountType != Roles.SUB_ACCOUNT.rawValue{
//            setCenterBtn()
        }
    }
    func setCenterBtn(){
        self.imageCenter.addShadow(location: .top)
        self.btnCenter.setupShadowsWithRound(UIDevice.current.userInterfaceIdiom == .pad ? 30 : 20)
        self.lblCenter.text = strings.Recharge.localizedValue
        self.imageCenter.isHidden = false
        self.btnCenter.tintColor = .secondryColor
        self.viewContainer.isHidden = false
    }
    func addRightButton(){
        if let user  = DataService.getUserData() {
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width / 2) - 40, height: 44))
            
            let controller = UIHostingController(rootView: NavigationUserView(user: user))
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view1.addSubview(controller.view)
            NSLayoutConstraint.activate([controller.view.widthAnchor.constraint(equalTo: view1.widthAnchor, multiplier: 1),
                                         controller.view.heightAnchor.constraint(equalTo: view1.heightAnchor),
                                         controller.view.centerXAnchor.constraint(equalTo: view1.centerXAnchor),
                                         controller.view.centerYAnchor.constraint(equalTo: view1.centerYAnchor)])
            view1.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(openUserModel))
            view1.addGestureRecognizer(tap)
            let barButtonItem = UIBarButtonItem(customView: view1)
            self.navigationItem.leftBarButtonItem = barButtonItem
            
            if user.accountType == Roles.SUB_ACCOUNT.rawValue && hasPermission{
                if user.reseller!.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.PURCHASE.rawValue})[0].Enabled{
                    let button = UIButton(type: UIButton.ButtonType.custom)
                    button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    button.round(to: 15)
                    button.setImage(UIImage(named: "ic_search"), for: .normal)
                    button.addTarget(self, action:#selector(opnSearchView), for: .touchUpInside)
                    button.imageView?.tintColor = .textColor
                    button.backgroundColor = .bgColor
                    button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    
                    //view.addSubview(button)
                    barButton = UIBarButtonItem(customView: button)
                    self.navigationItem.rightBarButtonItem = barButton
                }
            }
        }
    }
    
    @objc func openUserModel(){
        let vc = ProfilePopUpVC(nibName: "ProfilePopUpVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    @objc func opnSearchView(){
        let vc = SearchVC(nibName: "SearchVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backButtonTitle = ""
        }
    }
    
    // MARK: - Reseller Custom Button
    @IBAction func openRechargeTypesWindow(_ sender: UIButton) {
        showHideRecharge()
    }
    func showHideRecharge(){
        let index = self.currentIndex
        let indexPath = IndexPath(item: index, section: 0)
        let cell: ButtonBarViewCell = self.buttonBarView.cellForItem(at: indexPath) as! ButtonBarViewCell
        if btnCenter.tag == 0{
            animateView()
            self.showRechargeView()
            self.btnCenter.tag = 1
            cell.label.textColor = .secondryColor
            cell.imageView.tintColor = .secondryColor
            self.btnCenter.setImage( UIImage(named: "Icon_close"), for: .normal)
            self.lblCenter.textColor = .accentColor
        }else{
            self.setButton()
            cell.label.textColor = .accentColor
            cell.imageView.tintColor = .accentColor
        }
    }
    
    @objc func setButton(){
        hideRechargeView()
        self.btnCenter.transform = CGAffineTransform(rotationAngle: -.pi/2)
        self.btnCenter.tag = 0
        self.btnCenter.setImage( UIImage(named: "Icon_plus"), for: .normal)
        self.lblCenter.textColor = .secondryColor
    }
    func setSelectedTab(){
        let index = self.currentIndex
        let indexPath = IndexPath(item: index, section: 0)
        let cell: ButtonBarViewCell = self.buttonBarView.cellForItem(at: indexPath) as! ButtonBarViewCell
        cell.label.textColor = .accentColor
        cell.imageView.tintColor = .accentColor
        if cell.label.text == strings.Recharge.localizedValue{
            showRechargeView()
        }else{
            self.setButton()
        }
    }
    func animateView(){
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.curveEaseInOut , .allowUserInteraction],
                       animations: {
            self.btnCenter.transform = CGAffineTransform(rotationAngle: .pi/2)
        })
    }
    func showRechargeView(){
        self.viewRecharge.checkData()
        UIView.transition(with: self.viewRecharge, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.viewRecharge.isHidden = false
        })
    }
    func hideRechargeView(){
        UIView.transition(with: self.viewRecharge, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.viewRecharge.isHidden = true
        })
    }
    func setNavigationBarShadow(){
        self.navigationController!.navigationBar.layer.shadowColor = UIColor.black.cgColor;
        self.navigationController!.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 10);
        self.navigationController!.navigationBar.layer.shadowOpacity = 0.2;
        self.navigationController!.navigationBar.layer.shadowRadius = 16;
    }
    // MARK: - PagerSetup
    func setupPager(){
        settings.style.buttonBarItemFont = UIFont(name: FONT_REG, size: FONT_SMALLER )!;
        settings.style.buttonBarBackgroundColor = .clear;
        settings.style.buttonBarItemBackgroundColor = .primary;
        settings.style.selectedBarBackgroundColor = .primary
        settings.style.selectedBarHeight = 0.0;
        settings.style.buttonBarMinimumLineSpacing = 0;
        settings.style.buttonBarMinimumInteritemSpacing = 0;
        settings.style.buttonBarItemLeftRightMargin = 0;
        settings.style.buttonBarItemsShouldFillAvailableWidth = true;
        settings.style.buttonBarLeftContentInset =  0;
        settings.style.buttonBarRightContentInset = 0;
        containerView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft;
        buttonBarView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft;
        // buttonBarView.addShadow(location: .top)
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            if (self?.loadProfile == true){
                AccountServices.getProfile {
                    NotificationCenter.default.post(name: .reloadBalance, object: nil)
                } _: {}
            }
            guard changeCurrentIndex == true else { return }
            //self?.setButton(tag: 1)
            if self?.btnCenter != nil && self?.btnCenter.tag == 1{
                self!.setButton()
            }
            if(oldCell != nil){
                oldCell?.label.textColor = .secondryColor
                oldCell?.imageView.tintColor = .secondryColor
            }
            
            if(newCell != nil){
                newCell?.label.textColor = .accentColor
                newCell?.imageView.tintColor = .accentColor
            }
            if ((self?.hasRecharge) != nil){
                self?.hideRechargeView()
                if newCell?.label.text == strings.Recharge.localizedValue{
                    self?.showRechargeView()
                }
            }
        }
        containerView.isScrollEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 10){ [weak self] in
            self?.loadProfile = true
        }
    }
    func setPagerOrientation(){
        DispatchQueue.main.async {
            //self.moveToViewController(at: 1, animated: false)
            self.moveToViewController(at: 0, animated: false)
            if self.hasRecharge && self.rechargeIndex == 0{
                self.hideRechargeView()
            }
        }
        if lang == "ar" {
            containerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            for controller in viewControllers{
                controller.view.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            }
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if user.accountType == Roles.SUB_ACCOUNT.rawValue{
            return VCs
        }else{
            let child_0 = EmptyView(nibName: "EmptyView", bundle: nil)
            
            let child_1 = HomeVC(nibName: "HomeVC", bundle: nil)
            let child_2 = TransactionsLogVC(nibName: "TransactionsLogVC", bundle: nil)
            let child_3 = ProductListVC(nibName: "ProductListVC", bundle: nil)
            let child_4 = MoreVC(nibName: "MoreVC", bundle: nil)
            
            child_1.itemInfo.image = UIImage(named: "Icon_home")
            child_2.itemInfo.image = UIImage(named: "Icon_paper")
            child_3.itemInfo.image = UIImage(named: "Icon_list")
            child_4.itemInfo.image =  UIImage(named: "Icon_menu")
            child_0.itemInfo.title = ""
            child_1.itemInfo.title = strings.Home.localizedValue
            child_2.itemInfo.title = strings.TransactionLog.localizedValue
            child_3.itemInfo.title = strings.ProductList.localizedValue
            child_4.itemInfo.title = strings.More.localizedValue
            if showww == "TRUE"{
                setCenterBtn()

                return [child_1, child_2, child_0, child_3, child_4]

            }else{
//                btnCenter.isHidden = true
//                lblCenter.isHidden = true
//                imageCenter.isHidden = true
                return [child_1, child_2, child_3, child_4]

            }
        }
    }
    // MARK: - PagerSetup ends
    
    
    func setupSubAccountTabs(){
        let permissions = user.reseller?.PermissionsArr.filter{$0.Enabled}
        for item in permissions ?? []{
            print("joePerm",item.id ?? 0, item.name ?? "")
        }
        if permissions != nil && permissions!.count > 0{
            let permissionPurchase = permissions!.filter{$0.id == PERMISSIONS_IDS.PURCHASE.rawValue}
            if permissionPurchase.count > 0{
                self.subAccountTabs = [SUBACCOUNT_TABS.HOME.rawValue]
                subAccountTabs.append(SUBACCOUNT_TABS.STORE.rawValue)
                let child_1 = SubResellerHome(nibName: "SubResellerHome", bundle: nil)
                child_1.itemInfo.image = UIImage(named: "Icon_home")
                child_1.itemInfo.title = strings.Home.localizedValue
                VCs.append(child_1)
                
                let child_2 = StoreVC(nibName: "StoreVC", bundle: nil)
                child_2.itemInfo.image = UIImage(named: "store_tab")
                child_2.itemInfo.title = strings.store.localizedValue
                VCs.append(child_2)
            }else{
                self.subAccountTabs = [SUBACCOUNT_TABS.HOME.rawValue]
                let child_1 = SubResellerHome(nibName: "SubResellerHome", bundle: nil)
                child_1.itemInfo.image = UIImage(named: "Icon_home")
                child_1.itemInfo.title = strings.Home.localizedValue
                VCs.append(child_1)
            }
            
            let permissionTrans = permissions!.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}
            if permissionTrans.count > 0{
                subAccountTabs.append(SUBACCOUNT_TABS.TRANSACTION_LOG.rawValue)
                
                let child_2 = TransactionsLogVC(nibName: "TransactionsLogVC", bundle: nil)
                child_2.itemInfo.image = UIImage(named: "Icon_paper")
                child_2.itemInfo.title = strings.TransactionLog.localizedValue
                VCs.append(child_2)
            }
            
            let permissionProductList = permissions!.filter{$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_LIST.rawValue}
            if permissionProductList.count > 0{
                subAccountTabs.append(SUBACCOUNT_TABS.PRODUCT_LIST.rawValue)
                
                let child_3 = ProductListVC(nibName: "ProductListVC", bundle: nil)
                child_3.itemInfo.image = UIImage(named: "Icon_list")
                child_3.itemInfo.title = strings.ProductList.localizedValue
                VCs.append(child_3)
            }
            
            let permissionReports = permissions!.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}
            if permissionReports.count > 0{
                subAccountTabs.append(SUBACCOUNT_TABS.REPORTS.rawValue)
                let child_3 = SalesReportVC(nibName: "SalesReportVC", bundle: nil)
                child_3.itemInfo.image = UIImage(named: "ic_state")
                child_3.itemInfo.title = accountStrings.more_reports.localizedValue
                VCs.append(child_3)
            }
            
            let permissionSupport = permissions!.filter{$0.id == PERMISSIONS_IDS.VIEW_SUPPORT_CENTER.rawValue}
            if permissionSupport.count > 0{
                subAccountTabs.append(SUBACCOUNT_TABS.SUPPORT.rawValue)
                let child_3 = SupportCenterVC(nibName: "SupportCenterVC", bundle: nil)
                child_3.itemInfo.image = UIImage(named: "ic_support_center")
                child_3.itemInfo.title = strings.supportTitle.localizedValue
                VCs.append(child_3)
            }
            
            
            let permissionRecharge = permissions!.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}
            if permissionRecharge.count > 0{
                let child_0 = EmptyView(nibName: "EmptyView", bundle: nil)
                child_0.itemInfo.image = UIImage(named: "Icon_plus")
                child_0.itemInfo.title = strings.Recharge.localizedValue
                if (subAccountTabs.count >= 4) {
                    //  setCenterBtn()
                    
                    subAccountTabs.insert(SUBACCOUNT_TABS.RECHARGE.rawValue, at: 2)
                    VCs.insert(child_0, at: 2)
                } else {
                    if self.subAccountTabs.count == 0 || self.subAccountTabs.count == 2{
                        //  setCenterBtn()
                        if self.subAccountTabs.count == 0{
                            self.subAccountTabs = [SUBACCOUNT_TABS.RECHARGE.rawValue]
                            VCs = [child_0]
                        }else{
                            let item = subAccountTabs[1]
                            let vc = VCs[1]
                            
                            subAccountTabs[1] = SUBACCOUNT_TABS.RECHARGE.rawValue
                            VCs[1] = child_0
                            
                            subAccountTabs.append(item)
                            VCs.append(vc)
                        }
                    }else{
                        if self.subAccountTabs.count == 3{
                            self.hasRecharge = true
                            child_0.itemInfo.image = UIImage(named: "Icon_plus")
                            child_0.itemInfo.title = strings.Recharge.localizedValue
                            
                            let item = subAccountTabs[2]
                            let vc = VCs[2]
                            
                            subAccountTabs[2] = SUBACCOUNT_TABS.RECHARGE.rawValue
                            VCs[2] = child_0
                            
                            subAccountTabs.append(item)
                            VCs.append(vc)
                        }else{
                            self.hasRecharge = true
                            child_0.itemInfo.image = UIImage(named: "Icon_plus")
                            child_0.itemInfo.title = strings.Recharge.localizedValue
                            self.rechargeIndex = self.subAccountTabs.count - 1
                            subAccountTabs.append(SUBACCOUNT_TABS.RECHARGE.rawValue)
                            VCs.append(child_0)
                        }
                    }
                }
            }
            if subAccountTabs.count > 5{
                MORE_PERMISSIONS = []
                for i in 4..<subAccountTabs.count{
                    MORE_PERMISSIONS.append(subAccountTabs[i])
                }
                var size = subAccountTabs.count
                while (size > 4){
                    subAccountTabs.remove(at: size - 1)
                    VCs.remove(at: size - 1)
                    size -= 1
                }
                subAccountTabs.append(SUBACCOUNT_TABS.MORE.rawValue)
                let child_4 = MoreVC(nibName: "MoreVC", bundle: nil)
                child_4.itemInfo.image =  UIImage(named: "Icon_menu")
                child_4.itemInfo.title = strings.More.localizedValue
                VCs.append(child_4)
            }
        }
        

        
        
        for (index,item) in subAccountTabs.enumerated(){
            if item == 3 {
                if showww != "TRUE"{
                    subAccountTabs.remove(at: index)
                    VCs.remove(at: index)
                    break

                }
            }
        }
        
        
 
        let _ = print("Noura subAccount \(subAccountTabs)")
        let _ = print("Noura MORE_PERMISSIONS \(MORE_PERMISSIONS)")
        if VCs.count > 0{
            if VCs.count == 1 && subAccountTabs.count == 1 && subAccountTabs[0] == SUBACCOUNT_TABS.HOME.rawValue{
                showEmptyView()
            }else{
                hasPermission = true
                setupPager()
            }
        }else{
            showEmptyView()
        }
    }
    func moveTransLog(dateFrom: String, dateTo: String, dateFromD: String, dateToD: String){
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.dateFromD = dateFromD
        self.dateToD = dateToD
        self.moveToViewController(at: 1, animated: false)
        
        //
        //        let info = ["DATE_FROM": dateFrom, "DATE_TO": dateTo]
        //        NotificationCenter.default.post(name: .reloadTransaction, object: nil, userInfo: info)
    }
    func showEmptyView(){
        let mainView = EmptyView(nibName: "EmptyView", bundle: nil)
        self.buttonBarView.isHidden = true
        VCs.append(mainView)
        setupPager()
        viewNoPermission.isHidden = false
        lblTextError.text = strings.noPermission.localizedValue
    }
}
extension MainVC: RechargePopDelegate{
    @objc private func rechargeTapped(_ notification: NSNotification) {
        if let index = notification.userInfo!["TYPE"] {
            let type = index as! Int
            if type != RechargeTypes.Bank.rawValue && type != RechargeTypes.PayPal.rawValue{
                let vc = PaymentMethodVC(nibName: "PaymentMethodVC", bundle: nil)
                vc.type = type
                if let val = notification.userInfo?["METHOD"] {
                    let method = val  as! RechargeMethod
                    vc.rechargeMethod = method
                }
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
            }else if (type == RechargeTypes.Bank.rawValue){
                let vc = BankTransferVC(nibName: "BankTransferVC", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
                // self.setSelectedTab()
            }else if (type == RechargeTypes.PayPal.rawValue){
                let vc = PayPalRechargeVC(nibName: "PayPalRechargeVC", bundle: nil)
                vc.type = type
                if let val = notification.userInfo?["METHOD"] {
                    let method = val  as! RechargeMethod
                    vc.rechargeMethod = method
                }
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    func onRecharge(){
        //setSelectedTab()
        let vc = RechargingLogVC(nibName: "RechargingLogVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func onBankTransfer(){
        //setSelectedTab()
        let vc = BankTransferLogVC(nibName: "BankTransferLogVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
