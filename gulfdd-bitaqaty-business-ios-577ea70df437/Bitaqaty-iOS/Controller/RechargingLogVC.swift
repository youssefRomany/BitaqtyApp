//
//  RechargingLogVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/22/21.
//

import UIKit

class RechargingLogVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var viewNoPermission: ViewNoPermission!

    @IBOutlet weak var lblNoData: LblMediumBoldFont!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var errFilterView: ErrorView!
    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewMore: UIView!
    
    @IBOutlet weak var lblMethodTitle: UILabel!
    @IBOutlet weak var lblMethodValue: UILabel!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var btnClearFrom: UIButton!
    @IBOutlet weak var btnClearTo: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnExport: UIButton!
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    
    private var pageNumber = 1
    private var discriminatorValue = ""
    private var dateFrom = ""
    private var dateTo = ""
    private var arrMethods = [RechargeMethod]()
    private var arrRechargeLog = [RechargingLog]()
    private var exportedRechargeLogArr = [RechargingLog]()
    private var showMore = false
    //    var requestBody = RechargeLogRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewNoPermission.isHidden = true
        setupUI()
        getRechargeMethods()
        loaderView.delegate = self
        errFilterView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
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
    override func viewWillDisappear(_ animated: Bool) {
        self.setStatusBar(color: .white)
    }
    func setupUI(){
        lblNoData.text = errorMsgs.no_data.localizedValue
        self.viewHeader.showX(manageStrings.rechargingLog.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        let img = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
        img?.withTintColor(.gray)
        self.btnClearFrom.setImage(img, for: .normal)
        self.btnClearTo.setImage(img, for: .normal)
        
        setupTableView()
        viewStatus.layer.borderWidth = 1
        viewStatus.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewStatus.layer.cornerRadius = 4
        viewStatus.clipsToBounds = true
        
        lblMethodTitle.layer.borderWidth = 1
        lblMethodTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblMethodTitle.text = "  \(RechargeStrings.rechargingExportMethod.localizedValue)  "
        
        lblMethodValue.text = btrrStrings.btrr_status_all.localizedValue
        
        btnFrom.layer.cornerRadius = 4
        btnFrom.setTitle(msgs.from.localizedValue, for: .normal)
        
        btnTo.layer.cornerRadius = 4
        btnTo.setTitle(msgs.to.localizedValue, for: .normal)
        
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
    }
    
    @IBAction func selectMethod(_ sender: Any) {
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arrMtehods = arrMethods
        popOver.preferredContentSize = CGSize(width: lblMethodValue.bounds.width, height: height * CGFloat(arrMethods.count + 1))
        popOver.type = 0;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblMethodValue
        popoverMenuViewController?.sourceRect = CGRect(x: lblMethodValue.bounds.width / 2,y:  lblMethodValue.bounds.height,width: 1,height: 1);
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
        getRechargeList()
    }
    
    @IBAction func export(_ sender: UIButton) {
        self.getExportedRechargeList()
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        self.pageNumber += 1
        getRechargeList()
    }
    
    func getRechargeMethods(){
        self.loaderView.startLoading()
        RechargingLogsAPIs.getRechargingLogMethods({ (result) in
            
            self.loaderView.stopLoading()
            self.arrMethods = result
            self.getRechargeList()
            
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
    
    func getRechargeList(){
        self.loaderView.startLoading()
        self.errFilterView.isHidden = true
        RechargingLogsAPIs.getRechargeLogList(self.pageNumber, discriminatorValue: self.discriminatorValue, dateFrom: self.dateFrom, dateTo: self.dateTo,{ (result) in
            self.viewNoData.isHidden = true
            self.loaderView.stopLoading()
            self.showMore = result.count >= PAGE_SIZE
            self.enableExport()
            if self.pageNumber == 1{
                self.arrRechargeLog = result
                
            }else{
                self.arrRechargeLog.append(contentsOf: result)
            }
            self.viewMore.isHidden = !self.showMore
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            //self.tableHeightConstraint.constant = self.tableView.contentSize.height
        },{ [self] (err) in
            self.showMore = false
            self.viewMore.isHidden = true
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == ERROR_CODES.ERROR_RECHARGE_LOG_PERMISSION.rawValue{
                self.viewNoPermission.isHidden = false
            }else if err.errorCode == String(ErrorType.Empty.rawValue){
                if(pageNumber == 1){
                    arrRechargeLog = []
                    tableView.reloadData()
                    viewNoData.isHidden = false
//                  errFilterView.showException(error: err)
                    disableExport()
                }
            }else{
                if(pageNumber == 1){
                    arrRechargeLog = []
                    tableView.reloadData()
                  errFilterView.showException(error: err)
                    disableExport()
                }
            }
        })
    }
    
    func getExportedRechargeList(){
        self.loaderView.startLoading()
        self.errFilterView.isHidden = true
        RechargingLogsAPIs.getExportedRechargeLogList(self.pageNumber, discriminatorValue: self.discriminatorValue, dateFrom: self.dateFrom, dateTo: self.dateTo,{ (result) in
            self.loaderView.stopLoading()
            self.enableExport()
            self.exportedRechargeLogArr = result
            self.exportData()

        },{ [self] (err) in
            self.showMore = false
            self.viewMore.isHidden = true
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == ERROR_CODES.ERROR_RECHARGE_LOG_PERMISSION.rawValue{
                self.viewNoPermission.isHidden = false
            }else if err.errorCode == String(ErrorType.Empty.rawValue){
                disableExport()
                DataService.ds.showAlert(self, err.errorMessage)
            }
        })
    }
    func exportData(){
        var header = "\(RechargeStrings.recharginDateTime.localizedValue), \(RechargeStrings.rechargingExportMethod.localizedValue), \(RechargeStrings.recharging_amount.localizedValue), \(RechargeStrings.balance_after.localizedValue), \(RechargeStrings.rechargingReason.localizedValue)\n"
        
        if  self.exportedRechargeLogArr.count == 0{
            DataService.ds.ShowToast(msg: manageStrings.error_export_data.localizedValue, view: self.view)
            setCSVData(header: header)
            return
        }
        
        for item in exportedRechargeLogArr{
            let date = item.RechargeDate.replacingOccurrences(of: ",", with: " ")
            let method = item.ChargingMethod
            let amount = "\(item.Amount) \(item.Currency)"
            let balance = "\(item.BalanceAfter) \(item.Currency)"
            let reason = item.ManualReason
            header = header.appending("\(date), \(method), \(amount), \(balance), \(reason)\n")
        }
        setCSVData(header: header)
    }
    
    func setCSVData(header: String){
        let fileName = RechargeStrings.rechargeLogFileName.localizedValue
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

extension RechargingLogVC: ReloadDataDelegate{
    func reloadData() {
        self.pageNumber = 1
        if self.arrMethods.count == 0{
            self.getRechargeMethods()
        }else{
            self.getRechargeList()
        }
    }
}
extension RechargingLogVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
}
extension RechargingLogVC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            if position == 0{
                lblMethodValue.text = btrrStrings.btrr_status_all.localizedValue
                self.discriminatorValue = ""
            }else{
                let item = arrMethods[position - 1]
                lblMethodValue.text = item.Name
                self.discriminatorValue = item.DiscriminatorValue
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
extension RechargingLogVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension RechargingLogVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        tableView.registerCellNib(cellClass: RechargingLogCell.self);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.estimatedSectionHeaderHeight = 40
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.sectionHeaderHeight = 40
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let _ = print("Noura viewForHeaderInSection")
        let view = ViewHeaderRechargeLog();
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRechargeLog.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RechargingLogCell", for: indexPath) as? RechargingLogCell{
            let row = indexPath.row
            cell.tableView = self.tableView
            cell.setData(log: arrRechargeLog[row])
            cell.tag = row
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
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 40//UITableView.automaticDimension;
    //    }
}
