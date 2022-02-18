//
//  SalesReportVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/23/21.
//

import UIKit
import XLPagerTabStrip

class SalesReportVC: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var viewUserNames: DropDownFilterView!
    @IBOutlet weak var viewCategories: DropDownFilterView!
    @IBOutlet weak var lblMerchantError: LblSmallBoldFont!
    @IBOutlet weak var viewMerchants: DropDownFilterView!
    @IBOutlet weak var lblProductError: LblSmallBoldFont!
    @IBOutlet weak var viewProducts: DropDownFilterView!
    @IBOutlet weak var viewDate: DropDownFilterView!
    @IBOutlet weak var viewChannels: DropDownFilterView!
    @IBOutlet weak var viewDatePicker: DatePickerView!
    @IBOutlet weak var viewShowRecommendedRetailPrice: UIView!
    @IBOutlet weak var lblShowRecommendedRetailPrice: LblSmallRegularFont!
    @IBOutlet weak var imageShowRecommendedRetail: UIImageView!
    @IBOutlet weak var btnFilter: BtnMediumRegularFont!
    @IBOutlet weak var btnExport: BtnMediumRegularFont!
    @IBOutlet weak var viewTransactionsNo: UIView!
    @IBOutlet weak var lblTransactionsNo: UILabel!
    @IBOutlet weak var lblTransactionsNoValue: UILabel!
    @IBOutlet weak var viewCost: UIView!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblCostValue: UILabel!
    @IBOutlet weak var viewRecommendedRetailPrice: UIView!
    @IBOutlet weak var lblRecommendedRetailPrice: UILabel!
    @IBOutlet weak var lblRecommendedRetailPriceValue: UILabel!
    @IBOutlet weak var viewTotalProfit: UIView!
    @IBOutlet weak var lblTotalProfit: UILabel!
    @IBOutlet weak var lblTotalProfitValue: UILabel!
    @IBOutlet weak var stackData: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constHeight: NSLayoutConstraint!
    @IBOutlet weak var viewError: ErrorView!
    @IBOutlet weak var btnMore: BtnMediumRegularFont!
    @IBOutlet weak var loader: ErrorView!
    @IBOutlet weak var viewNoPermission: ViewNoPermission!
    var isMenu = false
    var userNames = [TransactionUser]()
    var categories = [Category]()
    var merchants = [Merchant]()
    var products = [Product]()
    var dates = [reportStrings.this_month.localizedValue,
                 reportStrings.last_month.localizedValue,
                 reportStrings.last_week.localizedValue,
                 reportStrings.yesterday.localizedValue,
                 reportStrings.today.localizedValue,
                 reportStrings.custom_date.localizedValue]
    var channels = [reportStrings.all.localizedValue,
                    reportStrings.portal.localizedValue,
                    reportStrings.pos.localizedValue,
                    reportStrings.integration.localizedValue,
                    reportStrings.wallet.localizedValue]
    var reports = [Report]()
    var reportLog: ReportLog? = nil
    var filterBody = ReportRequestBody()
    var exportBody = ReportRequestBody()
    var searchPeriod: String? = DATE.CURRENT_MONTH.rawValue
    
    var showAllAccounts = false
    var showPrice = false
    var isHasShowRecomendPrice = false
    var isRecomendPriceChecked = false
    var isRessellerBalanceAccount = false
    var user: UserInfo?
    var cellSize: CGFloat = 176
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAllAccounts = DataService.showAllAccounts()
        showPrice = DataService.showCost()
        isHasShowRecomendPrice = DataService.showRecomendPrice()
        isRessellerBalanceAccount = DataService.showRessellerBalanceAccountPrices()
        cellSize = showPrice ? 176 : 155
        user = DataService.getUserData()?.reseller
        if (!showAllAccounts){
            filterBody.subAccountId = user?.id
        }
        setupUI()
        filterBody.searchPeriod = searchPeriod
        loadData()
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
                self.constHeight.constant = newSize.height
            }
        }
    }
    
    @IBAction func filterData(_ sender: UIButton) {
        filterBody.pageNumber = 1
        loadData()
    }
    @IBAction func showMoreData(_ sender: Any) {
        filterBody.pageNumber += 1
        loadData()
    }
    
    @IBAction func showRecomendPriceClicked(_ sender: Any) {
        isRecomendPriceChecked = !isRecomendPriceChecked
        
        handelShowRecomendPriceChanges()
        // close all open table view tabed later
        tableView.reloadData()
    }
    
    @IBAction func export(_ sender: UIButton) {
        loader.startLoading()
        SalesReportAPIs.exportSalesReport(exportBody) { [weak self] log in
            self?.exportData(log)
        } failed: { [weak self] in
            self?.loader.stopLoading()
            if let v = self?.view{
                DataService.ds.ShowToast(msg: manageStrings.error_not_Saved.localizedValue, view: v);
            }
        }
    }
    
}

