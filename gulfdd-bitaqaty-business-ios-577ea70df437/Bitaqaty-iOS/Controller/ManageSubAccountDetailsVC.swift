//
//  ManageSubAccountDetails.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/26/21.
//

import UIKit
import Alamofire

class ManageSubAccountDetailsVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var viewHeader: CloseHeaderView!
    
    @IBOutlet weak var viewAccountTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewPurchaseTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewPurchaseLimitTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewMasterTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewDiscountsTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewProductListTitle: ManageSubAccountTitleView!
    
    @IBOutlet weak var viewRechargeTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewTransLogTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewReportsTitle: ManageSubAccountTitleView!
    @IBOutlet weak var viewSupportCenterTitle: ManageSubAccountTitleView!
    //ACCOUNT UI
    @IBOutlet weak var viewAccountContainer: UIView!
    @IBOutlet weak var viewDicountContainer: UIView!
    @IBOutlet weak var viewRechargeContainer: UIView!
    @IBOutlet weak var viewTransLogContainer: UIView!
    @IBOutlet weak var viewProductListContainer: UIView!
    @IBOutlet weak var viewReportContainer: UIView!
    @IBOutlet weak var viewSupportCenterContainer: UIView!
    @IBOutlet weak var viewSeperator: UIView!
    
    @IBOutlet weak var viewSubType: UIView!
    @IBOutlet weak var viewBalance: UIView!
    @IBOutlet weak var viewPurchaseContainer: UIView!
    
    @IBOutlet weak var viewFullName: ManageSubAccountItemView!
    @IBOutlet weak var viewMobileNumber: ManageSubAccountItemView!
    @IBOutlet weak var viewDesc: ManageSubAccountItemView!
    @IBOutlet weak var viewAccessType: ManageSubAccountItemView!
    @IBOutlet weak var viewRemaining: ManageSubAccountItemView!
    
    @IBOutlet weak var viewRechargeLog: ManageSubRadioView!
    @IBOutlet weak var viewBankTransfere: ManageSubRadioView!
    @IBOutlet weak var viewMada: ManageSubRadioView!
    @IBOutlet weak var ViewCredit: ManageSubRadioView!
    @IBOutlet weak var viewAmex: ManageSubRadioView!
    @IBOutlet weak var viewPaypal: ManageSubRadioView!
    
    
    @IBOutlet weak var viewTransOption1: ManageSubRadioView!
    @IBOutlet weak var viewTransOption2: ManageSubRadioView!
    
    @IBOutlet weak var viewReportOption1: ManageSubRadioView!
    @IBOutlet weak var viewReportOption2: ManageSubRadioView!
    
    @IBOutlet weak var stackPurchace: UIStackView!
    @IBOutlet weak var stackRecharge: UIStackView!
    @IBOutlet weak var stackPurchaceBalance: UIStackView!
    @IBOutlet weak var stackTransactionLog: UIStackView!
    @IBOutlet weak var stackReports: UIStackView!
    @IBOutlet weak var stackTextBalance: UIStackView!
    
    
    @IBOutlet weak var viewLimited: ManageSubAccountPurchaseView!
    @IBOutlet weak var viewPeriodic: ManageSubAccountPurchaseView!
    @IBOutlet weak var ViewUnlimited: ManageSubAccountPurchaseView!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAccessTitle: UILabel!
    @IBOutlet weak var lblPurchaseDesc: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblPurchaseLimitTitle: UILabel!
    @IBOutlet weak var lblRechargeMethod: UILabel!
    @IBOutlet weak var lblTransLogMethod: UILabel!
    @IBOutlet weak var lblReportMethod: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var viewDuration: UIView!
    @IBOutlet weak var imgDuration: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPeriodTitle: UILabel!

    private var subAccount: UserInfo!
    var subAccountData: UserInfo!

    var roundedRadius: CGFloat = 8
    var purchaseLimit: Double = 0
    var currentRemainingValue: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subAccount = DataService.copyObject(user: subAccountData)
