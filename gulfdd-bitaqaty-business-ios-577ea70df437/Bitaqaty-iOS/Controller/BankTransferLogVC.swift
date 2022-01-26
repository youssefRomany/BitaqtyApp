//
//  BankTransferLogVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit

class BankTransferLogVC: UIViewController {
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSelectedStatus: UILabel!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var btnClearFrom: UIButton!
    @IBOutlet weak var btnClearTo: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnExport: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var loader: ErrorView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var viewNoPermission: ViewNoPermission!
    
    var requestLogs: [RequestLog] = [RequestLog]()
    
    var arr =  [btrrStrings.btrr_status_all.localizedValue,
                btrrStrings.btrr_status_pending.localizedValue,
                btrrStrings.btrr_status_accepted.localizedValue,
                btrrStrings.btrr_status_rejected.localizedValue];
    
    var opened: [Int] = []
    var requestBody = RequestLogBody()
    var exportRequestBody = RequestLogBody()
    var isPending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadData()
    }
    
    @IBAction func selectStatus(_ sender: Any) {
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arr = arr
        popOver.preferredContentSize = CGSize(width: lblSelectedStatus.bounds.width, height: height * CGFloat(arr.count))
        popOver.type = 0;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblSelectedStatus
        popoverMenuViewController?.sourceRect = CGRect(x: lblSelectedStatus.bounds.width / 2,y:  lblSelectedStatus.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    
    @IBAction func selectDate(_ btn: UIButton) {
        let vc = DateTimePicker(nibName: "DateTimePicker", bundle: nil)
        if btn.tag == 1 {
            vc.date = requestBody.dateFrom
        }else{
            vc.date = requestBody.dateTo
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
            requestBody.dateFrom = nil
        }else{
            btnClearTo.isHidden = true
            btnTo.setTitle(msgs.to.localizedValue, for: .normal)
            requestBody.dateTo = nil
        }
    }
    
    
    @IBAction func filter(_ sender: UIButton) {
        opened.removeAll()
        requestBody.pageNumber = 1
        loadData()
    }
    
    @IBAction func export(_ sender: UIButton) {
        loader.startLoading()
        BankTransferAPIs.exportBankTransfers(exportRequestBody) { logs in
            self.exportData(logs)
            self.loader.stopLoading()
        } failed: {
            self.loader.stopLoading()
            DataService.ds.ShowToast(msg: manageStrings.error_not_Saved.localizedValue, view: self.view);
        }
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        requestBody.pageNumber += 1
        loadData()
    }
    
}

extension BankTransferLogVC{
    func loadData(){
        viewNoPermission.isHidden = true
        errorView.isHidden = true
        loader.startLoading()
        BankTransferAPIs.loadBankTransfers(requestBody, self)
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: BankTransferLogCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    fileprivate func setupUI() {
        errorView.delegate = self
        viewNoPermission.isHidden = true
        viewHeader.showX(btrrStrings.btrr.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        
        viewStatus.layer.borderWidth = 1
        viewStatus.layer.borderColor = UIColor.lightBorderColor.cgColor
        viewStatus.layer.cornerRadius = 4
        viewStatus.clipsToBounds = true
        
        lblStatus.layer.borderWidth = 1
        lblStatus.layer.borderColor = UIColor.lightBorderColor.cgColor
        lblStatus.text = btrrStrings.btrr_status.localizedValue
        
        lblSelectedStatus.text = btrrStrings.btrr_status_all.localizedValue
        if(isPending){
            lblSelectedStatus.text = btrrStrings.btrr_status_pending.localizedValue
            requestBody.requestStatus = BankTransferStatus.PENDING.rawValue
            isPending = false
        }
        
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
    
    func disableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(0.4)
        self.btnExport.isEnabled = false
    }
    
    func enableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(1)
        self.btnExport.isEnabled = true
    }
    
    func exportData(_ logs: [RequestLog]){
        let fileName = btrrStrings.btrr_file_name.localizedValue
        let path = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        var header = "\(btrrStrings.btrr_export_date.localizedValue),\(btrrStrings.btrr_export_name.localizedValue),\(btrrStrings.btrr_export_bank.localizedValue),\(btrrStrings.btrr_export_amount.localizedValue),\(btrrStrings.btrr_export_transfer_date.localizedValue),\(btrrStrings.btrr_export_status.localizedValue),\(btrrStrings.btrr_export_reason.localizedValue)\n\n"
        for log in logs{
            let date = log.getCreationDate().replacingOccurrences(of: ",", with: " ")
            let name = log.getTransferPersonName().replacingOccurrences(of: ",", with: " ")
            let bankName = log.getCurrentBankName().replacingOccurrences(of: ",", with: " ")
            let amount = log.getAmount().replacingOccurrences(of: ",", with: " ")
            let transferDate = log.getTransferDate().replacingOccurrences(of: ",", with: " ")
            let status = log.getStatusName().replacingOccurrences(of: ",", with: " ")
            let rejectReason = log.getRejectionReason().replacingOccurrences(of: ",", with: " ")
            header = header.appending("\(date),\(name),\(bankName),\(amount),\(transferDate),\(status),\(rejectReason)\n")
        }
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
            DataService.ds.ShowToast(msg: manageStrings.error_not_Saved.localizedValue, view: self.view);
        }
    }
}

extension BankTransferLogVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension BankTransferLogVC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            lblSelectedStatus.text = arr[position]
            switch position {
            case 1:
                requestBody.requestStatus = BankTransferStatus.PENDING.rawValue
            case 2:
                requestBody.requestStatus = BankTransferStatus.ACCEPTED.rawValue
            case 3:
                requestBody.requestStatus = BankTransferStatus.REJECTED.rawValue
            default:
                requestBody.requestStatus = BankTransferStatus.ALL.rawValue
            }
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
        let dateStr = DateUtils.getStrFromDate(date)
        let localizedDate = DateUtils.getLocalizeStrFromDate(date)
        if (type == 1){
            btnClearFrom.isHidden = false
            btnFrom.setTitle(localizedDate , for: .normal)
            requestBody.dateFrom = dateStr
        }else{
            btnClearTo.isHidden = false
            btnTo.setTitle(localizedDate , for: .normal)
            requestBody.dateTo = dateStr
        }
    }
}
extension BankTransferLogVC: OnFinishDelegate{
    func onSuccess(_ logs: [RequestLog]) {
        loader.stopLoading()
        if requestBody.pageNumber == 1 {
            self.requestLogs.removeAll()
        }
        if logs.count > 0 {
            exportRequestBody = requestBody
            enableExport()
            self.requestLogs.append(contentsOf: logs)
            tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.heightConst.constant = self.tableView.contentSize.height
        }else{
            if requestBody.pageNumber == 1 {
                disableExport()
                errorView.showException(error: ErrorMessage(btrrStrings.btrr_no_data.localizedValue, "\(ErrorType.Empty.rawValue)"))
            }
        }
        btnShowMore.isHidden = logs.count < PAGE_SIZE
    }
    
