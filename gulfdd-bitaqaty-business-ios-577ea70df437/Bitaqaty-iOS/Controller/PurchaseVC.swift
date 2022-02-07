//
//  PurchaseVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class PurchaseVC: UIViewController {
    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var stackQty: UIStackView!
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var lblTotalCostWithVat: UILabel!
    @IBOutlet weak var lblTotalCostValue: UILabel!
    @IBOutlet weak var lblVatValue: UILabel!
    @IBOutlet weak var lblTotalCostWithVatValue: UILabel!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var headerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var loader: ErrorView!
    
    @IBOutlet weak var lblProductPrice: UILabel!

    
    @IBOutlet weak var line4View: UIView!
    @IBOutlet weak var retailPriceView: UIView!
    
    @IBOutlet weak var recRetalPriceLabel: LblSmallRegularFont!
    @IBOutlet weak var tRRetPriceLabel: LblSmallRegularFont!
    @IBOutlet weak var recVatLabel: LblSmallRegularFont!
    
    @IBOutlet weak var retailPriceValueLabel: LblSmallRegularFont!
    @IBOutlet weak var totalRetailPriceValueLabel: LblSmallRegularFont!
    @IBOutlet weak var retailVatPriceValueLabel: LblSmallRegularFont!
    
    
    var product: Product?
    var radius: CGFloat = UIDevice.isPad ? 20 : 15
    var currency = ""
    var showCost = false
    var showRetailPrice = false
    var min = 1
    var max = 1
    var qty = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("joeProduct", product)
        
    }
    
    @IBAction func decrease(_ sender: Any) {
        if (qty > min){
            qty -= 1
            txtQty.text = "\(qty)"
            
            setupCost()
            setupRetail()
        }else{
            qty = min
            txtQty.text = "\(qty)"
            setupCost()
            setupRetail()
        }
    }
    
    @IBAction func increase(_ sender: Any) {
        if (qty < max){
            qty += 1
            txtQty.text = "\(qty)"
            setupCost()
            setupRetail()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buy(_ sender: Any) {
        guard let product = product else {return;}
        loader.startLoading()
        PurchaseAPIs.purchase(product, qty, self)
    }
}

extension PurchaseVC {
    func setupUI(){
        headerHeightConst.constant = .getNavBarHeight()
        if let user = DataService.getUserData() , let reseller = user.reseller , let product = product{
            currency = reseller.Currency
            showCost = reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})!.Enabled
            
            showRetailPrice = reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.RECOMMENDED_RETAIL_PRICE.rawValue})!.Enabled
            
            recRetalPriceLabel.text = "\(purchaseStrings.recommended_cost_price.localizedValue)"
            tRRetPriceLabel.text = "\(purchaseStrings.totalRecommended_cost_price.localizedValue)"
            recVatLabel.text = "\(purchaseStrings.totalRecommended_cost_price_after_vat.localizedValue)"

            retailPriceValueLabel.text = "\(product.recommendedRetailPrice ?? "") \(currency)"

            if showRetailPrice{
                retailPriceView.isHidden = false
                line4View.isHidden = false
            }else{
                retailPriceView.isHidden = true
                line4View.isHidden = true
            }
            

            
            viewHeader.showX(product.name) {
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
            if product.ImagePath.isNotEmpty{
                imgProduct.url(product.ImagePath, imageD: UIImage(named: "nerd")!)
            }else{
                imgProduct.image = UIImage(named: "nerd");
            }
            lblProductName.text = product.name
//            if (product.productType != ProductType.Service.rawValue && product.bulkPurchaseEnabled == true){
            if (product.bulkPurchaseEnabled == true){
                min = product.bulkMin ?? 1
                max = product.bulkMax ?? 1
                stackQty.isHidden = false
            }else{
                stackQty.isHidden = true
            }
                
                if (!showCost && !showRetailPrice){
                    line1.isHidden = true
                    viewQty.isHidden = true
                }else{
                    
                }
            
            
            
            if (!showCost){
                lblProductPrice.isHidden = true
                viewPrice.isHidden = true
                line3.isHidden = true
            }
            
            lblProductPrice.text = "\(purchaseStrings.product_cost_price.localizedValue) \(product.Price) \(currency)"

            if !showCost && showRetailPrice{
                
                lblProductPrice.text = "\(purchaseStrings.recommended_cost_price.localizedValue) \(product.recommendedRetailPrice ?? "") \(currency)"
                lblProductPrice.isHidden = false
                retailPriceValueLabel.isHidden = true
                recRetalPriceLabel.isHidden = true
            }
            
            qty = min
            txtQty.text = "\(qty)"
            lblTotalCost.text = purchaseStrings.total_cost_price.localizedValue
            lblVat.text = purchaseStrings.vat_amount_per.localizedValue.replacingOccurrences(of: "%", with: "\(product.vatePercentage ?? "")")
            lblTotalCostWithVat.text = purchaseStrings.total_cost_after_vat.localizedValue
            
            btnCancel.drawBorder(.accentColor, radius, 1)
            btnBuy.round(to: radius)
            btnDecrease.round(to: radius)
            btnIncrease.round(to: radius)
            btnBuy.setTitle(purchaseStrings.buy.localizedValue, for: .normal)
            btnCancel.setTitle(msgs.cancel.localizedValue, for: .normal)
            txtQty.delegate = self
            txtQty.drawBorder(.accentColor, radius, 1)
            setupCost()
            setupRetail()
        }
    }
    
    func setupCost(){
        guard let product = product else {return;}
        lblTotalCostValue.text = "\((product.priceDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
        lblVatValue.text = "\((product.vatDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
        lblTotalCostWithVatValue.text = "\((product.priceAfterVatDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
    }
  


    func setupRetail(){
        guard let product = product else {return;}
        totalRetailPriceValueLabel.text = "\((product.recRetailDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
//        lblVatValue.text = "\((product.vatDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
        retailVatPriceValueLabel.text = "\((product.recAfterVatRetailDouble * Double(qty)).removeZerosFromEnd()) \(currency)"
    }
    
}
extension PurchaseVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            if isAllowed(str: txtAfterUpdate) {
                if let quantity = Int(txtAfterUpdate){
                    if (quantity >= min && quantity <= max){
                        qty = quantity
                        setupCost()
                        setupRetail()
                        return true
                    }else if (quantity > max){
                        return false
                    }
                }else if (txtAfterUpdate.isEmpty){
                    qty = min
                    setupCost()
                    setupRetail()
                    return true
                }
            }else{
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("heree \(textField.text!)")
        if let quantity = Int(textField.text!){
            if (quantity >= min && quantity <= max){
                qty = quantity
                setupCost()
                setupRetail()
            }else{
                textField.text = "\(min)"
                qty = min
                setupCost()
                setupRetail()
            }
        }else{
            textField.text = "\(min)"
            qty = min
            setupCost()
            setupRetail()
        }
    }
    
    func isAllowed(str: String?) -> Bool {
        let regexPattern: String = "^((?!(0))[0-9]{0,10})$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regexPattern)
        
        return predicate.evaluate(with: str)
    }
}

