//
//  TransactionsLogVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/25/21.
//

import Foundation
import XLPagerTabStrip

class TransactionsLogVC: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var errFilterView: ErrorView!
    @IBOutlet weak var viewNoPermission: ViewNoPermission!
    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    
    @IBOutlet weak var viewUsers: UIView!
    @IBOutlet weak var viewSerial: UIView!
    @IBOutlet weak var viewSecret: UIView!
    @IBOutlet weak var viewChannel: UIView!
    @IBOutlet weak var viewPrinted: UIView!
    
    
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblUsersTitle: UILabel!
    @IBOutlet weak var lblSerialTitle: UILabel!
    @IBOutlet weak var lblSecretTitle: UILabel!
    @IBOutlet weak var lblChannelTitle: UILabel!
    @IBOutlet weak var lblPrintedTitle: UILabel!
    
    @IBOutlet weak var lblUsesValue: UILabel!
    @IBOutlet weak var lblChannelValue: UILabel!
    @IBOutlet weak var lblPrintedValue: UILabel!
    
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var lblSerialHint: UILabel!
    @IBOutlet weak var lblPinHint: UILabel!
    
    @IBOutlet weak var txtFSerial: UITextField!
    @IBOutlet weak var txtFSecret: UITextField!
    
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var btnClearFrom: UIButton!
    @IBOutlet weak var btnClearTo: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnExport: UIButton!
    @IBOutlet weak var btnShowMore: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    
    private var pageNumber = 1
    private var arrUsers = [TransactionUser]()
    private var arrLog = [TransactionLog]()
    private var arrChannels = [String]()
    private var arrPrinted = [String]()
    private var exportedLogArr = [TransactionLog]()
    
    private var showMore = false
    private var channel = ""
    private var subaccountId = -1
    private var serialNo = ""
    private var productSecret = ""
    private var printed = ""
    var dateFrom = ""
    var dateTo = ""
    var dateFromD = ""
    var dateToD = ""
    var subAccount: UserInfo? = nil
    var isMenu = false
    var isSubAccount = false
    var isSupport = true
    var isViewDiscount = true
    var isViewRecommendedRetailPrice = false
    var isViewBalance = true
    var viewAllLogs = true
    var isFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewNoPermission.isHidden = true
        
        setupUI()
        setupPermissions()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListData), name: .reloadTransaction, object: nil)
        
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(reloadListDataWithDates), name: .reloadTransactionWithDates, object: nil)
        if isFromHome{
            btnFrom.setTitle(dateFromD, for: .normal)
            btnTo.setTitle(dateToD, for: .normal)
            btnClearFrom.isHidden = false
            btnClearTo.isHidden = false
            pageNumber = 1
            self.getTransactionList()
        }
    }
    @objc func reloadListData(){
        self.pageNumber = 1
        self.reloadData()
    }
    //    @objc func reloadListDataWithDates(notification: NSNotification){
    //        if let dateFrom = notification.userInfo?["DATE_FROM"] as? String, let dateTo =  notification.userInfo?["DATE_TO"] as? String{
    //            if(dateFrom.isNotEmpty && dateTo.isNotEmpty){
    //                self.dateFrom = dateFrom
    //                self.dateTo = dateTo
    //                btnFrom.setTitle(dateFrom, for: .normal)
    //                btnTo.setTitle(dateTo, for: .normal)
    //                btnClearFrom.isHidden = false
    //                btnClearFrom.isHidden = false
    //            }
    //            self.pageNumber = 1
    //            self.reloadData()
    //          }
    //
    //    }
    func setupPermissions(){
        if let user = DataService.getUserData(), user.accountType == Roles.SUB_ACCOUNT.rawValue{
            if user.reseller!.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue})!.Enabled{
                isSubAccount = true
                self.lblUsesValue.text = user.reseller!.Username
                subaccountId = user.reseller!.id!
            }
            isViewDiscount = user.reseller!.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})!.Enabled
            
            isViewRecommendedRetailPrice = user.reseller!.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.RECOMMENDED_RETAIL_PRICE.rawValue})!.Enabled
            
            isSupport = user.reseller!.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_SUPPORT_CENTER.rawValue})!.Enabled
            
            if user.reseller!.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.NO_LIMIT.rawValue{
                if user.reseller!.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_MASTER_BALANCE.rawValue})[0].Enabled{
                    isViewBalance = true
                }else{
                    isViewBalance = false
                }
            }else{
                if user.reseller!.PermissionsArr.filter({$0.id == PERMISSIONS_IDS.VIEW_PURCHASE_LIMIT.rawValue})[0].Enabled{
                    isViewBalance = true
                }else{
                    isViewBalance = false
                }
            }
            
            if  user.reseller!.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue})!.Enabled{
                if user.reseller!.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue})!.ChildPermissions.first(where: {$0.id == CHILD_TRANSACTION_PERMISSIONS_IDS.ALL_SUB_ACCOUNTS.rawValue})!.Enabled{
                    getUsersList()
                }else{
                    self.getTransactionList()
                    viewAllLogs = false
                }
            }
        }else{
            if subAccount != nil{
                subaccountId = subAccount!.id!
            }
            getUsersList()
        }
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        if let parentVC = self.parent as? MainVC {
    //            if(parentVC.dateFrom.isNotEmpty && parentVC.dateTo.isNotEmpty){
    //                self.dateFrom = parentVC.dateFrom
    //                self.dateTo = parentVC.dateTo
    //                btnFrom.setTitle(parentVC.dateFromD, for: .normal)
    //                btnTo.setTitle(parentVC.dateToD, for: .normal)
    //
    //                parentVC.dateFrom = ""
    //                parentVC.dateTo = ""
    //                parentVC.dateFromD = ""
    //                parentVC.dateToD = ""
    //                btnClearFrom.isHidden = false
    //                btnClearTo.isHidden = false
    //                pageNumber = 1
    //                self.getTransactionList()
    //            }
    //        }
    //        //  self.parent?.title = strings.TransactionLog.localizedValue;
    //    }
    //
    func openTransLog(dateFrom: String, dateTo: String, dateFromD: String, dateToD: String){
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        btnFrom.setTitle(dateFromD, for: .normal)
        btnTo.setTitle(dateToD, for: .normal)
        btnClearFrom.isHidden = false
        btnClearTo.isHidden = false
        pageNumber = 1
        self.getTransactionList()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.tableHeightConstraint.constant = newSize.height
            }
        }
    }
    func getSelectedSubAccount(){
        if subAccount != nil{
            for item in arrUsers{
                if item.Id == subaccountId{
                    lblUsesValue.text = item.UserName
                }
            }
        }
    }
    func setupUI(){
        arrChannels.append(TransactionStrings.channer_arr_all.localizedValue)
        arrChannels.append(TransactionStrings.channer_arr_portal.localizedValue)
        arrChannels.append(TransactionStrings.channer_arr_pos.localizedValue)
        arrChannels.append(TransactionStrings.channer_arr_integration.localizedValue)
        arrChannels.append(TransactionStrings.channer_arr_wallet.localizedValue)
        
        arrPrinted.append(TransactionStrings.channer_arr_all.localizedValue)
        arrPrinted.append(TransactionStrings.yes.localizedValue)
        arrPrinted.append(TransactionStrings.no.localizedValue)
        
        btnFrom.setTitle(TransactionStrings.TLogFrom.localizedValue, for: .normal)
        btnTo.setTitle(TransactionStrings.TLogTo.localizedValue, for: .normal)
        
        if isMenu{
            self.viewHeader.showX(strings.TransactionLog.localizedValue){
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            viewHeader.isHidden = true
            headerHeightConstraint.constant = 0
        }
        lblTitle.text = strings.TransactionLog.localizedValue
        setupTableView()
        
        viewUsers.layer.borderWidth = 1
        viewUsers.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewUsers.layer.cornerRadius = 4
        viewUsers.clipsToBounds = true
        
        viewSerial.layer.borderWidth = 1
        viewSerial.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewSerial.layer.cornerRadius = 4
        viewSerial.clipsToBounds = true
        
        viewSecret.layer.borderWidth = 1
        viewSecret.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewSecret.layer.cornerRadius = 4
        viewSecret.clipsToBounds = true
        
        viewChannel.layer.borderWidth = 1
        viewChannel.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewChannel.layer.cornerRadius = 4
        viewChannel.clipsToBounds = true
        
        viewPrinted.layer.borderWidth = 1
        viewPrinted.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewPrinted.layer.cornerRadius = 4
        viewPrinted.clipsToBounds = true
        
        lblUsersTitle.layer.borderWidth = 1
        lblUsersTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblUsersTitle.text = "  \(TransactionStrings.TLogUserName.localizedValue)  "
        
        lblSerialTitle.layer.borderWidth = 1
        lblSerialTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblSerialTitle.text = "  \(TransactionStrings.TLogSerialNo.localizedValue)  "
        txtFSerial.placeholder = "  \(TransactionStrings.TLogSerialNo.localizedValue)  "
        
        
        lblSecretTitle.layer.borderWidth = 1
        lblSecretTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblSecretTitle.text = "  \(TransactionStrings.TLogPin.localizedValue)  "
        txtFSecret.placeholder = "  \(TransactionStrings.TLogPin2.localizedValue)  "
        
        
        lblChannelTitle.layer.borderWidth = 1
        lblChannelTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblChannelTitle.text = "  \(TransactionStrings.TLogChannel.localizedValue)  "
        
        lblPrintedTitle.layer.borderWidth = 1
        lblPrintedTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblPrintedTitle.text = "  \(TransactionStrings.TLogPrinted.localizedValue)  "
        
        lblUsesValue.text = TransactionStrings.channer_arr_all.localizedValue
        lblChannelValue.text = TransactionStrings.channer_arr_all.localizedValue
        lblPrintedValue.text = TransactionStrings.channer_arr_all.localizedValue
        
        
        btnExport.layer.cornerRadius = 4
        btnExport.setTitle(msgs.export.localizedValue, for: .normal)
        
        btnFilter.layer.cornerRadius = 4
        btnFilter.layer.borderColor = UIColor.accentColor.cgColor
        btnFilter.layer.borderWidth = 1
        btnFilter.setTitle(msgs.filter.localizedValue, for: .normal)
        
        btnShowMore.layer.cornerRadius = 4
        btnShowMore.layer.borderColor = UIColor.accentColor.cgColor
        btnShowMore.layer.borderWidth = 1
        btnShowMore.setTitle(msgs.show_more.localizedValue, for: .normal)
        
        lblTitle.textAlignment = lang == "en" ? .left : .right
        lblUsesValue.textAlignment = lang == "en" ? .left : .right
        txtFSerial.textAlignment = lang == "en" ? .left : .right
        txtFSecret.textAlignment = lang == "en" ? .left : .right
        lblPrintedValue.textAlignment = lang == "en" ? .left : .right
        lblChannelValue.textAlignment = lang == "en" ? .left : .right
        lblCurrency.textAlignment = lang == "en" ? .left : .right
        
        lblSerialHint.textAlignment = lang == "en" ? .left : .right
        lblPinHint.textAlignment = lang == "en" ? .left : .right
        var currency = ""
        if let user = DataService.getUserData(), let reseller = user.reseller{
            currency = reseller.Currency
        }
        lblCurrency.text = TransactionStrings.TLogPricesCurrency.localizedValue.replacingOccurrences(of: "[X]", with: currency)
        lblSerialHint.text = TransactionStrings.case_sensitive.localizedValue.replacingOccurrences(of: "[WORD]", with: TransactionStrings.TLogSerialNo.localizedValue)
        
        
        lblPinHint.text = TransactionStrings.case_sensitive.localizedValue.replacingOccurrences(of: "[WORD]", with: TransactionStrings.TLogPin.localizedValue)
        
        //        if lang == "ar"{
        //            lblSerialHint.isHidden = true
        //            lblPinHint.isHidden = true
        //        }else{
        //            lblSerialHint.isHidden = false
        //            lblPinHint.isHidden = false
        //        }
    }
    @IBAction func selectUsers(_ sender: Any) {
        if arrUsers.count == 0{
            return
        }
        arrUsers.map{print("\($0.UserName)")}
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        popOver.popupType = POPUP_TYPE.USERS.rawValue
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        
        popOver.arrUsers = arrUsers
        let heightCount = arrUsers.count + 1
        //        if let user = DataService.getUserData(), user.accountType == Roles.SUB_ACCOUNT.rawValue{
        //            heightCount = arrUsers.count
        //        }
        popOver.preferredContentSize = CGSize(width: lblUsesValue.bounds.width, height: height * CGFloat(heightCount))
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblUsesValue
        popoverMenuViewController?.sourceRect = CGRect(x: lblUsesValue.bounds.width / 2,y:  lblUsesValue.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    @IBAction func selectChannel(_ sender: Any) {
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        popOver.popupType = POPUP_TYPE.CHANNEL.rawValue
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arr = arrChannels
        popOver.preferredContentSize = CGSize(width: lblChannelValue.bounds.width, height: height * CGFloat(arrChannels.count))
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblChannelValue
        popoverMenuViewController?.sourceRect = CGRect(x: lblChannelValue.bounds.width / 2,y:  lblChannelValue.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    
    @IBAction func selectPrinted(_ sender: Any) {
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        popOver.popupType = POPUP_TYPE.PRINTED.rawValue
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arr = arrPrinted
        popOver.preferredContentSize = CGSize(width: lblPrintedValue.bounds.width, height: height * CGFloat(arrPrinted.count))
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblPrintedValue
        popoverMenuViewController?.sourceRect = CGRect(x: lblPrintedValue.bounds.width / 2,y:  lblPrintedValue.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    @IBAction func selectDate(_ btn: UIButton) {
        let vc = DateTimePicker(nibName: "DateTimePicker", bundle: nil)
        if btn.tag == 1 {
            vc.date = self.dateFrom
        }else{
            vc.date = self.dateTo
        }
        vc.type = btn.tag
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func clearDate(_ btn: UIButton) {
        if btn.tag == 1 {
            btnClearFrom.isHidden = true
            btnFrom.setTitle(msgs.from.localizedValue, for: .normal)
            self.dateFrom = ""
        }else{
            btnClearTo.isHidden = true
            btnTo.setTitle(msgs.to.localizedValue, for: .normal)
            self.dateTo = ""
        }
    }
    
    
    @IBAction func filter(_ sender: UIButton) {
        self.pageNumber = 1
        getTransactionList()
    }
    
    @IBAction func export(_ sender: UIButton) {
        getExportedTransactionList()
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        self.pageNumber += 1
        getTransactionList()
    }
    
    func exportData(){
        var header = "\(RechargeStrings.recharginDateTime.localizedValue), \(TransactionStrings.productName.localizedValue), \(TransactionStrings.TLogTransID.localizedValue), \(TransactionStrings.TLogBalance.localizedValue), \(TransactionStrings.TLogCostPrice.localizedValue), \(TransactionStrings.TLogVATAmount.localizedValue), \(TransactionStrings.TLogCostAfter.localizedValue), \(TransactionStrings.TLogSerialNo.localizedValue), \(TransactionStrings.pin.localizedValue), \(TransactionStrings.TLogUserName.localizedValue)\n"
        if(!isViewDiscount){
            header = "\(RechargeStrings.recharginDateTime.localizedValue), \(TransactionStrings.productName.localizedValue), \(TransactionStrings.TLogTransID.localizedValue), \(TransactionStrings.TLogBalance.localizedValue), \(TransactionStrings.TLogSerialNo.localizedValue), \(TransactionStrings.pin.localizedValue), \(TransactionStrings.TLogUserName.localizedValue)\n"
        }
        if(!isViewBalance){
            header = "\(RechargeStrings.recharginDateTime.localizedValue), \(TransactionStrings.productName.localizedValue), \(TransactionStrings.TLogTransID.localizedValue), \(TransactionStrings.TLogCostPrice.localizedValue), \(TransactionStrings.TLogVATAmount.localizedValue), \(TransactionStrings.TLogCostAfter.localizedValue), \(TransactionStrings.TLogSerialNo.localizedValue), \(TransactionStrings.pin.localizedValue), \(TransactionStrings.TLogUserName.localizedValue)\n"
            if(!isViewDiscount){
                header = "\(RechargeStrings.recharginDateTime.localizedValue), \(TransactionStrings.productName.localizedValue), \(TransactionStrings.TLogTransID.localizedValue), \(TransactionStrings.TLogSerialNo.localizedValue), \(TransactionStrings.pin.localizedValue), \(TransactionStrings.TLogUserName.localizedValue)\n"
            }
        }
        
        
        
        
        if  self.exportedLogArr.count == 0{
            DataService.ds.ShowToast(msg: manageStrings.error_export_data.localizedValue, view: self.view)
            setCSVData(header: header)
            return
        }
        
        for item in exportedLogArr{
            let date = item.TransactionDate.replacingOccurrences(of: ",", with: " ")
            let productName = item.ProductName.replacingOccurrences(of: ",", with: " ")
            let transaction = item.TransactionId.replacingOccurrences(of: ",", with: " ")
            let balance = "\(item.Balance) \(item.Currency)".replacingOccurrences(of: ",", with: " ")
            let costPrice = "\(item.Price) \(item.Currency)".replacingOccurrences(of: ",", with: " ")
            let amount = "\(item.VatAmount) \(item.Currency)".replacingOccurrences(of: ",", with: " ")
            let costAfter = "\(item.Total) \(item.Currency)".replacingOccurrences(of: ",", with: " ")
            let serial = item.ProductSerial.replacingOccurrences(of: ",", with: " ")
            let subAccount = item.SubReselleraccount.replacingOccurrences(of: ",", with: " ")
            var details = ""
            if item.ChannelCode == CHANNEL_CODES.WALLET.rawValue{
                details = item.ProductName.replacingOccurrences(of: ",", with: " ")
            }else{
                if(item.ProductUserName.isEmpty){
                    details = item.ProductSecret.replacingOccurrences(of: ",", with: " ")
                }else{
                    let boldText = "\(item.ProductUserNameTitle): "
                    let normalText = item.ProductUserName
                    let boldText2 = "\(item.ProductSecretTitle): "
                    let normalText2 = item.ProductSecret
                    details = "\(boldText) \(normalText) \(boldText2) \(normalText2)".replacingOccurrences(of: ",", with: " ")
                }
            }
            var body = ""
            if isViewBalance{
                body = "\(date), \(productName), \(transaction), \(balance), \(costPrice), \(amount), \(costAfter), \(serial), \(details), \(subAccount) \n"
                if(!isViewDiscount){
                    body = "\(date), \(productName), \(transaction), \(balance), \(serial), \(details), \(subAccount) \n"
                }
            }else{
                body = "\(date), \(productName), \(transaction), \(costPrice), \(amount), \(costAfter), \(serial), \(details), \(subAccount) \n"
                if(!isViewDiscount){
                    body = "\(date), \(productName), \(transaction), \(serial), \(details), \(subAccount) \n"
                }
            }
            header = header.appending(body)
        }
        setCSVData(header: header)
    }
    
    func setCSVData(header: String){
        let fileName = TransactionStrings.exportedTransLogFile.localizedValue
        let path = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        print("PATH1= \(path)");
        
        do{
            try header.write(to: path as URL, atomically: true, encoding: .utf8)
            let exportSheet = UIActivityViewController(activityItems: [path] as [Any], applicationActivities: nil)
            exportSheet.completionWithItemsHandler = { (type,completed,items,error) in
                if completed && type != nil && type!.rawValue == "com.apple.DocumentManagerUICore.SaveToFiles"{
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: path.path) {
                        let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path.path))
                        viewer.delegate = self
                        viewer.presentPreview(animated: true)
                    } else {
                        DataService.ds.ShowToast(msg: manageStrings.error_opening_file.localizedValue, view: self.view);
                    }
                }else{
                    if !completed{
                        DataService.ds.ShowToast(msg: manageStrings.error_not_Saved.localizedValue, view: self.view);
                    }
                }
            }
            self.present(exportSheet, animated: true, completion: {})
            
        }catch{
            print("error")
        }
    }
    func disableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(0.4)
        self.btnExport.isEnabled = false
    }
    
    func enableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(1)
        self.btnExport.isEnabled = true
    }
}
extension TransactionsLogVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}


extension TransactionsLogVC: ReloadDataDelegate{
    
    @objc func reloadData() {
        self.pageNumber = 1
        if self.arrUsers.count == 0 && viewAllLogs{
            self.getUsersList()
        }else{
            self.getTransactionList()
        }
    }
    func getUsersList(){
        self.loaderView.startLoading()
        TransactionLogAPIs.getTransactionUsers({ (result) in
            self.loaderView.stopLoading()
            self.arrUsers = result
            self.getTransactionList()
            self.getSelectedSubAccount()
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                loaderView.showException(error: err)
            }
        })
    }
    func getTransactionList(){
        serialNo = txtFSerial.text!
        productSecret = txtFSecret.text!
        self.loaderView.startLoading()
        self.errFilterView.isHidden = true
        TransactionLogAPIs.getTransactionLog(self.pageNumber, subAccountId: self.subaccountId,serialNo: self.serialNo,secret: self.productSecret, channel: self.channel, dateFrom: self.dateFrom, dateTo: self.dateTo,printed: self.printed,{ (result) in
            self.loaderView.stopLoading()
            self.showMore = result.count >= PAGE_SIZE
            self.enableExport()
            if self.pageNumber == 1{
                self.arrLog = result
                
            }else{
                self.arrLog.append(contentsOf: result)
            }
            self.viewMore.isHidden = !self.showMore
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            //self.tableHeightConstraint.constant = self.tableView.contentSize.height
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == ERROR_CODES.NO_PERMISSION_FOR_TRANSACTION_LOG.rawValue{
                self.viewNoPermission.isHidden = false
            }else{
                self.showMore = false
                self.viewMore.isHidden = true
                if(pageNumber == 1){
                    arrLog = []
                    tableView.reloadData()
                    errFilterView.showException(error: err)
                    disableExport()
                }
            }
        })
    }
    func getExportedTransactionList(){
        self.loaderView.startLoading()
        self.errFilterView.isHidden = true
        TransactionLogAPIs.getExportedTransactionLog(self.pageNumber, subAccountId: self.subaccountId,serialNo: self.serialNo,secret: self.productSecret, channel: self.channel, dateFrom: self.dateFrom, dateTo: self.dateTo,printed: self.printed,{ (result) in
            self.loaderView.stopLoading()
            self.enableExport()
            self.exportedLogArr = result
            self.exportData()
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == ERROR_CODES.NO_PERMISSION_FOR_TRANSACTION_LOG.rawValue{
                self.viewNoPermission.isHidden = false
            }else{
                disableExport()
                DataService.ds.showAlert(self, err.errorMessage)
            }
        })
    }
    
    
}
extension TransactionsLogVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
}