extension SalesReportVC{
    
    func loadData(){
        viewNoPermission.isHidden = true
        viewError.isHidden = true
        loader.startLoading()
        SalesReportAPIs.generateReport(request: filterBody, self)
    }
    
    func setupUI(){
        lblShowRecommendedRetailPrice.textAlignment = lang == "en" ? .left : .right
        lblTotalProfit.textAlignment = lang == "en" ? .left : .right
        lblRecommendedRetailPrice.textAlignment = lang == "en" ? .left : .right
        lblTotalProfitValue.textAlignment = lang == "en" ? .left : .right
        lblRecommendedRetailPriceValue.textAlignment = lang == "en" ? .left : .right
        lblTransactionsNo.textAlignment = lang == "en" ? .left : .right
        lblTransactionsNoValue.textAlignment = lang == "en" ? .left : .right
        lblCost.textAlignment = lang == "en" ? .left : .right
        lblCostValue.textAlignment = lang == "en" ? .left : .right
        viewNoPermission.isHidden = true
        viewError.delegate = self
        lblMerchantError.text = errorMsgs.select_category.localizedValue
        lblProductError.text = errorMsgs.select_merchant.localizedValue
        if (!isMenu){
            viewStatus.isHidden = true
            viewHeader.isHidden = true
        }else{
            viewStatus.isHidden = false
            viewHeader.isHidden = false
            viewHeader.showX(accountStrings.more_sales_report.localizedValue) { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        viewUserNames.setupData(reportStrings.username.localizedValue, showAllAccounts ? "\(reportStrings.all.localizedValue) " : user?.Username ?? "") {[weak self] in
            if(self?.userNames.isEmpty == true){
                if (self?.showAllAccounts == true){
                    self?.loader.startLoading()
                    SalesReportAPIs.loadUsers(self)
                }else{
                    self?.userNames = [TransactionUser(self?.user?.id, self?.user?.fullName, self?.user?.username)]
                    self?.openDropDownList(0)
                }
            }else{
                self?.openDropDownList(0)
            }
        }
        viewCategories.setupData(reportStrings.category.localizedValue, "\(reportStrings.all.localizedValue) ") {[weak self] in
            if (self?.categories.isEmpty == true){
                self?.loader.startLoading()
                SalesReportAPIs.loadStores(self)
            }else{
                self?.openDropDownList(1)
            }
        }
        viewMerchants.setupData(reportStrings.service.localizedValue, "\(reportStrings.all.localizedValue) ") {[weak self] in
            if let catId = self?.filterBody.categoryId{
                if (self?.merchants.isEmpty == true){
                    self?.loader.startLoading()
                    SalesReportAPIs.loadMerchants(categoryId: catId, self)
                }else{
                    self?.openDropDownList(2)
                }
            }else{
                self?.lblMerchantError.isHidden = false
            }
        }
        viewProducts.setupData(reportStrings.product.localizedValue, "\(reportStrings.all.localizedValue) ") {[weak self] in
            if let catId = self?.filterBody.categoryId, let merchantId = self?.filterBody.merchantId{
                if (self?.products.isEmpty == true){
                    self?.loader.startLoading()
                    SalesReportAPIs.loadProduct(categoryId: catId, merchantId: merchantId, self)
                }else{
                    self?.openDropDownList(3)
                }
            }else{
                self?.lblProductError.isHidden = false
            }
        }
        //TODO NOURA
        var title = reportStrings.this_month.localizedValue
        if searchPeriod == DATE.LAST_MONTH.rawValue{
            title = reportStrings.last_month.localizedValue
        }else if searchPeriod == DATE.LAST_SEVEN_DAYS.rawValue{
            title = reportStrings.last_week.localizedValue
        }else if searchPeriod == DATE.YESTERDAY.rawValue{
            title = reportStrings.yesterday.localizedValue
        }else if searchPeriod == DATE.TODAY.rawValue{
            title = reportStrings.today.localizedValue
        }
        viewDate.setupData(reportStrings.date.localizedValue, title) {[weak self] in
            self?.openDropDownList(4)
        }
        viewChannels.setupData(reportStrings.channel.localizedValue, "\(reportStrings.all.localizedValue) ") {[weak self] in
            self?.openDropDownList(5)
        }
        viewDatePicker.delegate = self
        
        btnExport.layer.cornerRadius = 4
        btnExport.setTitle(msgs.export.localizedValue, for: .normal)
        
        btnFilter.layer.cornerRadius = 4
        btnFilter.layer.borderColor = UIColor.accentColor.cgColor
        btnFilter.layer.borderWidth = 1
        btnFilter.setTitle(msgs.filter.localizedValue, for: .normal)
        
        btnMore.layer.cornerRadius = 4
        btnMore.layer.borderColor = UIColor.accentColor.cgColor
        btnMore.layer.borderWidth = 1
        btnMore.setTitle(msgs.show_more.localizedValue, for: .normal)
        setupTableView()
        viewTransactionsNo.round(to: UIDevice.isPad ? 8 : 4)
        viewCost.round(to: UIDevice.isPad ? 8 : 4)
        viewRecommendedRetailPrice.round(to: UIDevice.isPad ? 8 : 4)
        viewTotalProfit.round(to: UIDevice.isPad ? 8 : 4)
        lblShowRecommendedRetailPrice.text = isRessellerBalanceAccount ? reportStrings.show_sales_in_sub_account_price.localizedValue : reportStrings.show_sales_in_recommended_retail_price.localizedValue
        lblTransactionsNo.text = reportStrings.no_of_transactions.localizedValue
        
        lblCost.text = isRessellerBalanceAccount ? reportStrings.total_cost_price.localizedValue : reportStrings.total_cost_price.localizedValue
        lblRecommendedRetailPrice.text = isRessellerBalanceAccount ? reportStrings.total_sub_account_price.localizedValue : reportStrings.total_recommended_retail_price.localizedValue
        lblTotalProfit.text = isRessellerBalanceAccount ? reportStrings.total_profit.localizedValue : reportStrings.total_expected_profit.localizedValue
        
        if showPrice{
            viewCost.isHidden = false
        }else{
            viewCost.isHidden = true
        }
        
        if isHasShowRecomendPrice {
            viewShowRecommendedRetailPrice.isHidden = false
        }else {
            viewShowRecommendedRetailPrice.isHidden = true
        }
        
        
        if isRecomendPriceChecked {
            viewTotalProfit.isHidden = false
            viewRecommendedRetailPrice.isHidden = false
        }else {
            viewTotalProfit.isHidden = true
            viewRecommendedRetailPrice.isHidden = true
        }
    }
    
    func handelShowRecomendPriceChanges() {
        imageShowRecommendedRetail.image = isRecomendPriceChecked ? UIImage(named: "ic_checkbox_checked") : UIImage(named: "ic_checkbox_unchecked")
        if isRecomendPriceChecked {
            viewTotalProfit.isHidden = false
            viewRecommendedRetailPrice.isHidden = false
        }else {
            viewTotalProfit.isHidden = true
            viewRecommendedRetailPrice.isHidden = true
        }
    }
    
    func setupInfo(){
        lblTransactionsNoValue.text = "\(reportLog?.numberOfTransactions ?? 0)"
        //@Pending
        if showPrice{
            lblCostValue.text = isRessellerBalanceAccount ? "\((reportLog?.transactionsTotalAmount ?? 0.0).removeZerosFromEnd()) \(user?.Currency ?? "")" : "\((reportLog?.transactionsTotalAmount ?? 0.0).removeZerosFromEnd()) \(user?.Currency ?? "")"
        }
        lblRecommendedRetailPriceValue.text = isRessellerBalanceAccount ? "\((reportLog?.totalRecommendedPrice ?? 0.0).removeZerosFromEnd()) \(user?.Currency ?? "")" : "\((reportLog?.totalRecommendedPrice ?? 0.0).removeZerosFromEnd()) \(user?.Currency ?? "")"
        lblTotalProfitValue.text = isRessellerBalanceAccount ? "\((reportLog?.totalExpectedProfit ?? 0.0).removeZerosFromEnd()) \(user?.Currency ?? "")" : "\((reportLog?.totalExpectedProfit ?? 0.0).removeZerosFromEnd()) \(user?.Currency ?? "")"
    }
    
    func openDropDownList(_ type: Int){
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        let sourceView = getSourceView(type: type)
        let arr = getList(type)
        popOver.arr = arr
        popOver.preferredContentSize = CGSize(width: sourceView.bounds.width, height: height * CGFloat(arr.count))
        popOver.type = type;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = CGRect(x: sourceView.bounds.width / 2,y: sourceView.bounds.height ,width: 1,height: 1);
        DispatchQueue.main.async {[weak self] in
            self?.present(popOver,animated: true,completion: nil);
        }
    }
    
    func getList(_ type: Int)->[String]{
        if type == 4{
            return dates
        }else if type == 5 {
            return channels
        }else{
            var arr = [String]()
            switch type {
            case 0:
                if showAllAccounts {
                    arr = ["\(reportStrings.all.localizedValue) "]
                    arr.append(contentsOf: userNames.map({$0.UserName}))
                }else{
                    arr = userNames.map({$0.UserName})
                }
            case 1:
                arr = ["\(reportStrings.all.localizedValue) "]
                arr.append(contentsOf: categories.map({$0.name}))
            case 2:
                arr = ["\(reportStrings.all.localizedValue) "]
                arr.append(contentsOf: merchants.map({$0.name}))
            default:
                arr = ["\(reportStrings.all.localizedValue) "]
                arr.append(contentsOf: products.map({$0.name}))
            }
            return arr
        }
    }
    func getSourceView(type: Int)-> UIButton{
        switch type {
        case 0:
            return viewUserNames.btn
        case 1:
            return viewCategories.btn
        case 2:
            return viewMerchants.btn
        case 3:
            return viewProducts.btn
        case 4:
            return viewDate.btn
        default:
            return viewChannels.btn
        }
    }
    
    func selectDate(_ type: Int) {
        let vc = DateTimePicker(nibName: "DateTimePicker", bundle: nil)
        if type == 1 {
            vc.date = filterBody.customDateFrom
        }else{
            vc.date = filterBody.customDateTo
        }
        vc.type = type
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    func clearDate(_ type: Int) {
        if type == 1 {
            filterBody.customDateFrom = nil
        }else{
            filterBody.customDateTo = nil
        }
    }
}

extension SalesReportVC: DatePickerDelegate{
    func clearFromDate() {
        clearDate(1)
    }
    
    func getFromDate() {
        selectDate(1)
    }
    
    func clearToDate() {
        clearDate(2)
    }
    
    func getToDate() {
        selectDate(2)
    }
}
extension SalesReportVC: OnFinishDelegate{
    func onSuccess(_ users: [TransactionUser]) {
        loader.stopLoading()
        userNames = users
        openDropDownList(0)
    }
    
    func onSuccess(_ categories: [Category]) {
        loader.stopLoading()
        self.categories = categories
        openDropDownList(1)
    }
    
    func onSuccess(_ merchants: [Merchant]) {
        loader.stopLoading()
        self.merchants = merchants
        openDropDownList(2)
    }
    
    func onSuccess(_ products: [Product]) {
        loader.stopLoading()
        self.products = products
        openDropDownList(3)
    }
    
    func onSuccess(_ reportLog: ReportLog) {
        loader.stopLoading()
        self.reportLog = reportLog
        if let logs = reportLog.elements, logs.isNotEmpty{
            exportBody = filterBody
            enableExport()
            if (filterBody.pageNumber == 1){
                reports = logs
            }else{
                reports.append(contentsOf: logs)
            }
            setupInfo()
            self.stackData.isHidden = false
            if (logs.count < PAGE_SIZE){
                btnMore.isHidden = true
            }else{
                btnMore.isHidden = false
            }
            tableView.reloadData()
            self.tableView.layoutIfNeeded()
            print("\(tableView.contentSize.height)")
            if (tableView.contentSize.height >= CGFloat(reports.count) * cellSize){
                constHeight.constant = tableView.contentSize.height
            }else{
                constHeight.constant = CGFloat(reports.count) * cellSize
            }
        }else{
            if (filterBody.pageNumber == 1){
                disableExport()
                stackData.isHidden = true
                viewError.showNoData()
            }else{
                btnMore.isHidden = true;
            }
        }
    }
    
    func onFailed(err: ServiceError) {
        loader.stopLoading()
        btnMore.isHidden = true
        switch err{
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        default:
            DataService.ds.showAlert(self, err.errorDescription)
        }
    }
    
    func onFailed(err: ServiceError, _ tag: Int) {
        loader.stopLoading()
        stackData.isHidden = true
        switch err{
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        default:
            if (filterBody.pageNumber == 1){
                disableExport()
                if (err.code == API_ERRORS.USER_DID_NOT_HAS_PERMISSION.rawValue){
                    viewNoPermission.isHidden = false
                }else{
                    viewError.showException(error: ErrorMessage(err.errorDescription))
                }
            }else{
                DataService.ds.showAlert(self, err.errorDescription)
            }
        }
    }
}
extension SalesReportVC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            let index = position - 1
            switch type {
            case 0:
                if (index >= 0){
                    viewUserNames.lblTitle.text = userNames[index].UserName
                    filterBody.subAccountId = userNames[index].Id
                }else{
                    viewUserNames.lblTitle.text = "\(reportStrings.all.localizedValue) "
                    filterBody.subAccountId = nil
                }
            case 1:
                if (index >= 0){
                    viewCategories.lblTitle.text = categories[index].name
                    filterBody.categoryId = categories[index].id
                }else{
                    viewCategories.lblTitle.text = "\(reportStrings.all.localizedValue) "
                    filterBody.categoryId = nil
                }
                lblMerchantError.isHidden = true
                filterBody.merchantId = nil
                filterBody.productId = nil
                viewMerchants.lblTitle.text = "\(reportStrings.all.localizedValue) "
                viewProducts.lblTitle.text = "\(reportStrings.all.localizedValue) "
                merchants.removeAll()
                products.removeAll()
            case 2:
                if (index >= 0){
                    viewMerchants.lblTitle.text = merchants[index].name
                    filterBody.merchantId = merchants[index].id
                }else{
                    viewMerchants.lblTitle.text = "\(reportStrings.all.localizedValue) "
                    filterBody.merchantId = nil
                }
                lblProductError.isHidden = true
                filterBody.productId = nil
                viewProducts.lblTitle.text = "\(reportStrings.all.localizedValue) "
                products.removeAll()
            case 3:
                if (index >= 0){
                    viewProducts.lblTitle.text = products[index].name
                    filterBody.productId = products[index].id
                }else{
                    viewProducts.lblTitle.text = "\(reportStrings.all.localizedValue) "
                    filterBody.productId = nil
                }
            case 4:
                if (position == dates.count - 1){
                    viewDatePicker.isHidden = false
                }else{
                    viewDatePicker.isHidden = true
                    filterBody.customDateFrom = nil
                    filterBody.customDateTo = nil
                }
                filterBody.searchPeriod = DataService.getDate(from: position)
                viewDate.lblTitle.text = dates[position]
            default:
                viewChannels.lblTitle.text = channels[position]
                filterBody.channel = DataService.getChannel(from: position)
            }
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
        let dateStr = DateUtils.getStrFromDate(date)
        let localizedDate = DateUtils.getLocalizeStrFromDate(date)
        if (type == 1){
            viewDatePicker.setFromDate(localizedDate)
            filterBody.customDateFrom = dateStr
        }else{
            viewDatePicker.setToDate(localizedDate)
            filterBody.customDateTo = dateStr
        }
    }
}

extension SalesReportVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SalesReportVC: UITableViewDelegate,UITableViewDataSource{
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: SalesReportCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = cellSize;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SalesReportCell", for: indexPath) as? SalesReportCell{
            cell.imgArr.isHidden = !(isRecomendPriceChecked)
            cell.viewFullInfo.isHidden = !((cell.imgArr.tag == 1) && isRecomendPriceChecked)
            cell.viewInfo.isHidden = ((cell.imgArr.tag == 1) && isRecomendPriceChecked)
            cell.setupData(with: reports[indexPath.row], showPrice, user?.Currency ?? "", isHasShowRecomendPrice, isRessellerBalanceAccount)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRecomendPriceChecked {
            if let cell = tableView.cellForRow(at: indexPath) as? SalesReportCell{
                if cell.imgArr.tag == 0{
                    cell.imgArr.tag = 1
                    cell.viewFullInfo.isHidden = false
                    cell.viewInfo.isHidden = true
                    cell.imgArr.image = UIImage(named: "ic_arrow_up")
                }else{
                    cell.imgArr.tag = 0
                    cell.viewInfo.isHidden = false
                    cell.viewFullInfo.isHidden = true
                    cell.imgArr.image = UIImage(named: cell.ic_back)
                    
                }
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }

    }

}
extension SalesReportVC: ReloadDataDelegate{
    func reloadData() {
        loadData()
    }
}

extension SalesReportVC{
    func disableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(0.4)
        self.btnExport.isEnabled = false
    }
    