extension PurchaseVC: OnFinishDelegate {
    func onSuccess(_ productDetails: ProductDetails) {
        loader.stopLoading()
        if let errors = productDetails.errors, errors.count > 0{
            let error = errors[0]
            handleError(error)
        }else if let productData = productDetails.products, productData.count > 0{
            let vc = PurchaseSuccessVC(nibName: String(describing: PurchaseSuccessVC.self), bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.product = product
            vc.productDetails = productDetails
            present(vc, animated: true, completion: nil)
        }
    }
    
    func onFailed(err: ServiceError) {
        switch err {
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        default:
            DataService.ds.showAlert(self, err.errorDescription)
        }
    }
    
    func handleError(_ error: ErrorMessage){
        var msg = errorMsgs.server.localizedValue
        switch error.errorCode {
        case PurchaseErrors.PRODUCT_OUT_OF_STOCK.rawValue:
            msg = errorMsgs.err_out_of_stock.localizedValue
        case PurchaseErrors.INSUFFICIENT_RESELLER_BALANCE.rawValue:
            msg = errorMsgs.err_insufficient_balance.localizedValue
        case PurchaseErrors.INSUFFICIENT_ITEMS_IN_STOCK.rawValue:
            msg = errorMsgs.err_insufficient_stock.localizedValue
        case PurchaseErrors.PRODUCT_PRICE_CHANGED.rawValue:
            msg = errorMsgs.err_price_changed.localizedValue
        default:
            msg = errorMsgs.err_service_not_available.localizedValue
        }
        DataService.ds.showAlert(self, msg)
    }
}
