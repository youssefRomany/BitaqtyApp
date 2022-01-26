//
//  RechargePopupVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/5/21.
//

import UIKit

class RechargePopupVC: UIView {
    @IBOutlet weak var loaderView: ErrorView!
    
    @IBOutlet weak var view1: RechargeItemView!
    @IBOutlet weak var view2: RechargeItemView!
    @IBOutlet weak var view3: RechargeItemView!
    @IBOutlet weak var view4: RechargeItemView!
    @IBOutlet weak var view5: RechargeItemView!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    
    @IBOutlet weak var viewLog: UIView!
    @IBOutlet weak var viewBankLog: UIView!
    @IBOutlet weak var lblLog: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBankLog: UILabel!
    @IBOutlet weak var viewSpace: UIView!
    
    private var data: [RechargeMethod]!
    weak var delegate: RechargePopDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    // MARK: setup view
    
    private func loadViewFromNib() -> UIView {
        let viewBundle = Bundle(for: type(of: self))
        let view = viewBundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]
        self.tag = 0;
        return view as! UIView
    }
    
    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
        setupViews()
    }
    func setupViews(){
        
        //        let blurEffect = UIBlurEffect(style: .extraLight) // .extraLight or .dark
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = viewBG.frame
        //        viewBG.addSubview(blurEffectView)
        
        lblLog.textAlignment = lang == "en" ? .left : .right
        lblTitle.textAlignment = lang == "en" ? .left : .right
        lblBankLog.textAlignment = lang == "en" ? .left : .right
        loaderView.delegate = self
        stack1.isHidden = true
        stack2.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
        view5.isHidden = true
        if DataService.getUserData() != nil{
            if self.data == nil{
                loadData()
            }else{
                setupResult()
            }
            //            if user.accountType == Roles.SUB_ACCOUNT.rawValue{
            //                setupSubAccountPopUP()
            //            }else{
            //                if self.data == nil{
            //                    loadData()
            //                }else{
            //                    setupResult()
            //                }
            //            }
        }
        
        
        viewLog.setupShadowsWithRound(5)
        viewBankLog.setupShadowsWithRound(5)
        
        lblTitle.text = strings.rechargeRequests.localizedValue
        lblLog.text = strings.rechargeLog.localizedValue
        lblBankLog.text = strings.bankTransferLog.localizedValue
    }
    func loadData(){
        self.loaderView.startLoading()
        RechargeAPIs.getResellerRechargeMethods({ (result) in
            self.loaderView.stopLoading()
            self.data = result
            self.setupResult()
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                if self.parentViewController != nil{
                    DataService.ds.showAlert(self.parentViewController!, err.errorMessage) {
                        DataService.deleteUserData()
                        DataService.loadHome()
                    }
                }else{
                    let error = ErrorMessage(msgs.serverError.localizedValue)
                    loaderView.showException(error: error)
                    
                }
            }else{
                loaderView.showException(error: err)
            }
        })
    }
    
    func setupResult(){
        var hasBank = false
        if data != nil && data.count > 0{
            stack1.isHidden = false
            var index = 0
            for i in 0..<data.count{
                let item = data[i]
                if(!item.ChargingCode.isEmpty){
                    let type = RECHARGE_METHODS.init(rawValue: item.ChargingCode)!.type
                    if type == RechargeTypes.Bank.rawValue{
                        hasBank = true
                    }
                    if index == 0{
                        view1.setData(type, item.Name)
                        view1.rechargeMethod = item
                    }else if index == 1{
                        view2.isHidden = false
                        view2.setData(type , item.Name)
                        view2.rechargeMethod = item
                    }else if index == 2{
                        view3.isHidden = false
                        view3.setData(type, item.Name)
                        view3.rechargeMethod = item
                    }else if index == 3{
                        viewSpace.isHidden = false
                        stack2.isHidden = false
                        view4.setData(type, item.Name)
                        view4.rechargeMethod = item
                    }else if index == 4{
                        viewSpace.isHidden = true
                        view5.isHidden = false
                        view5.setData(type, item.Name)
                        view5.rechargeMethod = item
                    }
                    index += 1
                }
            }
            
            //            viewLog.isHidden = false
            
            if let user = DataService.getUserData(), user.accountType == Roles.SUB_ACCOUNT.rawValue{
                if  user.reseller!.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.RECHARGE.rawValue})[0].Enabled{
                    let permission = user.reseller?.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.RECHARGE.rawValue})[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue}[0]
                    
                    if !permission!.Enabled{
                        viewLog.isHidden = true
                        hasBank = false
                    }
                }
            }
            if hasBank{
                viewBankLog.isHidden = false
                lblTitle.isHidden = false
            }else{
                viewBankLog.isHidden = true
                lblTitle.isHidden = true
            }
        }
    }
    //    func setupSubAccountPopUP() {
    //        var hasBank = false
    //        let permissions = DataService.getUserData()?.reseller?.PermissionsArr
    //        let permission = permissions!.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0]
    //
    //        if permission.Enabled{
    //            let arrLog = permission.ChildPermissions.filter({$0.Enabled && $0.id == CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue})
    //            viewLog.isHidden = !(arrLog.count > 0)
    //
    //            let arr = permission.ChildPermissions.filter({$0.Enabled && $0.id != CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue && $0.id != CHILD_RECHARGE_PERMISSIONS_IDS.CHOOSE_RECHARGE_LOG.rawValue})
    //            let _ = print("Noura ====\(arr.count)")
    //            if arr.count > 0{
    //                stack1.isHidden = false
    //                var index = 0
    //                for i in 0..<arr.count{
    //                    let item = arr[i]
    //                    let type = CHILD_RECHARGE_PERMISSIONS_IDS.init(rawValue: item.id!)!.type
    //                    if type == RechargeTypes.Bank.rawValue{
    //                        hasBank = true
    //                    }
    //                    if index == 0{
    //                        view1.setData(type)
    //                    }else if index == 1{
    //                        view2.isHidden = false
    //                        view2.setData(type)
    //                    }else if index == 2{
    //                        view3.isHidden = false
    //                        view3.setData(type)
    //                    }else if index == 3{
    //                        viewSpace.isHidden = false
    //                        stack2.isHidden = false
    //                        view4.setData(type)
    //                    }else if index == 4{
    //                        viewSpace.isHidden = true
    //                        view5.isHidden = false
    //                        view5.setData(type)
    //                    }
    //                    index += 1
    //
    //                }
    //                if hasBank{
    //                    viewBankLog.isHidden = false
    //                    lblTitle.isHidden = false
    //                }else{
    //                    viewBankLog.isHidden = true
    //                    lblTitle.isHidden = true
    //                }
    //            }
    //        }
    //    }
    func checkData(){
        if DataService.getUserData() != nil{
            if self.data == nil{
                loadData()
            }else{
                setupResult()
            }
        }
    }
    @IBAction func onRechargeLog(_ sender: Any) {
        if delegate != nil{
            delegate!.onRecharge()
        }
    }
    @IBAction func onBankTransfer(_ sender: Any) {
        if delegate != nil{
            delegate!.onBankTransfer()
        }
    }
}
extension RechargePopupVC: ReloadDataDelegate{
    func reloadData() {
        self.loadData()
    }
}
