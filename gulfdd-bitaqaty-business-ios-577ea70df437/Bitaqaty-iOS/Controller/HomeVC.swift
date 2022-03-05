//
//  HomeVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/25/21.
//

import Foundation
import XLPagerTabStrip
import Charts

class HomeVC: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    @IBOutlet weak var viewSales: HomeDailyView!
    @IBOutlet weak var viewRecharge: HomeDailyView!
    
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var viewSubAccountsNoData: ErrorView!
    @IBOutlet weak var viewReportsNoData: ErrorView!
    @IBOutlet weak var viewBankNoData: ErrorView!
    
    
    @IBOutlet weak var lblAccountsTitle: UILabel!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblBankTitle: UILabel!

    @IBOutlet weak var lblSubAccountMenu: UILabel!
    @IBOutlet weak var lblBestSellingMenu: UILabel!
    
    @IBOutlet weak var btnManageAll: UIButton!
    @IBOutlet weak var btnSalesReport: UIButton!
    @IBOutlet weak var btnSubAccount: UIButton!
    @IBOutlet weak var btnTransLog: UIButton!
    @IBOutlet weak var btnBestSalesReport: UIButton!
    @IBOutlet weak var btnBestSellingMenu: UIButton!
    @IBOutlet weak var btnBankRequests: UIButton!
    @IBOutlet weak var btnNewRequest: UIButton!
    
    @IBOutlet weak var tableViewAccounts: UITableView!
    @IBOutlet weak var tableViewBankRequests: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var stackSubAccount: UIStackView!
    @IBOutlet weak var stackChart: UIStackView!
    @IBOutlet weak var stackBank: UIStackView!

    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var tableSubAccountConstraints: NSLayoutConstraint!
    @IBOutlet weak var constraintTableBank: NSLayoutConstraint!
    @IBOutlet weak var constraintCollectionView: NSLayoutConstraint!
    
    
    var dailySales: HomeSales!
    var rechargeSales: HomeSales!
    var subAccountsArr:[HomeSubAccount]!
    var bestSellingProducts:[Report]!
    var bankRequestsArr:[RequestLog]!
    var reportsResult : ReportLog!
    var subASearchPeriod = DATE.CURRENT_MONTH.rawValue
    var bestSellingSearchPeriod = DATE.CURRENT_MONTH.rawValue
    
    var dates = [HomeStrings.home_this_month.localizedValue,
                 HomeStrings.home_last_month.localizedValue,
                 HomeStrings.home_last_week.localizedValue,
                 HomeStrings.home_yesterday.localizedValue,
                 HomeStrings.home_Today.localizedValue]
    
    var colors = [UIColor.fromString("#1F78B4"), UIColor.fromString("#9F2F42"), UIColor.fromString("#747687"), UIColor.fromString("#A8AABC"), UIColor.fromString("#F9F871"), UIColor.fromString("#FFBF61"), UIColor.fromString("#FB9A99"), UIColor.fromString("#FF8978"), UIColor.fromString("#E96597"), UIColor.fromString("#A15AAB")]
    
    var isSubAccountLoaded = false
    var isReportsLoaded = false
    var isBankLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dwehdjwedhwejdhwjedjewdw reseller")

        self.view.backgroundColor = .bgColor
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBankRequests), name: .reloadHomeBankRequests, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHomeRecharge), name: .reloadHomeRecharge, object: nil)
        setupUI()
        getDailySales()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func reloadBankRequests(_ notification: NSNotification) {
        self.getBankRequests()
    }
    @objc private func reloadHomeRecharge(_ notification: NSNotification) {
        self.getDailyRecharge()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableViewAccounts.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.tableViewBankRequests.addObserver(self, forKeyPath: "newContentSize", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.tableSubAccountConstraints.constant = newSize.height
            }
        }else if keyPath == "newContentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.constraintTableBank.constant = newSize.height
            }
        }
    }

    
    func setupUI(){
        loaderView.delegate = self
        viewSales.setupDailySales()
        viewRecharge.setupDailyRecharge()
        
        tableViewAccounts.delegate = self
        tableViewAccounts.dataSource = self
        setupTableView(tableView: self.tableViewAccounts)
        
        tableViewBankRequests.delegate = self
        tableViewBankRequests.dataSource = self
        setupTableView(tableView: self.tableViewBankRequests)

        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionView()
        
        btnManageAll.setTitle(HomeStrings.manage_all.localizedValue, for: .normal)
        btnSalesReport.setTitle(HomeStrings.sales_report.localizedValue, for: .normal)
        btnTransLog.setTitle(strings.TransactionLog.localizedValue, for: .normal)
        btnBestSalesReport.setTitle(HomeStrings.sales_report.localizedValue, for: .normal)
        btnBankRequests.setTitle(HomeStrings.view_all.localizedValue, for: .normal)
        btnNewRequest.setTitle(HomeStrings.newBankTransfere.localizedValue, for: .normal)
        
        lblAccountsTitle.text = HomeStrings.subaccounts.localizedValue
        lblProductTitle.text = HomeStrings.yourTopSelling.localizedValue
        lblBankTitle.text = HomeStrings.bank_transfer_recharging_requests.localizedValue
        lblSubAccountMenu.text = HomeStrings.home_this_month.localizedValue
        lblBestSellingMenu.text =  HomeStrings.home_this_month.localizedValue
        
        btnManageAll.round(to: 2)
        btnSalesReport.round(to: 2)
        
        btnTransLog.round(to: 2)
        btnBestSalesReport.round(to: 2)
        
        btnBankRequests.round(to: 2)
        btnNewRequest.round(to: 2)
        
        lblAccountsTitle.textAlignment = lang == "en" ? .left : .right
        lblProductTitle.textAlignment = lang == "en" ? .left : .right
        lblBankTitle.textAlignment = lang == "en" ? .left : .right
        lblSubAccountMenu.textAlignment = lang == "en" ? .left : .right
        lblBestSellingMenu.textAlignment = lang == "en" ? .left : .right

    }
    @IBAction func onOpenSubAccount(_ sender: Any) {
        openPopUp(type: 0)
    }
    @IBAction func onManageSubClicked(_ sender: Any) {
        let vc = ManageSubAccountListVC(nibName: "ManageSubAccountListVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onViewSalesReportAccount(_ sender: Any) {
        let vc = SalesReportVC(nibName: "SalesReportVC", bundle: nil)
        vc.isMenu = true
        vc.searchPeriod = subASearchPeriod
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onOpenBestSellingMenu(_ sender: Any) {
        openPopUp(type: 1)
    }
    @IBAction func onTransactionClicked(_ sender: Any) {
//        DateUtils.ds.getLastMonth()
        let _ = print("Noura Today=\(Date().toLocalTime())")
        let _ = print("Noura yesterday=\(Date().getYesterday)")
        let _ = print("Noura endOfLastMonth \(Date().endOfLastMonth)")
        let _ = print("Noura getLast7Day \(Date().last7Day)")//check get both +yesterday
        let _ = print("Noura endOfThisMonth= \(Date().startOfMonth)")
        let _ = print("Noura startOfLastMonth =\(Date().startOfLastMonth))")
        let _ = print("Noura startOfThisMonth =\(Date().startOfThisMonth))")

     
        var dateFrom: Date = Date()
        var dateTo: Date = Date()
        
//
//        Noura Today=2021-10-13 10:12:25 +0000
//        Noura yesterday=2021-10-12 10:12:25 +0000
//        Noura endOfLastMonth 2021-10-01 01:59:59 +0000
//        Noura getLast7Day 2021-10-06 10:12:25 +0000
//        Noura endOfThisMonth= 2021-10-01 00:00:00 +0000
//        Noura startOfLastMonth =2021-09-01 00:00:00 +0000)
//        Noura startOfThisMonth =2021-10-01 00:00:00 +0000)
//
        var isLastSplit = false
        if bestSellingSearchPeriod == DATE.CURRENT_MONTH.rawValue{
            dateFrom = Date().startOfThisMonth
            dateTo =  Date()
        }else if bestSellingSearchPeriod == DATE.LAST_MONTH.rawValue{
            dateFrom = Date().startOfLastMonth
            dateTo =  Date().endOfLastMonth
            isLastSplit = true
        }else if bestSellingSearchPeriod == DATE.LAST_SEVEN_DAYS.rawValue{
            dateFrom = Date().last7Day.startOfDay
            dateTo =  Date().getYesterday
        }else if bestSellingSearchPeriod == DATE.YESTERDAY.rawValue{
            dateFrom = Date().getYesterday.startOfDay
            dateTo =  Date().getYesterday
        }else if bestSellingSearchPeriod == DATE.TODAY.rawValue{
            dateFrom = Date().startOfDay
            dateTo =  Date()
        }
        
        let dateFromStr = DateUtils.getLocalizeStrFromDate(dateFrom)
        let dateToStr = DateUtils.getLocalizeStrFromDate(dateTo)
        
        let dateFromStr1 = DateUtils.getStrFromDate(dateFrom)
        let dateToStr1 = DateUtils.getStrFromDate(dateTo)
        
//        if let parentVC = self.parent {
//            if let parentVC = parentVC as? MainVC {
//                parentVC.moveTransLog(dateFrom: dateFromStr1, dateTo: dateToStr1 ,dateFromD: dateFromStr, dateToD: dateToStr)
//            }
//        }
        let vc = TransactionsLogVC(nibName: "TransactionsLogVC", bundle: nil)
        vc.isMenu = true
        vc.isFromHome = true
        vc.dateFrom = dateFromStr1
        vc.dateTo = dateToStr1
        vc.dateFromD = dateFromStr
        vc.dateToD = dateToStr
        vc.modalPresentationStyle = .overFullScreen
//        vc.openTransLog(dateFrom: dateFromStr1, dateTo: dateToStr1 ,dateFromD: dateFromStr, dateToD: dateToStr)
        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func onViewSalesReportBestSelling(_ sender: Any) {
        let vc = SalesReportVC(nibName: "SalesReportVC", bundle: nil)
        vc.isMenu = true
        vc.searchPeriod = bestSellingSearchPeriod
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onViewAllTransfers(_ sender: Any) {
        let vc = BankTransferLogVC(nibName: "BankTransferLogVC", bundle: nil)
        vc.isPending = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func onNewTransfer(_ sender: Any) {
        let vc = BankTransferVC(nibName: "BankTransferVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func openPopUp(type: Int){
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        let sourceView = type == 0 ? btnSubAccount : btnBestSellingMenu
        let arr = dates
        popOver.arr = arr
        popOver.preferredContentSize = CGSize(width: sourceView!.bounds.width, height: height * CGFloat(arr.count))
        popOver.type = type;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = CGRect(x: sourceView!.bounds.width / 2,y: sourceView!.bounds.height ,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    func drawReportPieChart(){
        var currency = ""
        if let user = DataService.getUserData(), user.reseller != nil{
            currency = user.reseller!.Currency
        }
        var entries = [PieChartDataEntry]()
        
        for item in bestSellingProducts{
            let entry = PieChartDataEntry()
            entry.y = item.getPercentage()
            entries.append(entry)
        }
        
        let set = PieChartDataSet( entries: entries, label: "")
        set.colors = colors
        set.highlightEnabled = true
    
        let data = PieChartData(dataSet: set)
        data.setValueTextColor(.clear)
        pieChart.data = data
        pieChart.noDataText = ""
        pieChart.isUserInteractionEnabled = false
        pieChart.chartDescription = nil
        pieChart.holeRadiusPercent = 0.8
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.legend.enabled = false
        let centerText = "\(formatted: reportsResult.transactionsTotalAmount!) \(currency)"
        let attriString = NSMutableAttributedString(string: centerText, attributes:
                                                        [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                         NSAttributedString.Key.font: UIFont.boldMedium])
        
        let attriString1 = NSAttributedString(string: "\n\(HomeStrings.total_Sales.localizedValue)", attributes:
                                                [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                 NSAttributedString.Key.font: UIFont.lightMedium])
        attriString.append(attriString1)
        pieChart.centerAttributedText = attriString
        pieChart.entryLabelColor = .clear
        pieChart.highlightValue(x: 0, dataSetIndex: 0)
    }
}

extension HomeVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}


extension HomeVC: ReloadDataDelegate{
    
    func reloadData() {
        if self.dailySales == nil{
            getDailySales()
        }else if self.rechargeSales == nil{
            self.getDailyRecharge()
        }else if !isSubAccountLoaded{
            self.getSubAccounts()
        }else if !isReportsLoaded{
            self.getHomeReports()
        }else if !isBankLoaded{
            self.getBankRequests()
        }
    }
    
    func getDailySales(){
        self.loaderView.startLoading()
        ResellerHomeAPIs.getDailySales( { (result) in
            self.dailySales = result
            self.viewSales.setupSalesData(data: result)
            self.getDailyRecharge()
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == String(ErrorType.Network.rawValue){
                loaderView.showInternetOff()
            }else{
                loaderView.showException(error: err)
            }
        })
    }
    func getDailyRecharge(){
        ResellerHomeAPIs.getDailyRecharge( { (result) in
            //self.loaderView.stopLoading()
            self.rechargeSales = result
            self.viewRecharge.setupRechargeData(data: result)
            self.getSubAccounts()
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == String(ErrorType.Network.rawValue){
                loaderView.showInternetOff()
            }else{
                loaderView.showException(error: err)
            }
        })
    }
    func getSubAccounts(){
        ResellerHomeAPIs.getHomeSubAccounts(searchPeriod: self.subASearchPeriod ,{ [self] (result) in
            self.viewSubAccountsNoData.isHidden = true
            self.subAccountsArr = result
            self.isSubAccountLoaded = true
            self.stackSubAccount.isHidden = false
            self.tableViewAccounts.reloadData()
            self.loaderView.stopLoading()
            if !self.isReportsLoaded{
                self.getHomeReports()
            }
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == String(ErrorType.Network.rawValue){
                loaderView.showInternetOff()
            }else if err.errorCode == String(ErrorType.Empty.rawValue){
                self.isSubAccountLoaded = true
                stackSubAccount.isHidden = true
                viewSubAccountsNoData.showException(error: ErrorMessage(errorMsgs.no_data.localizedValue))
                if !self.isReportsLoaded{
                    self.getHomeReports()
                }
            }else{
                loaderView.showException(error: err)
            }
        })
    }
    func getHomeReports(){
        ResellerHomeAPIs.getResellerReports(searchPeriod: self.bestSellingSearchPeriod ,{ [self] (result) in
            self.viewReportsNoData.isHidden = true
            self.reportsResult = result
            self.bestSellingProducts = result.elements!
            self.isReportsLoaded = true
            self.stackChart.isHidden = false
            self.collectionView.reloadData()
      
            var count = self.bestSellingProducts.count / 2
            let _ = print("Noura COUNT = \(count)")
            if self.bestSellingProducts.count % 2 == 1{
                count += 1
            }
            constraintCollectionView.constant = CGFloat(50 * count)
            let _ = print("Noura collectionView.contentSize.height = \(constraintCollectionView.constant) count\(count)")
            self.drawReportPieChart()
            self.loaderView.stopLoading()
            
            if !self.isBankLoaded{
                self.getBankRequests()
            }
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == String(ErrorType.Network.rawValue){
                loaderView.showInternetOff()
            }else if err.errorCode == String(ErrorType.Empty.rawValue){
                self.isReportsLoaded = true
                stackChart.isHidden = true
                viewReportsNoData.showException(error: ErrorMessage(errorMsgs.no_data.localizedValue))
                if !self.isBankLoaded{
                    self.getBankRequests()
                }
            }else{
                loaderView.showException(error: err)
            }
        })
        
    }
    func getBankRequests(){
        ResellerHomeAPIs.getBankRequests( { (result) in
            self.loaderView.stopLoading()
            self.bankRequestsArr = result
            self.stackBank.isHidden = false
            self.viewBankNoData.isHidden = true
            self.tableViewBankRequests.reloadData()
            self.tableViewBankRequests.layoutIfNeeded()
            self.constraintTableBank.constant = self.tableViewBankRequests.contentSize.height
            self.isBankLoaded = true
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == String(ErrorType.Network.rawValue){
                loaderView.showInternetOff()
            }else if err.errorCode == String(ErrorType.Empty.rawValue){
                self.isBankLoaded = true
                stackBank.isHidden = true
                viewBankNoData.showException(error: ErrorMessage(errorMsgs.no_data.localizedValue))
            }else{
                loaderView.showException(error: err)
            }
        })
    }
}
extension HomeVC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            let searchPeriodText = dates[position]
            var searchPeriod = DATE.CURRENT_MONTH.rawValue
            if position == 1{
                searchPeriod = DATE.LAST_MONTH.rawValue
            }else if position == 2{
                searchPeriod = DATE.LAST_SEVEN_DAYS.rawValue
            }else if position == 3{
                searchPeriod = DATE.YESTERDAY.rawValue
            }else if position == 4{
                searchPeriod = DATE.TODAY.rawValue
            }
            if type == 0{
                lblSubAccountMenu.text = searchPeriodText
                self.subASearchPeriod = searchPeriod
                getSubAccounts()
            }else if type == 1{
                lblBestSellingMenu.text = searchPeriodText
                self.bestSellingSearchPeriod = searchPeriod
                getHomeReports()
            }
            
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
        
    }
}

extension HomeVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension HomeVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(tableView: UITableView){
        if tableView == tableViewAccounts{
            tableView.registerCellNib(cellClass: HomeSubAccountCell.self);
        }else if tableView == tableViewBankRequests {
            tableView.registerCellNib(cellClass: HomeBankRequestCell.self);
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewAccounts{
            return self.subAccountsArr != nil ? self.subAccountsArr.count : 0
        }else if tableView == tableViewBankRequests{
            return self.bankRequestsArr != nil ? self.bankRequestsArr.count : 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewAccounts{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSubAccountCell", for: indexPath) as? HomeSubAccountCell{
                let row = indexPath.row
                cell.setData(data: subAccountsArr[row])
                cell.tag = row
                return cell;
            }
        }else if tableView == tableViewBankRequests{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeBankRequestCell", for: indexPath) as? HomeBankRequestCell{
                let row = indexPath.row
                cell.setData(bankRequestsArr[row])
                cell.tag = row
                return cell;
            }
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomeBestSellingCell", bundle: nil), forCellWithReuseIdentifier: "HomeBestSellingCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let noOfCellsInRow = 2;
        let width = (UIScreen.main.bounds.size.width - 60) / CGFloat(noOfCellsInRow);
        layout.itemSize = CGSize(width: CGFloat(width), height: 50);
        layout.scrollDirection = .vertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        collectionView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)->Int{
        return self.bestSellingProducts != nil ?  self.bestSellingProducts.count : 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)->UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBestSellingCell", for: indexPath) as? HomeBestSellingCell{
            let row = indexPath.row
            cell.tag = row
            cell.setData(bestSellingProducts[row], color: self.colors[row])
            return cell;
        }
        return UICollectionViewCell();
    }
    
}
