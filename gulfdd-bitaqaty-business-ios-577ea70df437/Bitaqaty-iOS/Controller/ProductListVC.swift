//
//  ProductListVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/25/21.
//

import Foundation
import XLPagerTabStrip

class ProductListVC: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var errFilterView: ErrorView!
    @IBOutlet weak var viewNoPermission: ViewNoPermission!
    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewService: UIView!
    
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var lblCategoryValue: UILabel!
    
    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var lblServiceValue: UILabel!
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnExport: UIButton!
    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    
    private var pageNumber = 1
    private var arrCategories = [Category]()
    private var arrMerchants = [Merchant]()
    private var arrProduct = [Product]()
    private var exportedProductArr = [Product]()
    
    private var showMore = false
    private var categoryId = -1
    private var merchantId = -1
    var isMenu = false
    var hasDiscountPermission = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let user = DataService.getUserData(), let reseller = user.reseller{
            if user.accountType == Roles.SUB_ACCOUNT.rawValue, reseller.PermissionsArr.count > 0{
                if reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})!.Enabled{
                    hasDiscountPermission = true
                }else{
                    hasDiscountPermission = false
                    
                }
            }
        }
        
        loaderView.delegate = self
        errFilterView.delegate = self
        getCategories()
        getProductList()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  self.parent?.title = strings.ProductList.localizedValue;
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
    
    func setupUI(){
        if isMenu{
            self.viewHeader.showX(manageStrings.productDiscountsList.localizedValue){
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            viewHeader.isHidden = true
            viewStatus.isHidden = true
        }
        lblTitle.text = strings.moreProductList.localizedValue
        setupTableView()
        
        viewCategory.layer.borderWidth = 1
        viewCategory.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewCategory.layer.cornerRadius = 4
        viewCategory.clipsToBounds = true
        
        viewService.layer.borderWidth = 1
        viewService.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        viewService.layer.cornerRadius = 4
        viewService.clipsToBounds = true
        
        lblCategoryTitle.layer.borderWidth = 1
        lblCategoryTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblCategoryTitle.text = "  \(productListStrings.category.localizedValue)  "
        
        lblServiceTitle.layer.borderWidth = 1
        lblServiceTitle.layer.borderColor = UIColor.fromString("#D2D2D2").cgColor
        lblServiceTitle.text = "  \(productListStrings.service.localizedValue)  "
        
        lblCategoryValue.text = btrrStrings.btrr_status_all.localizedValue
        lblServiceValue.text = btrrStrings.btrr_status_all.localizedValue
        
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
        lblServiceValue.textAlignment = lang == "en" ? .left : .right
        lblCategoryValue.textAlignment = lang == "en" ? .left : .right
        
    }
    @IBAction func selectCategory(_ sender: Any) {
        if arrCategories.count == 0 {
            return
        }
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        popOver.popupType = POPUP_TYPE.CATEGORIES.rawValue
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arrCategories = arrCategories
        popOver.preferredContentSize = CGSize(width: lblCategoryValue.bounds.width, height: height * CGFloat(arrCategories.count + 1))
        popOver.type = 0;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblCategoryValue
        popoverMenuViewController?.sourceRect = CGRect(x: lblCategoryValue.bounds.width / 2,y:  lblCategoryValue.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    @IBAction func selectService(_ sender: Any) {
        if arrMerchants.count == 0 {
            return
        }
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        popOver.popupType = POPUP_TYPE.SERVICES.rawValue
        
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arrServices = arrMerchants
        popOver.preferredContentSize = CGSize(width: lblServiceValue.bounds.width, height: height * CGFloat(arrMerchants.count + 1))
        popOver.type = 0;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = lblServiceValue
        popoverMenuViewController?.sourceRect = CGRect(x: lblServiceValue.bounds.width / 2,y:  lblServiceValue.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    @IBAction func filter(_ sender: UIButton) {
        self.pageNumber = 1
        getProductList()
    }
    
    @IBAction func export(_ sender: UIButton) {
        self.getExportedProductList()
    }
    
    @IBAction func showMore(_ sender: UIButton) {
        self.pageNumber += 1
        getProductList()
    }
    func disableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(0.4)
        self.btnExport.isEnabled = false
    }
    
    func enableExport(){
        self.btnExport.backgroundColor = UIColor.accentColor.withAlphaComponent(1)
        self.btnExport.isEnabled = true
    }
    func getCategories(){
        self.categoryId = -1
        self.merchantId = -1
        self.loaderView.startLoading()
        ProductListAPIs.getCategories({ (result) in
            self.loaderView.stopLoading()
            self.arrCategories = result
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
    
    func exportData(){
        var header = ""
        if (hasDiscountPermission){
            header = "\(productListStrings.service.localizedValue), \(productListStrings.productName.localizedValue), \(productListStrings.costPrice.localizedValue), \(productListStrings.VAT_Amount.localizedValue), \(productListStrings.costAfterVat.localizedValue)\n"
        }else{
            header = "\(productListStrings.service.localizedValue), \(productListStrings.productName.localizedValue)\n"
        }
        if  self.exportedProductArr.count == 0{
            DataService.ds.ShowToast(msg: manageStrings.error_export_data.localizedValue, view: self.view)
            setCSVData(header: header)
            return
        }
        var currency = ""
        if let user = DataService.getUserData(), let reseller = user.reseller{
            currency = reseller.Currency
        }
        for item in exportedProductArr{
            let service = item.merchantName.replacingOccurrences(of: ",", with: " ")
            let productName = item.name.replacingOccurrences(of: ",", with: " ")
            let costPrice = "\(item.Price) \(currency)".replacingOccurrences(of: ",", with: " ")
            let vat = "\(item.Vat) \(currency)".replacingOccurrences(of: ",", with: " ")
            let vatAfter = "\(item.PriceAfterVat) \(currency)".replacingOccurrences(of: ",", with: " ")
            if (hasDiscountPermission){
                header = header.appending("\(service), \(productName), \(costPrice), \(vat), \(vatAfter)\n")
            }else{
                header = header.appending("\(service), \(productName)\n")
            }
        }
        setCSVData(header: header)
    }
    
    func setCSVData(header: String){
        let fileName = productListStrings.exportedProductListFileName.localizedValue
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
}
extension ProductListVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension ProductListVC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension ProductListVC: ReloadDataDelegate{
    func reloadData() {
        self.pageNumber = 1
        if self.arrCategories.count == 0{
            self.getCategories()
        }else if self.arrMerchants.count == 0 && categoryId != -1{
            self.getMerchants()
        }else{
            self.getProductList()
        }
    }
    func getMerchants(){
        self.loaderView.startLoading()
        ProductListAPIs.getMerchants(self.categoryId, { (result) in
            self.loaderView.stopLoading()
            self.arrMerchants = result
            self.merchantId = -1
            self.lblServiceValue.text = btrrStrings.btrr_status_all.localizedValue
        },{ [self] (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                if err.errorCode == "\(ErrorType.Empty.rawValue)"{
                    self.arrMerchants = []
                    self.merchantId = -1
                    self.lblServiceValue.text = btrrStrings.btrr_status_all.localizedValue
                }else{
                    loaderView.showException(error: err)
                }
            }
        })
    }
    func getProductList(){
        self.errFilterView.isHidden = true
        self.loaderView.startLoading()
        ProductListAPIs.getProductList(pageNumber: self.pageNumber, categoryId: self.categoryId, merchantId: self.merchantId, searchCriteria: "") { (result) in
            self.loaderView.stopLoading()
            self.showMore = result.count >= PAGE_SIZE
            self.enableExport()
            if self.pageNumber == 1{
                self.arrProduct = result
            }else{
                self.arrProduct.append(contentsOf: result)
            }
            self.viewMore.isHidden = !self.showMore
            self.tableView.reloadData()
            //self.tableHeightConstraint.constant = self.tableView.contentSize.height + 200
            self.tableView.layoutIfNeeded()
            
        } _: { (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                if err.errorCode == ERROR_CODES.NO_PERMISSION_FOR_PRODUCT_LIST.rawValue{
                    self.viewNoPermission.isHidden = false
                }else{
                    if self.pageNumber == 1{
                        self.arrProduct = []
                        self.tableView.reloadData()
                        self.disableExport()
                        self.errFilterView.showException(error: err)
                    }else{
                        self.showMore = false
                        self.viewMore.isHidden = true
                    }
                }
            }
        }
    }
    func getExportedProductList(){
        self.errFilterView.isHidden = true
        self.loaderView.startLoading()
        ProductListAPIs.getExportedProductList(pageNumber: self.pageNumber, categoryId: self.categoryId, merchantId: self.merchantId, searchCriteria: "") { (result) in
            self.loaderView.stopLoading()
            self.enableExport()
            self.exportedProductArr = result
            self.exportData()
        } _: { (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else if err.errorCode == ERROR_CODES.NO_PERMISSION_FOR_PRODUCT_LIST.rawValue{
                self.viewNoPermission.isHidden = false
            }else{
                
                DataService.ds.showAlert(self, err.errorMessage)
                self.disableExport()
            }
        }
    }
}

extension ProductListVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        tableView.registerCellNib(cellClass: ProductDiscountListCell.self);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 70;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrProduct.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDiscountListCell", for: indexPath) as? ProductDiscountListCell{
            let row = indexPath.row
            cell.tableView = self.tableView
            cell.setData(product: arrProduct[row], hasDiscountPermission : self.hasDiscountPermission)
            cell.tag = row
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 200
    //    }
}
extension ProductListVC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            if popType == POPUP_TYPE.CATEGORIES.rawValue{
                if position == 0{
                    lblCategoryValue.text = btrrStrings.btrr_status_all.localizedValue
                    self.categoryId = -1
                    self.merchantId = -1
                    self.arrMerchants = []
                    self.lblServiceValue.text = btrrStrings.btrr_status_all.localizedValue
                }else{
                    let item = arrCategories[position - 1]
                    self.lblCategoryValue.text = item.name
                    self.categoryId = item.id
                    self.merchantId = -1
                    getMerchants()
                }
            }else{
                if position == 0{
                    lblServiceValue.text = btrrStrings.btrr_status_all.localizedValue
                    self.merchantId = -1
                }else{
                    let item = arrMerchants[position - 1]
                    lblServiceValue.text = item.name
                    self.merchantId = item.id
                }
            }
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
        
    }
}
extension ProductListVC: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
}