    func onFailed(err: ServiceError) {
        loader.stopLoading()
        if requestBody.pageNumber == 1 {
            switch err {
            case .unauthorized:
                DataService.ds.showAlert(self, errorMsgs.session_ended.localizedValue) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            default:
                if (err.code == API_ERRORS.USER_DID_NOT_HAS_PERMISSION.rawValue){
                    viewNoPermission.isHidden = false
                }else{
                    errorView.showException(error: ErrorMessage(err.errorDescription))
                }
            }
        }
    }
    
    func onSuccess(tag: Int) {
        if let index = opened.firstIndex(where: {$0 == tag}){
            opened.remove(at: index)
        }else{
            opened.append(tag)
        }
        tableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .fade)
        self.tableView.layoutIfNeeded()
        self.heightConst.constant = self.tableView.contentSize.height
    }
}
extension BankTransferLogVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BankTransferLogCell", for: indexPath) as? BankTransferLogCell{
            cell.setupData(requestLogs[indexPath.row])
            cell.btnStatus.tag = indexPath.row
            cell.delegate = self
            if opened.contains(indexPath.row) {
                cell.openRejectionReason()
            }else{
                cell.closeRejectionReason()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension BankTransferLogVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
}

extension BankTransferLogVC: ReloadDataDelegate{
    func reloadData() {
        requestBody.pageNumber = 1
        loadData()
    }
}