    func enableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(1)
        self.btnExport.isEnabled = true
    }
    
    func exportData(_ log: ReportLog){
        if let reportList = log.elements{
            let fileName = reportStrings.export_file_name.localizedValue
            let path = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
            var header = "\(reportStrings.username.localizedValue),\(reportStrings.service.localizedValue),\(reportStrings.product.localizedValue),\(reportStrings.no_of_transactions.localizedValue)\n\n"
            if (showPrice){
                header = "\(reportStrings.username.localizedValue),\(reportStrings.service.localizedValue),\(reportStrings.product.localizedValue),\(reportStrings.cost_price.localizedValue),\(reportStrings.no_of_transactions.localizedValue),\(reportStrings.total_cost_price.localizedValue)\n\n"
            }
            for report in reportList{
                let sellerName = (report.subAccountName ?? "").replacingOccurrences(of: ",", with: " ")
                let merchantName = report.getMerchantName().replacingOccurrences(of: ",", with: " ")
                let productName = report.getProductName().replacingOccurrences(of: ",", with: " ")
                if (showPrice){
                    header = header.appending("\(sellerName),\(merchantName),\(productName),\(report.price?.removeZerosFromEnd() ?? "") \(user?.Currency ?? ""),\(report.numberOfTrans ?? 0),\(report.totalTransAmount?.removeZerosFromEnd() ?? "") \(user?.Currency ?? "")\n")
                }else{
                    header = header.appending("\(sellerName),\(merchantName),\(productName),\(report.numberOfTrans ?? 0)\n")
                }
            }
            if (showPrice){
                header = header.appending(",,,,\(log.numberOfTransactions),\(log.transactionsTotalAmount?.removeZerosFromEnd() ?? "") \(user?.Currency ?? "")\n")
            }else{
                header = header.appending(",,,\(log.numberOfTransactions),\n")
            }
            do{
                try header.write(to: path as URL, atomically: true, encoding: .utf8)
                self.loader.stopLoading()
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
                self.loader.stopLoading()
                DataService.ds.ShowToast(msg: manageStrings.error_not_Saved.localizedValue, view: self.view);
            }
        }else{
            self.loader.stopLoading()
            DataService.ds.showAlert(self, errorMsgs.no_data.localizedValue)
        }
    }
    
}

extension SalesReportVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
}

extension SalesReportVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
