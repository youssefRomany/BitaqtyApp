//
//  ManageSubAccountListVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/26/21.
//

import UIKit

class ManageSubAccountListVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var errorSearchLoader: ErrorView!
    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewShowMore: UIView!
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var btnExport: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    //let refreshControl = UIRefreshControl()
    
    private var pageIndex = 1
    private var searchText = ""
    private var subAccountsList = [UserInfo]()
    private var exportedSubAccountsList = [UserInfo]()

    private var showMore = false
    private var searchStart = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        if SETTINGS.count > 0{
            let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.SEARCH_SUBACCOUNT_KEYWORD_MIN_LENGTH.rawValue}
            if data != nil{
                let value = data!.PropertyValue
                searchStart = Int(value) ?? 3
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListData), name: .reloadSubAccountsList, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setStatusBar(color: .white)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.tableHeightConstraint.constant = newSize.height
            }
        }
    }
    func setupUI(){
        self.viewHeader.showX(accountStrings.more_manage_sub_account.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        loaderView.delegate = self
        searchBar.delegate = self;
        
        self.viewShowMore.isHidden = true
        setupTableView()
        
        viewSearchContainer.round(to: 5)
        viewSearch.round(to: 5)
        btnExport.round(to: 5)
        btnShowMore.drawBorder(.accentColor, 5, 1)
        btnExport.setTitle(manageStrings.export.localizedValue, for: .normal)
        btnShowMore.setTitle(manageStrings.show_more.localizedValue, for: .normal)
        
        self.searchBar.setImage(UIImage(), for: .search, state: .normal)
        self.searchBar.compatibleSearchTextField.backgroundColor = .white
        self.searchBar.compatibleSearchTextField.textColor = .secondryColor
        self.searchBar.compatibleSearchTextField.placeholder = manageStrings.search_hint.localizedValue
        self.searchBar.compatibleSearchTextField.font = .boldSmall
        
        //        refreshControl.attributedTitle = NSAttributedString(string: "")
        //        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        //        if #available(iOS 10.0, *) {
        //            tableView.refreshControl = refreshControl
        //        } else {
        //            tableView.addSubview(refreshControl)
        //        }
       
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadListData(){
        self.pageIndex = 1
        self.reloadData()
    }
    //    @objc func refresh(_ sender: AnyObject) {
    //        self.pageIndex = 1
    //        self.loadData()
    //    }
    @IBAction func exportClicked(_ sender: Any) {
        self.exportData()
    }
    @IBAction func showMoreClicked(_ sender: Any) {
        if showMore{
            pageIndex = pageIndex + 1
            loadData()
        }
    }
    func loadData(){
        errorSearchLoader.isHidden = true
        //        refreshControl.endRefreshing()
        if self.searchText.isEmpty{
            self.loaderView.startLoading()
        }
        ManageSubAccountsAPIs.getSubAccountsList(self.pageIndex, searchText: self.searchText,{ (result) in
            self.loaderView.stopLoading()
            self.errorSearchLoader.stopLoading()
            self.showMore = result.count >= PAGE_SIZE
            self.enableExport()
            if self.pageIndex == 1{
                self.subAccountsList = result
                
            }else{
                self.subAccountsList.append(contentsOf: result)
            }
            self.viewShowMore.isHidden = !self.showMore
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            let _ = print("Noura self.tableView.contentSize.height \(self.tableView.contentSize.height)")
            //self.tableHeightConstraint.constant = self.tableView.contentSize.height
        },{ [self] (err) in
            self.loaderView.stopLoading()
            self.showMore = false
            self.viewShowMore.isHidden = true
            self.errorSearchLoader.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                if pageIndex == 1{
                    self.subAccountsList = []
                    self.tableView.reloadData()
                    disableExport()
                    !searchText.isEmpty ? errorSearchLoader.showException(error: err) : loaderView.showException(error: err)
                }
            }
        })
    }
    func loadExportedData(){
        errorSearchLoader.isHidden = true
        //        refreshControl.endRefreshing()
        if self.searchText.isEmpty{
            self.loaderView.startLoading()
        }
        ManageSubAccountsAPIs.getExportedSubAccountsList(self.pageIndex, searchText: self.searchText,{ (result) in
            self.loaderView.stopLoading()
            self.errorSearchLoader.stopLoading()
            self.enableExport()
            self.exportedSubAccountsList = result
            self.exportData()

        },{ [self] (err) in
            self.loaderView.stopLoading()
            self.showMore = false
            self.viewShowMore.isHidden = true
            self.errorSearchLoader.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                disableExport()
                DataService.ds.showAlert(self, err.errorMessage)
            }
        })
    }

    func disableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(0.4)
        self.btnExport.isEnabled = false
    }
    
    func enableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(1)
        self.btnExport.isEnabled = true
    }
    func exportData(){
        var header = "\(manageStrings.export_user_name.localizedValue), \(manageStrings.export_full_name.localizedValue), \(manageStrings.export_account_type.localizedValue), \(manageStrings.export_status.localizedValue), \(manageStrings.purchaseLimit.localizedValue)\n"
        
        if  self.subAccountsList.count == 0{
            DataService.ds.ShowToast(msg: manageStrings.error_export_data.localizedValue, view: self.view)
            setSCVData(header: header)
            return
        }

        for subAccount in subAccountsList{
            let type = SUB_ACCOUNT_TYPE.init(rawValue:  (subAccount.subAccountDetailsDTO?.SubResellerType)!)!.title
                .replacingOccurrences(of: ",", with: " ")
            var status = manageStrings.disabled.localizedValue
            if (!subAccount.AccountLocked) {
                status =  manageStrings.enabled.localizedValue
            }
            let userName = (subAccount.Username.isEmpty ? subAccount.Email : subAccount.Username)
                .replacingOccurrences(of: ",", with: " ")
            let fullName = subAccount.FullName.replacingOccurrences(of: ",", with: " ")
            let currency = subAccount.Currency.replacingOccurrences(of: ",", with: " ")
            if subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.LIMIT.rawValue || subAccount.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue{
                header = header.appending("\(userName), \(fullName), \(type), \(status), \(subAccount.subAccountDetailsDTO!.Purchaselimit) \(currency)\n")
            }else{
                header = header.appending("\(userName), \(fullName), \(type), \(status), \n")
            }
          
        }
        setSCVData(header: header)
    }
    
    func setSCVData(header: String){
        let fileName = manageStrings.exportefFileName.localizedValue
        let path = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        print("PATH1= \(path)");
        do{
            try header.write(to: path as URL, atomically: true, encoding: .utf8)
            let exportSheet = UIActivityViewController(activityItems: [path] as [Any], applicationActivities: nil)
            exportSheet.completionWithItemsHandler = { (type,completed,items,error) in
                //print("completed. type=\(type) completed=\(completed) items=\(items) error=\(error)")
                //completed. type=nil completed=false items=nil error=nil
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
}

extension ManageSubAccountListVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        tableView.registerCellNib(cellClass: ManageSubAccountCell.self);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 120;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subAccountsList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ManageSubAccountCell", for: indexPath) as? ManageSubAccountCell{
            let row = indexPath.row
            cell.setData(user: subAccountsList[row])
            cell.tag = row
            cell.delegate = self
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

}

extension ManageSubAccountListVC: ReloadDataDelegate{
    func reloadData() {
        self.pageIndex = 1
        self.searchText = ""
        self.searchBar.text = ""
        self.loadData()
    }
}

extension ManageSubAccountListVC: ManageSubAccountDelegate{
    func onManage(index: Int) {
        let vc = ManageSubAccountDetailsVC(nibName: "ManageSubAccountDetailsVC", bundle: nil)
        vc.subAccountData = subAccountsList[index]
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func onTransactionLog(index: Int) {
        let vc = TransactionsLogVC(nibName: "TransactionsLogVC", bundle: nil)
        vc.isMenu = true
        vc.subAccount = subAccountsList[index]
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
extension ManageSubAccountListVC:  UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchBar);    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true);
        search(searchBar);
    }
    
    func search(_ searchBar: UISearchBar){
        errorSearchLoader.isHidden = true
        if(searchBar.text == nil || (searchBar.text?.isEmpty)!){
            let _ = print("Noura HERRERRER")
            self.view.endEditing(true);
            self.searchText = ""
            self.pageIndex = 1
            loadData()
        }else{
            let searchedText = searchBar.text?.lowercased();
            if(!(searchedText?.isEmpty)! && searchedText!.count >= searchStart){
                self.searchText = searchedText!
                self.pageIndex = 1
                self.loadData()
            }
        }
    }
}
extension ManageSubAccountListVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
}
