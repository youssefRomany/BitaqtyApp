//
//  PurchaseSuccessVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class PurchaseSuccessVC: UIViewController {
    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPurchaseDate: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var stackPurchaseInfo: UIStackView!
    @IBOutlet weak var lblSuccess: UILabel!
    @IBOutlet weak var stackPrice: UIStackView!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductPriceValue: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblQtyValue: UILabel!
    @IBOutlet weak var stackTotalCost: UIStackView!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblTotalCostValue: UILabel!
    @IBOutlet weak var stackVat: UIStackView!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblVatValue: UILabel!
    @IBOutlet weak var stackTotalWithVat: UIStackView!
    @IBOutlet weak var lblTotalCostWithVat: UILabel!
    @IBOutlet weak var lblTotalCostWithVatValue: UILabel!
    @IBOutlet weak var lblSerial: UILabel!
    @IBOutlet weak var lblSerialValue: UILabel!
    @IBOutlet weak var stackUserName: UIStackView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserNameValue: UILabel!
    @IBOutlet weak var lblSecret: UILabel!
    @IBOutlet weak var lblSecretValue: UILabel!
    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var lblRadioShare: LblMediumRegularFont!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // retailPrice
    
    @IBOutlet weak var retailPriceStackView: UIStackView!
    
    @IBOutlet weak var recRetalPriceLabel: LblSmallBoldFont!
    @IBOutlet weak var tRRetPriceLabel: LblSmallBoldFont!
    @IBOutlet weak var recVatLabel: LblSmallBoldFont!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var retailPriceValueLabel: LblSmallRegularFont!
    @IBOutlet weak var totalRetailPriceValueLabel: LblSmallRegularFont!
    @IBOutlet weak var retailVatPriceValueLabel: LblSmallRegularFont!

    
    var product: Product?
    var productDetails: ProductDetails?
    var showCost = false
    var showRetailPrice = false
    var currency = ""
    var radius: CGFloat = UIDevice.isPad ? 6 : 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func procced(_ sender: Any) {
        var str = ""
        str.append("\n\(purchaseStrings.date.localizedValue) \(productDetails!.purchaseDateTime!)\n")
        str.append("\(purchaseStrings.product.localizedValue) \(product!.name)\n")
        for i in 0..<productDetails!.products!.count{
            let p = productDetails!.products![i]
            if  productDetails!.products!.count > 1{
                str.append("\(i + 1). ")
            }
            str.append("\(p.getSerialTitle()):\n")
            str.append("\(p.productSerial ?? "")\n")
            if (product?.productType == ProductType.Credential.rawValue){
                if  productDetails!.products!.count > 1{
                    str.append("\(i + 1). ")
                }
                str.append("\(p.getUserNameTitle()):\n")
                str.append("\(p.productUsername ?? "")\n")
                
                if  productDetails!.products!.count > 1{
                    str.append("\(i + 1). ")
                }
                str.append("\(p.getUserSecretTitle()):\n")
                str.append("\(p.productPassword ?? p.productSecret ?? "")\n")
            }else{
                if  productDetails!.products!.count > 1{
                    str.append("\(i + 1). ")
                }
                str.append("\(p.getUserSecretTitle()):\n")
                str.append("\(p.productSecret ?? p.productPassword ?? "")\n")
            }
        }
        let textToShare = [ str ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if (completed){
                DataService.loadHome()
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func selectShare(_ sender: Any) {
        btnProceed.isEnabled = true
        btnProceed.alpha = 1
        imgRadio.image = UIImage(named: "ic_radio_checked")
        imgRadio.image = imgRadio.image?.withRenderingMode(.alwaysTemplate)
        imgRadio.tintColor = .accentColor
    }
}

extension PurchaseSuccessVC{
    func setupUI(){
        headerHeightConst.constant = .getNavBarHeight()
        if let user = DataService.getUserData() , let reseller = user.reseller , let product = product, let products = productDetails?.products, let qty = productDetails?.itemsCount{
            currency = reseller.Currency
            showCost = reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})!.Enabled
            
            showRetailPrice = reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.RECOMMENDED_RETAIL_PRICE.rawValue})!.Enabled
            
            retailPriceStackView.isHidden = !showRetailPrice
            lineView.isHidden = !showRetailPrice
            viewHeader.showX(product.name) {
                DataService.loadHome()
            }
            if product.ImagePath.isNotEmpty{
                imgProduct.url(product.ImagePath, imageD: UIImage(named: "nerd")!)
            }else{
                imgProduct.image = UIImage(named: "nerd");
            }
            retailPriceValueLabel.text = "\(product.recommendedRetailPrice ?? "") \(currency)"

            print("productsuccccccccc", product)
            lblProductName.text = product.name
            lblPurchaseDate.text = "\(purchaseStrings.purchase_date.localizedValue) \(productDetails?.purchaseDate ?? "")"
            lblPurchaseDate.textAlignment = lang == "en" ? .left : .right
            lblQty.text = purchaseStrings.quantity.localizedValue
            lblQtyValue.text = "\(qty)"
            totalRetailPriceValueLabel.text = "\((product.recRetailDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
    //        lblVatValue.text = "\((product.vatDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
            retailVatPriceValueLabel.text = "\((product.recAfterVatRetailDouble * Double(qty)).removeZerosFromEnd()) \(currency)"

            if (!showCost){
                stackPrice.isHidden = true
                stackTotalCost.isHidden = true
                stackVat.isHidden = true
                stackTotalWithVat.isHidden = true
            }else{
                lblProductPrice.text = purchaseStrings.product_cost_price.localizedValue
                lblTotalCost.text = purchaseStrings.total_cost_price.localizedValue
                lblVat.text = purchaseStrings.vat_amount_per.localizedValue.replacingOccurrences(of: "%", with: "\(product.vatePercentage ?? "")")
                lblTotalCostWithVat.text = purchaseStrings.total_cost_after_vat.localizedValue
                
                lblProductPriceValue.text = "\(product.Price) \(currency)"
                lblTotalCostValue.text = "\((product.priceDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
                lblVatValue.text = "\((product.vatDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
                lblTotalCostWithVatValue.text = "\((product.priceAfterVatDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
                
                
            }
            recRetalPriceLabel.text = "\(purchaseStrings.recommended_cost_price.localizedValue)"
            tRRetPriceLabel.text = "\(purchaseStrings.totalRecommended_cost_price.localizedValue)"
            recVatLabel.text = "\(purchaseStrings.totalRecommended_cost_price_after_vat.localizedValue)"

            
            viewDetails.round(to: radius)
            lblSuccess.text = purchaseStrings.purchase_success.localizedValue
            if (qty == 1){
                tableView.isHidden = true
                stackPurchaseInfo.isHidden = false
                lblSerial.text = products[0].getSerialTitle()
                lblSerialValue.text = products[0].productSerial
                if (product.productType == ProductType.Credential.rawValue){
                    lblUserName.text = products[0].getUserNameTitle()
                    lblUserNameValue.text = products[0].productUsername ?? ""
                    lblSecret.text = products[0].getUserSecretTitle()
                    lblSecretValue.text = products[0].productPassword ?? products[0].productSecret ?? ""
                    stackUserName.isHidden = false
                }else{
                    stackUserName.isHidden = true
                    lblSecret.text = products[0].getUserSecretTitle()
                    lblSecretValue.text = products[0].productSecret ?? products[0].productPassword ?? ""
                }
            }else{
                setupTableView()
                tableView.isHidden = false
                stackPurchaseInfo.isHidden = true
            }
            viewDetails.layoutIfNeeded()
            lblChoose.text = purchaseStrings.choose_method.localizedValue
            lblRadioShare.text = purchaseStrings.share.localizedValue
            btnProceed.alpha = 0.4
            btnProceed.setTitle(purchaseStrings.proceed.localizedValue, for: .normal)
            btnProceed.round(to: radius)
            setupAlignment()
        }
    }
    
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: ProductDataCell.self)
        tableView.registerCellNib(cellClass: ProductDataHeaderCell.self)
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutIfNeeded()
        tableViewHeight.constant = tableView.contentSize.height
        tableView.reloadData()
    }
    
    func setupAlignment(){
        lblProductPrice.textAlignment = lang == "en" ? .left : .right
        lblTotalCost.textAlignment = lang == "en" ? .left : .right
        lblVat.textAlignment = lang == "en" ? .left : .right
        lblTotalCostWithVat.textAlignment = lang == "en" ? .left : .right
        lblQty.textAlignment = lang == "en" ? .left : .right
        lblSerial.textAlignment = lang == "en" ? .left : .right
        lblUserName.textAlignment = lang == "en" ? .left : .right
        lblSecret.textAlignment = lang == "en" ? .left : .right
        
        lblProductPriceValue.textAlignment = lang == "en" ? .right : .left
        lblTotalCostValue.textAlignment = lang == "en" ? .right : .left
        lblVatValue.textAlignment = lang == "en" ? .right : .left
        lblTotalCostWithVatValue.textAlignment = lang == "en" ? .right : .left
        lblQtyValue.textAlignment = lang == "en" ? .right : .left
        lblSerialValue.textAlignment = lang == "en" ? .right : .left
        lblUserNameValue.textAlignment = lang == "en" ? .right : .left
        lblSecretValue.textAlignment = lang == "en" ? .right : .left
        
    }
}

