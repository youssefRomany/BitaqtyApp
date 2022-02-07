//
//  ProductSearchCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import UIKit

class ProductSearchCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewStock: UIView!
    @IBOutlet weak var lblStock: UILabel!

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCostTitle: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var recomendRetailPriceTitleLabel: LblSmallerLightFont!
    @IBOutlet weak var retailBtn: BtnSmallRegularFont!
    
    weak var delegate: OnBuyDelegate? = nil
    var inStock = false
    override func awakeFromNib() {
        super.awakeFromNib()
        btnBuy.round(to: 5)
        retailBtn.round(to: 5)
        viewMain.setupShadowsWithRoundGray(5)
        lblCostTitle.text = productListStrings.product_cost_price.localizedValue
        recomendRetailPriceTitleLabel.text = productListStrings.recommended_cost_price.localizedValue
        lblStock.text = productListStrings.out_of_stock.localizedValue
        if let user = DataService.getUserData(), let reseller = user.reseller{
            if user.accountType == Roles.SUB_ACCOUNT.rawValue, reseller.PermissionsArr.count > 0{
                if reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})!.Enabled{
                    self.lblCostTitle.isHidden = false
                    self.btnBuy.isHidden = false
                    
                    self.recomendRetailPriceTitleLabel.isHidden = false
                    self.retailBtn.isHidden = false
                    
                    self.constraint.constant = 100

                }else{
                    self.lblCostTitle.isHidden = true
                    self.btnBuy.isHidden = true
                    
                    self.recomendRetailPriceTitleLabel.isHidden = true
                    self.retailBtn.isHidden = true

                    self.constraint.constant = 8
                }
                if reseller.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.RECOMMENDED_RETAIL_PRICE.rawValue})!.Enabled{
                    self.recomendRetailPriceTitleLabel.isHidden = false
                    self.retailBtn.isHidden = false
                    
                    self.constraint.constant = 100

                }else{
                    self.recomendRetailPriceTitleLabel.isHidden = true
                    self.retailBtn.isHidden = true

//                    self.constraint.constant = 8
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(product: Product){
        var currency = ""
        if let user = DataService.getUserData(), let reseller = user.reseller{
            currency = reseller.Currency
        }
        inStock = product.isInStock
        self.lblProductName.text = product.name
        self.btnBuy.setTitle("\(product.Price) \(currency)", for: .normal)
        self.retailBtn.setTitle("\(product.recommendedRetailPrice ?? "") \(currency)", for: .normal)
        self.viewStock.isHidden = inStock

        if !product.ImagePath.isEmpty{
            let _ = print("Noura \(product.ImagePath)")
            self.imgLogo.url(product.ImagePath, imageD: UIImage(named: "nerd")!)
        }

    }
    @IBAction func btnBuyClicked(_ sender: UIButton) {
        if delegate != nil && inStock{
            delegate!.onBuy(Index: self.tag)
        }
    }
}