//        let _ = print("Noura1= \(subAccount?.Per)")
//        let _ = print("Noura1= \(subAccountData?.subAccountDetailsDTO?.SubResellerType)")
//
//        subAccount.subAccountDetailsDTO?.SubResellerType = SUB_ACCOUNT_TYPE.NO_LIMIT.rawValue
//        let _ = print("Noura2= \(subAccount?.subAccountDetailsDTO?.SubResellerType)")
//        let _ = print("Noura3= \(subAccountData?.subAccountDetailsDTO?.SubResellerType)")

        setupUI()
        setupData()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
    }

    func setupUI(){
        self.viewAccountTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewPurchaseTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewPurchaseLimitTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewMasterTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewRechargeTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewTransLogTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewDiscountsTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewProductListTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewReportsTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        self.viewSupportCenterTitle.switchView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        
        self.viewHeader.showX(manageStrings.manage_account.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        self.txtField.placeholder = manageStrings.amount.localizedValue
        self.txtField.delegate = self
        self.txtField.keyboardType = UIKeyboardType.decimalPad
        txtField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setupAccountUI()
        setupPurchaseUI()
        setupViewDiscounts()
        setupViewRecharge()
        setupTransLogView()
        setupProductListView()
        setupReportsView()
        setupViewSupport()
        
        btnSave.setTitle(manageStrings.save.localizedValue, for: .normal)
        btnSave.setupShadowsWithRound(roundedRadius)
        
        stackPurchace.isHidden = true
        stackRecharge.isHidden = true
        stackTransactionLog.isHidden = true
        stackReports.isHidden = true
        viewDuration.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDuration(_:))))
        viewDuration.isUserInteractionEnabled = true
    }

    @IBAction func onSaveClicked(_ sender: Any) {
        
        let permissionPurchase = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.PURCHASE.rawValue}[0]
        if permissionPurchase.Enabled{
            if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.LIMIT.rawValue || subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue {
                if  (txtField.text == nil || (txtField.text != nil  && txtField.text!.isEmpty)){
                    DataService.ds.showAlert(self, manageStrings.err_enterBalance.localizedValue)
                    return
                }
            }
        }
        
        let permission = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0]
        
        if permission.Enabled{
            if permission.ChildPermissions.filter({$0.Enabled && $0.id != CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue}).count == 0{
                DataService.ds.showAlert(self, manageStrings.errorRechargePermission.localizedValue)
                return
            }
        }
        updateSubAccount()
    }
    func updateSubAccount(){
//        let _ = print("Noura \(   subAccount.PermissionsArr.filter{$0.id == 25}[0].Enabled)")
//        subAccount.PermissionsArr.filter{$0.id == 25}[0].Enabled = false
//        let _ = print("Noura \(   subAccount.PermissionsArr.filter{$0.id == 25}[0].Enabled)")
        self.loaderView.startLoading(manageStrings.saving.localizedValue)
        ManageSubAccountsAPIs.updateSubaAccount(self.subAccount,{
            self.loaderView.stopLoading()
            DataService.ds.showAlert(self, manageStrings.updateSuccessful.localizedValue) {
                NotificationCenter.default.post(name: .reloadSubAccountsList, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                DataService.ds.showAlert(self, err.errorMessage)
            }
        })
    }
    @objc func tapDuration(_ gestureRecognizer: UITapGestureRecognizer) {
        let popOver =   DurationPopupVC(nibName: "DurationPopupVC", bundle: nil);
        popOver.delegate = self
        popOver.modalPresentationStyle = .popover
        popOver.preferredContentSize = CGSize(width: viewDuration.bounds.width + 40, height: 120);
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = viewDuration
        popoverMenuViewController?.sourceRect = CGRect(x: viewDuration.bounds.width / 2,y:  viewDuration.bounds.height,width: 1,height: 1)
        present(popOver, animated: true, completion: nil)
        
    }
    func setupAccountUI(){
        viewAccountContainer.setupShadowsWithRound(roundedRadius)
        viewAccountTitle.lblTitle.text = manageStrings.enable_account.localizedValue
        viewFullName.lblTitle.text =  manageStrings.fullName.localizedValue
        viewMobileNumber.lblTitle.text =  manageStrings.mobileNumber.localizedValue
        viewDesc.lblTitle.text =  manageStrings.description.localizedValue
        viewAccessType.lblTitle.text =  manageStrings.accessType.localizedValue
        viewAccessType.viewDivider.isHidden = true
        viewAccountTitle.switchView.addTarget(self, action: #selector(switchAccountEnabledValueDidChange(_:)), for: .valueChanged)
    }
    
    func setupPurchaseUI(){
        viewPurchaseContainer.setupShadowsWithRound(roundedRadius)
        viewDuration.customBoarderWithRound(to: 5, with: .secondryColor)
        txtField.customBoarderWithRound(to: 5, with: .secondryColor)
        txtField.font = .regularSmall
        
        viewPurchaseTitle.lblTitle.text = manageStrings.purchase.localizedValue
        
        lblPurchaseDesc.text =  manageStrings.canPurchase.localizedValue
        lblAccessTitle.text = manageStrings.accountType.localizedValue
        lblBalance.text =  manageStrings.balance.localizedValue
        lblPurchaseLimitTitle.text = manageStrings.purchaseLimit.localizedValue
        
        lblPeriodTitle.text = manageStrings.period.localizedValue
        viewLimited.lblTitle.text =  manageStrings.limit.localizedValue
        viewLimited.lblValue.text =  manageStrings.amountLimited.localizedValue
        viewLimited.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewLimited.imgDesc.image = UIImage(named: "limited")
        viewLimited.btnView.addTarget(self, action: #selector(selectOnClickLimited), for: .touchUpInside)
        
        viewPeriodic.lblTitle.text =  manageStrings.periodic.localizedValue
        viewPeriodic.lblValue.text =  manageStrings.amountPeriodic.localizedValue
        viewPeriodic.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewPeriodic.imgDesc.image = UIImage(named: "periodic")
        viewPeriodic.btnView.addTarget(self, action: #selector(selectOnClickPeriodic), for: .touchUpInside)
        
        ViewUnlimited.lblTitle.text =  manageStrings.notLimited.localizedValue
        ViewUnlimited.lblValue.text =  manageStrings.amountNotLimited.localizedValue
        ViewUnlimited.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        ViewUnlimited.imgDesc.image = UIImage(named: "unlimited")
        ViewUnlimited.btnView.addTarget(self, action: #selector(selectOnClickUnLimited), for: .touchUpInside)
        
        viewPurchaseLimitTitle.lblTitle.text = manageStrings.viewPurchaseLimit.localizedValue
        viewMasterTitle.lblTitle.text = manageStrings.viewMasterAccount.localizedValue
        viewRemaining.lblTitle.text = manageStrings.currentRemaining.localizedValue
        viewRemaining.setupAction { [weak self] in
            self?.reset()
        }
        viewPurchaseTitle.switchView.addTarget(self, action: #selector(switchPruchaseValueDidChange(_:)), for: .valueChanged)
        viewPurchaseLimitTitle.switchView.addTarget(self, action: #selector(switchPurchaseLimitValueChanged(_:)), for: .valueChanged)
        viewMasterTitle.switchView.addTarget(self, action: #selector(switchMasterValueChanged(_:)), for: .valueChanged)
    }
    
    func setupViewDiscounts(){
        viewDicountContainer.setupShadowsWithRound(roundedRadius)
        viewDiscountsTitle.lblDesc.isHidden = false
        viewDiscountsTitle.lblTitle.text = manageStrings.viewProductDiscounts.localizedValue
        viewDiscountsTitle.lblDesc.text = manageStrings.viewProductDiscountsDetails.localizedValue
        viewDiscountsTitle.switchView.addTarget(self, action: #selector(switchViewDiscountValueChanged(_:)), for: .valueChanged)
    }
    
    func setupViewRecharge(){
        viewRechargeContainer.setupShadowsWithRound(roundedRadius)
        
        lblRechargeMethod.text = manageStrings.rechargingMethod.localizedValue
        
        viewRechargeTitle.lblTitle.text = strings.Recharge.localizedValue
        viewRechargeLog.lblTitle.text =  manageStrings.rechargingLog.localizedValue
        viewBankTransfere.lblTitle.text =  strings.bankTransfer.localizedValue
        viewMada.lblTitle.text =  strings.mada.localizedValue
        ViewCredit.lblTitle.text =  strings.credit.localizedValue
        viewAmex.lblTitle.text =  strings.amex.localizedValue
        viewPaypal.lblTitle.text =  strings.paypal.localizedValue
        
        viewRechargeLog.imgRadio.image = UIImage(named: "ic_checkbox_unchecked")
        viewBankTransfere.imgRadio.image = UIImage(named: "ic_checkbox_unchecked")
        viewMada.imgRadio.image = UIImage(named: "ic_checkbox_unchecked")
        ViewCredit.imgRadio.image = UIImage(named: "ic_checkbox_unchecked")
        viewAmex.imgRadio.image = UIImage(named: "ic_checkbox_unchecked")
        viewPaypal.imgRadio.image = UIImage(named: "ic_checkbox_unchecked")
        
        viewRechargeLog.imgRadio.tintColor = .textColor
        viewBankTransfere.imgRadio.tintColor = .textColor
        viewMada.imgRadio.tintColor = .textColor
        ViewCredit.imgRadio.tintColor = .textColor
        viewAmex.imgRadio.tintColor = .textColor
        viewPaypal.imgRadio.tintColor = .textColor
        
        viewRechargeTitle.switchView.addTarget(self, action: #selector(switchRechageValueChanged(_:)), for: .valueChanged)
        
        viewRechargeLog.tag = 0
        viewBankTransfere.tag = 0
        viewMada.tag = 0
        ViewCredit.tag = 0
        viewAmex.tag = 0
        viewPaypal.tag = 0
        
        viewRechargeLog.btnCheck.addTarget(self, action: #selector(onViewRechargeLogClicked), for: .touchUpInside)
        viewBankTransfere.btnCheck.addTarget(self, action: #selector(onViewBankClicked), for: .touchUpInside)
        viewMada.btnCheck.addTarget(self, action: #selector(onViewMadaClicked), for: .touchUpInside)
        ViewCredit.btnCheck.addTarget(self, action: #selector(onViewCreditClicked), for: .touchUpInside)
        viewAmex.btnCheck.addTarget(self, action: #selector(onViewAmexClicked), for: .touchUpInside)
        viewPaypal.btnCheck.addTarget(self, action: #selector(onViewPayPalClicked), for: .touchUpInside)
    }
    @objc func onViewRechargeLogClicked(){
        viewRechargeLog.tag = viewRechargeLog.tag == 0 ? 1 : 0
        setupRechargeLogView()
    }
    func setupRechargeLogView(){
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue}[0].Enabled = viewRechargeLog.tag == 1
        
        viewRechargeLog.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue}[0].Enabled)
    }
    @objc func onViewBankClicked(){
        viewBankTransfere.tag = viewBankTransfere.tag == 0 ? 1 : 0
        setupViewBank()
    }
    func setupViewBank(){
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.BANK.rawValue}[0].Enabled = viewBankTransfere.tag == 1
        
        viewBankTransfere.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.BANK.rawValue}[0].Enabled)
    }
    @objc func onViewMadaClicked(){
        viewMada.tag = viewMada.tag == 0 ? 1 : 0
        setupMadaView()
    }
    func setupMadaView(){
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.MADA.rawValue}[0].Enabled = viewMada.tag == 1
        
        viewMada.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.MADA.rawValue}[0].Enabled)
    }
    
    @objc func onViewCreditClicked(){
        ViewCredit.tag = ViewCredit.tag == 0 ? 1 : 0
        setupCreditView()
    }
    func setupCreditView(){
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.CREDIT.rawValue}[0].Enabled = ViewCredit.tag == 1
        
        ViewCredit.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.CREDIT.rawValue}[0].Enabled)
    }
    @objc func onViewAmexClicked(){
        viewAmex.tag = viewAmex.tag == 0 ? 1 : 0
        setupAmexView()
    }
    func setupAmexView(){
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.AMEX.rawValue}[0].Enabled = viewAmex.tag == 1
        
        viewAmex.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.AMEX.rawValue}[0].Enabled)
    }
    @objc func onViewPayPalClicked(){
        viewPaypal.tag = viewPaypal.tag == 0 ? 1 : 0
        setupPaypalView()
    }
    func setupPaypalView(){
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.PAYPAL.rawValue}[0].Enabled = viewPaypal.tag == 1
        
        viewPaypal.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.PAYPAL.rawValue}[0].Enabled)
    }
    func setupTransLogView(){
        viewTransLogContainer.setupShadowsWithRound(roundedRadius)
        viewTransLogTitle.lblTitle.text = strings.TransactionLog.localizedValue
        lblTransLogMethod.text = manageStrings.chooseLogType.localizedValue
        
        viewTransOption1.lblTitle.text = manageStrings.transLogOption1.localizedValue
        viewTransOption2.lblTitle.text =  manageStrings.transLogOption2.localizedValue
        
        viewTransOption1.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewTransOption2.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        
        viewTransLogTitle.switchView.addTarget(self, action: #selector(switchTransLogValueChanged(_:)), for: .valueChanged)
        viewTransOption1.tag = 0
        viewTransOption2.tag = 0
        viewTransOption1.btnCheck.addTarget(self, action: #selector(onTransLogOPtion1Clicked), for: .touchUpInside)
        
        viewTransOption2.btnCheck.addTarget(self, action: #selector(onTransLogOPtion2Clicked), for: .touchUpInside)
        
    }
    @objc func onTransLogOPtion1Clicked(){
        if viewTransOption1.tag == 1{
            return
        }
        viewTransOption1.tag = viewTransOption1.tag == 0 ? 1 : 0
        let isEnabled = viewTransOption1.tag == 1
        viewTransOption2.tag = isEnabled ? 0 : 1
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue}[0].Enabled = isEnabled
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ALL_SUB_ACCOUNTS.rawValue}[0].Enabled = !isEnabled
        
        viewTransOption1.setupImage(type: ImageType.Radio.rawValue, isEnabled: isEnabled)
        viewTransOption2.setupImage(type: ImageType.Radio.rawValue, isEnabled: !isEnabled)
        
    }
    
    @objc func onTransLogOPtion2Clicked(){
        if viewTransOption2.tag == 1{
            return
        }
        viewTransOption2.tag = viewTransOption2.tag == 0 ? 1 : 0
        let isEnabled = viewTransOption2.tag == 1
        viewTransOption1.tag = isEnabled ? 0 : 1
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue}[0].Enabled = !isEnabled
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ALL_SUB_ACCOUNTS.rawValue}[0].Enabled = isEnabled
        
        viewTransOption1.setupImage(type: ImageType.Radio.rawValue, isEnabled: !isEnabled)
        viewTransOption2.setupImage(type: ImageType.Radio.rawValue, isEnabled: isEnabled)
        
    }
    
    func setupProductListView(){
        viewProductListContainer.setupShadowsWithRound(roundedRadius)
        viewProductListTitle.lblTitle.text = manageStrings.productDiscountsList.localizedValue
        viewProductListTitle.switchView.addTarget(self, action: #selector(switchViewProductListValueChanged(_:)), for: .valueChanged)
    }
    
    func setupReportsView(){
        viewReportContainer.setupShadowsWithRound(roundedRadius)
        viewReportsTitle.lblTitle.text = accountStrings.more_reports.localizedValue
        lblReportMethod.text = manageStrings.chooseReportTitle.localizedValue
        
        viewReportOption1.lblTitle.text = manageStrings.reportsOption1.localizedValue
        viewReportOption2.lblTitle.text =  manageStrings.reportsOption2.localizedValue
        
        viewReportOption1.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewReportOption2.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        
        viewReportsTitle.switchView.addTarget(self, action: #selector(switchReportsValueChanged(_:)), for: .valueChanged)
        viewReportOption1.tag = 0
        viewReportOption2.tag = 0
        viewReportOption1.btnCheck.addTarget(self, action: #selector(onReportOPtion1Clicked), for: .touchUpInside)
        
        viewReportOption2.btnCheck.addTarget(self, action: #selector(onReportOPtion2Clicked), for: .touchUpInside)
        
    }
    @objc func onReportOPtion1Clicked(){
        if viewReportOption1.tag == 1{
            return
        }
        viewReportOption1.tag = viewReportOption1.tag == 0 ? 1 : 0
        let isEnabled = viewReportOption1.tag == 1
        viewReportOption2.tag = isEnabled ? 0 : 1
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_REPORTS_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue}[0].Enabled = isEnabled
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_REPORTS_PERMISSIONS_IDS.ALL_ACCOUNTS.rawValue}[0].Enabled = !isEnabled
        
        viewReportOption1.setupImage(type: ImageType.Radio.rawValue, isEnabled: isEnabled)
        viewReportOption2.setupImage(type: ImageType.Radio.rawValue, isEnabled: !isEnabled)
        
    }
    
    @objc func onReportOPtion2Clicked(){
        if viewReportOption2.tag == 1{
            return
        }
        viewReportOption2.tag = viewReportOption2.tag == 0 ? 1 : 0
        let isEnabled = viewReportOption2.tag == 1
        viewReportOption1.tag = isEnabled ? 0 : 1
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_REPORTS_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue}[0].Enabled = !isEnabled
        
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_REPORTS_PERMISSIONS_IDS.ALL_ACCOUNTS.rawValue}[0].Enabled = isEnabled
        
        viewReportOption1.setupImage(type: ImageType.Radio.rawValue, isEnabled: !isEnabled)
        viewReportOption2.setupImage(type: ImageType.Radio.rawValue, isEnabled: isEnabled)
        
    }
    func setupViewSupport(){
        viewSupportCenterContainer.setupShadowsWithRound(roundedRadius)
        viewSupportCenterTitle.lblDesc.isHidden = false
        viewSupportCenterTitle.lblTitle.text = accountStrings.more_resellers_support_center.localizedValue
        viewSupportCenterTitle.lblDesc.text = manageStrings.resellerSupportActionDetail.localizedValue
        viewSupportCenterTitle.switchView.addTarget(self, action: #selector(switchSupportValueChanged(_:)), for: .valueChanged)
    }
    
    func setupData(){
        if subAccount != nil{
            if subAccount.AccessType.isEmpty{
                subAccount?.AccessType = ACCESS_TYPE.APPLICATION.rawValue
            }
            self.purchaseLimit = self.subAccount.subAccountDetailsDTO!.Purchaselimit
            self.currentRemainingValue = self.subAccount.subAccountDetailsDTO!.CurrentRemainingLimit
            
            setupAccountDetailsData()
            setupPurchaseData()
            setupRechargeData()
            setupReportsData()
            setupTransLogData()
            setupOthersData()
        }
    }
    
    func setupAccountDetailsData(){
        self.viewAccountTitle.switchView.isOn = !subAccount!.AccountLocked
        self.lblEmail.text = subAccount.Username.isEmpty ? subAccount.email : subAccount.Username
        self.viewFullName.lblValue.text = subAccount.fullName
        self.viewMobileNumber.lblValue.text = subAccount.mobileNumber
        self.viewDesc.lblValue.text = subAccount.subAccountDetailsDTO != nil ? subAccount.subAccountDetailsDTO!.description : ""
        let _ = print("Noura \(ACCESS_TYPE.init(rawValue: subAccount.AccessType)?.title) \(subAccount.AccessType)  000" )
        self.viewAccessType.lblValue.text = ACCESS_TYPE.init(rawValue: subAccount.AccessType)?.title
    }
    
    func setupPurchaseData(){
        viewRemaining.viewReset.isHidden = true
        let purchaseArr = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.PURCHASE.rawValue}
        if purchaseArr.count > 0 && purchaseArr[0].Enabled{
            self.viewPurchaseTitle.switchView.isOn = true
            stackPurchace.isHidden = false
            if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.LIMIT.rawValue{
                setupLimitedSelected()
                if (subAccount.subAccountDetailsDTO!.Purchaselimit > subAccount.subAccountDetailsDTO!.CurrentRemainingLimit){
                    viewRemaining.viewReset.isHidden = false
                }
                txtField.text = "\(formatted: subAccount.subAccountDetailsDTO!.Purchaselimit)"
                viewRemaining.lblValue.text = "\(formatted: subAccount.subAccountDetailsDTO!.CurrentRemainingLimit) \(subAccount.Currency)"
                viewPurchaseLimitTitle.switchView.isOn = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue}[0].Enabled
                txtField.textAlignment = lang == "en" ? .left : .right

            }else if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue{
                setupPeriodicSelected()
                txtField.text = "\(formatted: subAccount.subAccountDetailsDTO!.Purchaselimit)"
                viewRemaining.lblValue.text = "\(formatted: subAccount.subAccountDetailsDTO!.CurrentRemainingLimit) \(subAccount.Currency)"
                lblDuration.text = SUB_DURATION_TYPE.init(rawValue: subAccount.subAccountDetailsDTO!.SubResellerTypeDuration)?.title
                viewPurchaseLimitTitle.switchView.isOn = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue}[0].Enabled
                txtField.textAlignment = lang == "en" ? .left : .right
            }else  if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.NO_LIMIT.rawValue{
                setupUnLimitedSelected()
                let _ = print("Noura VIEW_MASTER_BALANCE=\(subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_MASTER_BALANCE.rawValue}[0].Enabled)")
                self.viewMasterTitle.switchView.isOn = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_MASTER_BALANCE.rawValue}[0].Enabled
                
            }
        }else{
            self.viewPurchaseTitle.switchView.isOn = false
            stackPurchace.isHidden = true
        }
        
    }
    func setupRechargeData(){
        let purchaseArr = subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}
        if purchaseArr.count > 0 && purchaseArr[0].Enabled{
            stackRecharge.isHidden = false
            viewRechargeTitle.switchView.isOn = true
            
            let viewRechargeLogIsEnabled = purchaseArr[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.RECHARGE_LOG.rawValue}[0].Enabled
            viewRechargeLog.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: viewRechargeLogIsEnabled)
            viewRechargeLog.tag = viewRechargeLogIsEnabled ? 1 : 0
            
            let bankIsEnabled = purchaseArr[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.BANK.rawValue}[0].Enabled
            viewBankTransfere.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: bankIsEnabled)
            viewBankTransfere.tag = bankIsEnabled ? 1 : 0
            
            let madaIsEnabled = purchaseArr[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.MADA.rawValue}[0].Enabled
            viewMada.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: madaIsEnabled)
            viewMada.tag = madaIsEnabled ? 1 : 0
            
            let creditIsEnabled = purchaseArr[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.CREDIT.rawValue}[0].Enabled
            ViewCredit.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: creditIsEnabled)
            ViewCredit.tag = creditIsEnabled ? 1 : 0
            
            let amexIsEnabled = purchaseArr[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.AMEX.rawValue}[0].Enabled
            viewAmex.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: amexIsEnabled)
            viewAmex.tag = amexIsEnabled ? 1 : 0
            
            let paypalIsEnabled = purchaseArr[0].ChildPermissions.filter{$0.id == CHILD_RECHARGE_PERMISSIONS_IDS.PAYPAL.rawValue}[0].Enabled
            viewPaypal.setupImage(type: ImageType.CheckBox.rawValue, isEnabled: paypalIsEnabled)
            viewPaypal.tag = paypalIsEnabled ? 1 : 0
            
        }
        
    }
    
    func setupTransLogData(){
        let permission = subAccount.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue})[0]
        if permission.Enabled{
            viewTransLogTitle.switchView.isOn = true
            stackTransactionLog.isHidden = false
            if permission.ChildPermissions.filter({$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue})[0].Enabled{
                viewTransOption1.imgRadio.image = UIImage(named: "ic_radio_checked")
                viewTransOption2.imgRadio.image = UIImage(named: "ic_radio_unchecked")
                viewTransOption1.imgRadio.tintColor = .accentColor
                viewTransOption2.imgRadio.tintColor = .secondryColor
                viewTransOption1.tag = 1
                viewTransOption2.tag = 0
                
            }else{
                viewTransOption1.imgRadio.image = UIImage(named: "ic_radio_unchecked")
                viewTransOption2.imgRadio.image = UIImage(named: "ic_radio_checked")
                viewTransOption1.imgRadio.tintColor = .secondryColor
                viewTransOption2.imgRadio.tintColor = .accentColor
                viewTransOption1.tag = 0
                viewTransOption2.tag = 1
            }
        }
    }
    
    func setupReportsData(){
        let permission = subAccount.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue})[0]
        if permission.Enabled{
            viewReportsTitle.switchView.isOn = true
            stackReports.isHidden = false
            if permission.ChildPermissions.filter({$0.id == CHILD_REPORTS_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue})[0].Enabled{
                viewReportOption1.imgRadio.image = UIImage(named: "ic_radio_checked")
                viewReportOption1.imgRadio.tintColor = .accentColor
                viewReportOption2.imgRadio.image = UIImage(named: "ic_radio_unchecked")
                viewReportOption2.imgRadio.tintColor = .secondryColor
                viewReportOption1.tag = 1
                viewReportOption2.tag = 0
            }else{
                viewReportOption1.imgRadio.image = UIImage(named: "ic_radio_unchecked")
                viewReportOption1.imgRadio.tintColor = .secondryColor
                viewReportOption2.imgRadio.image = UIImage(named: "ic_radio_checked")
                viewReportOption2.imgRadio.tintColor = .accentColor
                viewReportOption1.tag = 0
                viewReportOption2.tag = 1
            }
        }
    }
    func setupOthersData(){
        viewDiscountsTitle.switchView.isOn = subAccount.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})[0].Enabled
        viewProductListTitle.switchView.isOn = subAccount.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_LIST.rawValue})[0].Enabled
        viewSupportCenterTitle.switchView.isOn = subAccount.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_SUPPORT_CENTER.rawValue})[0].Enabled
    }
    
    // MARK: - SETUP BALANCE TYPES
    func setupLimitedSelected(){
        viewLimited.imgRadio.image = UIImage(named: "ic_radio_checked")
        viewLimited.imgRadio.tintColor = .accentColor
        viewLimited.viewContainer.backgroundColor = .bgColor
        
        viewPeriodic.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewPeriodic.imgRadio.tintColor = .secondryColor
        viewPeriodic.viewContainer.backgroundColor = .primary
        
        ViewUnlimited.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        ViewUnlimited.imgRadio.tintColor = .secondryColor
        ViewUnlimited.viewContainer.backgroundColor = .primary
        
        viewDuration.isHidden = true
        lblPeriodTitle.isHidden = true

        showBalance()
        if (subAccount.subAccountDetailsDTO!.Purchaselimit > subAccount.subAccountDetailsDTO!.CurrentRemainingLimit){
            viewRemaining.viewReset.isHidden = false
        }else{
            viewRemaining.viewReset.isHidden = true
        }
    }
    
    func setupPeriodicSelected(){
        viewLimited.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewLimited.imgRadio.tintColor = .secondryColor
        viewLimited.viewContainer.backgroundColor = .primary
        
        viewPeriodic.imgRadio.image = UIImage(named: "ic_radio_checked")
        viewPeriodic.imgRadio.tintColor = .accentColor
        viewPeriodic.viewContainer.backgroundColor = .bgColor
        
        ViewUnlimited.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        ViewUnlimited.imgRadio.tintColor = .secondryColor
        ViewUnlimited.viewContainer.backgroundColor = .primary
        
        viewDuration.isHidden = false
        lblPeriodTitle.isHidden = false

        lblDuration.text = manageStrings.monthly.localizedValue
        showBalance()
    }
    func setupUnLimitedSelected(){
        viewLimited.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewLimited.imgRadio.tintColor = .secondryColor
        viewLimited.viewContainer.backgroundColor = .primary
        
        viewPeriodic.imgRadio.image = UIImage(named: "ic_radio_unchecked")
        viewPeriodic.imgRadio.tintColor = .secondryColor
        viewPeriodic.viewContainer.backgroundColor = .primary
        
        ViewUnlimited.imgRadio.image = UIImage(named: "ic_radio_checked")
        ViewUnlimited.imgRadio.tintColor = .accentColor
        ViewUnlimited.viewContainer.backgroundColor = .bgColor
        lblPeriodTitle.isHidden = true
        hideBalance()
    }
    // MARK: - END SETUP BALANCE TYPES
    func hideBalance(){
        stackPurchaceBalance.isHidden = true
        viewMasterTitle.isHidden = false
        viewSeperator.isHidden = false
        viewMasterTitle.switchView.isOn = true
    }
    
    func showBalance(){
        stackPurchaceBalance.isHidden = false
        viewMasterTitle.isHidden = true
        viewSeperator.isHidden = true
        viewPurchaseLimitTitle.switchView.isOn = true
//        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue}[0].Enabled = true
    }
    
    @objc func selectOnClickLimited(){
        
        subAccount.subAccountDetailsDTO?.SubResellerType = SUB_ACCOUNT_TYPE.LIMIT.rawValue
        subAccount.subAccountDetailsDTO?.SubResellerTypeDuration = SUB_DURATION_TYPE.DAILY.rawValue
        
        txtField.text = "\(formatted: subAccount.subAccountDetailsDTO!.Purchaselimit)"
        viewRemaining.lblValue.text = "\(formatted: subAccount.subAccountDetailsDTO!.CurrentRemainingLimit) \(subAccount.Currency)"
        setupLimitedSelected()
    }
    
    @objc func selectOnClickPeriodic(){
        subAccount.subAccountDetailsDTO?.SubResellerType = SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue
        subAccount.subAccountDetailsDTO?.SubResellerTypeDuration = SUB_DURATION_TYPE.MONTHLY.rawValue
        
        setupPeriodicSelected()
        viewRemaining.viewReset.isHidden = true
    }
    
    @objc func selectOnClickUnLimited(){
        subAccount.subAccountDetailsDTO?.SubResellerType = SUB_ACCOUNT_TYPE.NO_LIMIT.rawValue
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_MASTER_BALANCE.rawValue}[0].Enabled = true
        setupUnLimitedSelected()
        viewRemaining.viewReset.isHidden = true
    }
    // MARK: - handleSwitches
    @objc func switchAccountEnabledValueDidChange(_ sender: UISwitch) {
        subAccount.AccountLocked = !sender.isOn
        print("state = \(sender.isOn) \(subAccount.AccountLocked)")
    }
    
    @objc func switchPruchaseValueDidChange(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.PURCHASE.rawValue}[0].Enabled = sender.isOn
        if sender.isOn{
            self.stackPurchace.isHidden = false
            subAccount.subAccountDetailsDTO?.SubResellerType = SUB_ACCOUNT_TYPE.LIMIT.rawValue
            txtField.text = "\(formatted: subAccount.subAccountDetailsDTO!.Purchaselimit)"
            viewRemaining.lblValue.text = "\(formatted: subAccount.subAccountDetailsDTO!.CurrentRemainingLimit) \(subAccount.Currency)"
            setupLimitedSelected()
        }else{
            self.stackPurchace.isHidden = true
        }
    }
    @objc func switchPurchaseLimitValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue}[0].Enabled = sender.isOn
        let _ = print("Noura \(   subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue}[0].Enabled)")
    }
    @objc func switchMasterValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_MASTER_BALANCE.rawValue}[0].Enabled = sender.isOn
    }
    
    @objc func switchViewDiscountValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue}[0].Enabled = sender.isOn
    }
    @objc func switchRechageValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.RECHARGE.rawValue}[0].Enabled = sender.isOn
        stackRecharge.isHidden = !sender.isOn
        if sender.isOn{
            if subAccount.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.RECHARGE.rawValue})[0].ChildPermissions.count == 7{
                self.viewRechargeLog.tag = 0
                self.viewBankTransfere.tag = 0
                self.viewMada.tag = 0
                self.ViewCredit.tag = 0
                self.viewAmex.tag = 0
                self.viewPaypal.tag = 0
                
                setupRechargeLogView()
                setupViewBank()
                setupMadaView()
                setupCreditView()
                setupAmexView()
                setupPaypalView()
            }
            
        }
    }
    @objc func switchTransLogValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}[0].Enabled = sender.isOn
        stackTransactionLog.isHidden = !sender.isOn
        if sender.isOn{
            subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue}[0].Enabled = true
            setupTransLogData()
        }
    }
    
    @objc func switchViewProductListValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_LIST.rawValue}[0].Enabled = sender.isOn
    }
    @objc func switchReportsValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}[0].Enabled = sender.isOn
        stackReports.isHidden = !sender.isOn
        if sender.isOn{
            subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue}[0].ChildPermissions.filter{$0.id == CHILD_REPORTS_PERMISSIONS_IDS.ACCOUNT_ONLY.rawValue}[0].Enabled = true
            setupReportsData()
        }
    }
    @objc func switchSupportValueChanged(_ sender: UISwitch) {
        subAccount.PermissionsArr.filter{$0.id == PERMISSIONS_IDS.VIEW_SUPPORT_CENTER.rawValue}[0].Enabled = sender.isOn
    }
}

extension ManageSubAccountDetailsVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ManageSubAccountDetailsVC: DurationPopDelegate{
    func onSelect(index: Int) {
        if index == 0{
            subAccount.subAccountDetailsDTO?.SubResellerTypeDuration = SUB_DURATION_TYPE.DAILY.rawValue
            lblDuration.text = manageStrings.daily.localizedValue
        }else if index == 1{
            subAccount.subAccountDetailsDTO?.SubResellerTypeDuration = SUB_DURATION_TYPE.WEEKLY.rawValue
            lblDuration.text = manageStrings.weekly.localizedValue
            
        }else if index == 2{
            subAccount.subAccountDetailsDTO?.SubResellerTypeDuration = SUB_DURATION_TYPE.MONTHLY.rawValue
            lblDuration.text = manageStrings.monthly.localizedValue
            
        }
    }
}
extension ManageSubAccountDetailsVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        let allowedCharacters = CharacterSet(charactersIn:"0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        //let value = allowedCharacters.isSuperset(of: characterSet)
        let dots = text.filter { $0 == "." }
        let value = allowedCharacters.isSuperset(of: characterSet) && (dots.count == 0 || string != ".")
        if(value){
            setBalanceData()
        }
        return value
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setBalanceData()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        setBalanceData()
    }
    func setBalanceData(){
        let text = txtField.text?.replacedArigitsWithEn
        var remainingValue: Double = 0.0
        if text != nil && !text!.isEmpty{
            remainingValue = Double(text!) ?? 0.0
        }
        if remainingValue == purchaseLimit{
            subAccount.subAccountDetailsDTO?.Purchaselimit = self.purchaseLimit
            subAccount.subAccountDetailsDTO?.CurrentRemainingLimit = self.currentRemainingValue
            viewRemaining.lblValue.text = "\(self.currentRemainingValue) \(subAccount.Currency)"
        }else{
            if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.LIMIT.rawValue{
                subAccount.subAccountDetailsDTO?.Purchaselimit = remainingValue
                subAccount.subAccountDetailsDTO?.CurrentRemainingLimit = remainingValue
                viewRemaining.lblValue.text = "\(remainingValue) \(subAccount.Currency)"
            }else if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue{
                let val = remainingValue - subAccount.subAccountDetailsDTO!.PurshaseTotal
                subAccount.subAccountDetailsDTO?.Purchaselimit = remainingValue
                if val > 0{
                    subAccount.subAccountDetailsDTO?.CurrentRemainingLimit = val
                    viewRemaining.lblValue.text = "\(val) \(subAccount.Currency)"
                }else{
                    viewRemaining.lblValue.text = "0 \(subAccount.Currency)"
                    subAccount.subAccountDetailsDTO?.CurrentRemainingLimit = 0
                }
            }
        }
    }
    @objc func textFieldDidChange() {
        setBalanceData()
    }
}

extension ManageSubAccountDetailsVC{
    func updateBalance(){
        subAccount.subAccountDetailsDTO!.CurrentRemainingLimit = subAccount.subAccountDetailsDTO!.Purchaselimit
        txtField.text = "\(formatted: subAccount.subAccountDetailsDTO!.Purchaselimit)"
        viewRemaining.lblValue.text = "\(formatted: subAccount.subAccountDetailsDTO!.CurrentRemainingLimit) \(subAccount.Currency)"
        viewRemaining.viewReset.isHidden = true
    }
    
    func reset(){
        loaderView.startLoading()
        ManageSubAccountsAPIs.resetLimit(id: subAccount.id ?? 0) { [weak self] in
            NotificationCenter.default.post(name: .reloadSubAccountsList, object: nil)
            self?.loaderView.stopLoading()
            self?.updateBalance()
        } _: { [weak self] err in
            self?.loaderView.stopLoading()
            guard let self = self else {return}
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                DataService.ds.showAlert(self, err.errorMessage)
            }
        }

    }
}