extension PurchaseSuccessVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (productDetails?.products?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if (row == 0){
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDataHeaderCell", for: indexPath) as? ProductDataHeaderCell{
                cell.lblSerial.text = productDetails!.products![0].getSerialTitle()
                if (product?.productType == ProductType.Credential.rawValue){
                    cell.lblUsername.isHidden = false
                    cell.lblUsername.text = productDetails!.products![0].getUserNameTitle()
                }else{
                    cell.lblUsername.isHidden = true
                }
                cell.lblPassword.text = productDetails!.products![0].getUserSecretTitle()
                return cell
            }
            return ProductDataHeaderCell()
        }else{
            let index = indexPath.row - 1
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDataCell", for: indexPath) as? ProductDataCell{
                let productData = productDetails!.products![index]
                cell.lblSerial.text = productData.productSerial
                if (product?.productType == ProductType.Credential.rawValue){
                    cell.lblUsername.text = productData.productUsername
                    cell.lblUsername.isHidden = false
                    cell.lblPassword.text = productData.productPassword ?? productData.productSecret ?? ""
                }else{
                    cell.lblUsername.isHidden = true
                    cell.lblPassword.text = productData.productSecret ?? productData.productPassword ?? ""
                }
                return cell
            }
            return ProductDataCell()
        }
    }
}