extension TransactionsLogVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension TransactionsLogVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        tableView.registerCellNib(cellClass: TransactionLogCell.self);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        tableView.separatorStyle = .none
        //tableView.allowsSelection = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLog.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionLogCell", for: indexPath) as? TransactionLogCell{
            let row = indexPath.row
            cell.tag = row
            cell.delegate = self
            cell.setData(log: arrLog[row], isHasSupportPermission : isSupport, isHasDiscountPermission: isViewDiscount, isHasViewBalancePermission: isViewBalance, isHasViewRecommendedRetailPrice: isViewRecommendedRetailPrice)
            cell.imgArr.tag = 0
            cell.selectionStyle = .none
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TransactionLogCell{
            if cell.imgArr.tag == 0{
                cell.imgArr.tag = 1
                cell.stackDetailsContainer.isHidden = false
                cell.imgArr.image = UIImage(named: "ic_arrow_up")
            }else{
                cell.imgArr.tag = 0
                cell.stackDetailsContainer.isHidden = true
                cell.imgArr.image = UIImage(named: cell.ic_back)
                
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
extension TransactionsLogVC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            if popType == POPUP_TYPE.USERS.rawValue{
                if position == 0{
                    self.subaccountId = -1
                    self.lblUsesValue.text = TransactionStrings.channer_arr_all.localizedValue
                }else{
                    subaccountId = arrUsers[position - 1].Id
                    self.lblUsesValue.text = arrUsers[position - 1].UserName
                }
                //                if let user = DataService.getUserData(), user.accountType == Roles.SUB_ACCOUNT.rawValue{
                //                    subaccountId = arrUsers[position].Id
                //                    self.lblUsesValue.text = arrUsers[position].UserName
                //                }else{
                //                    if position == 0{
                //                        self.subaccountId = -1
                //                        self.lblUsesValue.text = TransactionStrings.channer_arr_all.localizedValue
                //                    }else{
                //                        subaccountId = arrUsers[position - 1].Id
                //                        self.lblUsesValue.text = arrUsers[position - 1].UserName
                //                    }
                //                }
            }else if popType == POPUP_TYPE.CHANNEL.rawValue{
                if position == 0{
                    self.channel = ""
                    self.lblChannelValue.text = TransactionStrings.channer_arr_all.localizedValue
                }else{
                    let channcelText = arrChannels[position]
                    self.lblChannelValue.text = channcelText
                    if self.lblChannelValue.text == TransactionStrings.channer_arr_pos.localizedValue{
                        self.channel = CHANNEL_CODES.POS.rawValue
                    }else if self.lblChannelValue.text == TransactionStrings.channer_arr_portal.localizedValue{
                        self.channel = CHANNEL_CODES.PORTAL.rawValue
                    }else if self.lblChannelValue.text == TransactionStrings.channer_arr_wallet.localizedValue{
                        self.channel = CHANNEL_CODES.WALLET.rawValue
                    }else if self.lblChannelValue.text == TransactionStrings.channer_arr_integration.localizedValue{
                        self.channel = CHANNEL_CODES.INTEGRATION.rawValue
                    }
                }
            }else if popType == POPUP_TYPE.PRINTED.rawValue{
                if position == 0{
                    self.printed = ""
                    self.lblPrintedValue.text = TransactionStrings.channer_arr_all.localizedValue
                }else{
                    self.printed = position == 1 ? "true" : "false"
                    self.lblPrintedValue.text = arrPrinted[position]
                }
            }
            
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
        let dateStr = DateUtils.getStrFromDate(date)
        let localizedDate = DateUtils.getLocalizeStrFromDate(date)
        if (type == 1){
            btnClearFrom.isHidden = false
            btnFrom.setTitle(localizedDate , for: .normal)
            self.dateFrom = dateStr
        }else{
            btnClearTo.isHidden = false
            btnTo.setTitle(localizedDate , for: .normal)
            self.dateTo = dateStr
        }
    }
}

extension TransactionsLogVC: TransactionLogDelegate{
    func onSupportClicked(index: Int) {
        let vc = SupportCenterVC(nibName: "SupportCenterVC", bundle: nil)
        vc.transactionLog = arrLog[index]
        vc.isMenu = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
