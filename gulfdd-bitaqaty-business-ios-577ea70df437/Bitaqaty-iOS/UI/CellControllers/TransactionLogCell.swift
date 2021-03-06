//
//  TransactionLogCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/21/21.
//

import UIKit

class TransactionLogCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewSupport: UIView!
    @IBOutlet weak var viewPrint: UIView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCostAfterVatTitle: UILabel!
    @IBOutlet weak var lblCostAfterValue: UILabel!
    @IBOutlet weak var lblSupportTicket: UILabel!
    @IBOutlet weak var lblPrint: UILabel!
    @IBOutlet weak var lblCancel: UILabel!
    
    @IBOutlet weak var lblTransIdTitle: UILabel!
    @IBOutlet weak var lblTransIdValue: UILabel!
    @IBOutlet weak var lblCostTitle: UILabel!
    @IBOutlet weak var lblCostValue: UILabel!
    
    @IBOutlet weak var lblRetailPriceTitle: UILabel!
    @IBOutlet weak var lblRetailPriceValue: UILabel!
    @IBOutlet weak var lblRetailPriceAfterVatTitle: UILabel!
    @IBOutlet weak var lblRetailPriceAfterVatValue: UILabel!
    @IBOutlet weak var lblProfitTitle: UILabel!
    @IBOutlet weak var lblProfitValue: UILabel!
    
    @IBOutlet weak var lblVatAmountTitle: UILabel!
    @IBOutlet weak var lblVatAmountValue: UILabel!
    @IBOutlet weak var lblBalanceTitle: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!

    @IBOutlet weak var lblSerialNoTitle: UILabel!
    @IBOutlet weak var lblSerialNoValue: UILabel!
    @IBOutlet weak var lblPasswordTitle: UILabel!
    @IBOutlet weak var lblPasswordValue: UILabel!
    @IBOutlet weak var lblUserNameTitle: UILabel!
    @IBOutlet weak var lblUserNameValue: UILabel!
    
    @IBOutlet weak var lblCredNameTitle: UILabel!
    @IBOutlet weak var lblCredNameValue: UILabel!

    @IBOutlet weak var imgArr: UIImageView!
    @IBOutlet weak var stackCostAfterVat: UIStackView!
    @IBOutlet weak var stackDetailsContainer: UIStackView!
    @IBOutlet weak var stackDetails1: UIStackView!
    @IBOutlet weak var stackDetails2: UIStackView!
    @IBOutlet weak var stackDetails3: UIStackView!
    
    @IBOutlet weak var stackCost: UIStackView!
    @IBOutlet weak var stackRetailPrice: UIStackView!
    @IBOutlet weak var stackRetailPriceAfterVat: UIStackView!
    @IBOutlet weak var stackVat: UIStackView!
    @IBOutlet weak var stackProfit: UIStackView!
    @IBOutlet weak var stackBalance: UIStackView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    // var tableView: UITableView!
    var isHasSupportPermission: Bool = true
    var isHasDiscountPermission: Bool = true
    var isHasViewBalancePermission: Bool = true
    var RessellerBalanceAccount = true
    
    var ic_back = lang == "en" ? "ic_back_left" : "ic_back"
    weak var delegate: TransactionLogDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setUI(){
        viewPrint.isHidden = true
        viewContainer.setupShadowsWithRoundGray(5)
        viewPrint.round(to: 4)
        viewSupport.round(to: 4)
        self.roundCorners(view: lblCancel, corners: [lang == "en" ? .topRight : .topLeft], radius: 5)
        lblCancel.text = TransactionStrings.TLogCanceled.localizedValue
        lblCostAfterVatTitle.text = TransactionStrings.TLogCostAfter.localizedValue
        lblSupportTicket.text = TransactionStrings.TLogSupport.localizedValue
        lblPrint.text = TransactionStrings.TLogPrint.localizedValue
        lblTransIdTitle.text = TransactionStrings.TLogTransID.localizedValue
        lblCostTitle.text = TransactionStrings.TLogCostPrice.localizedValue
        lblRetailPriceTitle.text = TransactionStrings.recommended_retail_price.localizedValue
        lblRetailPriceAfterVatTitle.text = TransactionStrings.recommended_retail_price_after_vat.localizedValue
        lblProfitTitle.text = TransactionStrings.expected_profit.localizedValue
        lblVatAmountTitle.text = TransactionStrings.TLogVATAmount.localizedValue
        lblBalanceTitle.text = TransactionStrings.TLogBalance.localizedValue
        lblUserNameTitle.text = TransactionStrings.TLogUserName.localizedValue
        lblSerialNoTitle.text = TransactionStrings.TLogSerialNo.localizedValue
        lblPasswordTitle.text = TransactionStrings.TLogPassword.localizedValue
        imgArr.image = UIImage(named: ic_back)
        
        
        lblProductName.textAlignment = lang == "en" ? .left : .right
        lblDate.textAlignment = lang == "en" ? .left : .right
        lblCostAfterVatTitle.textAlignment = lang == "en" ? .left : .right
        lblCostAfterValue.textAlignment = lang == "en" ? .left : .right
        
        lblTransIdTitle.textAlignment = lang == "en" ? .left : .right
        lblTransIdValue.textAlignment = lang == "en" ? .left : .right
        lblCostTitle.textAlignment = lang == "en" ? .left : .right
        lblCostValue.textAlignment = lang == "en" ? .left : .right
        lblRetailPriceTitle.textAlignment = lang == "en" ? .left : .right
        lblRetailPriceValue.textAlignment = lang == "en" ? .left : .right
        lblRetailPriceAfterVatTitle.textAlignment = lang == "en" ? .left : .right
        lblRetailPriceAfterVatValue.textAlignment = lang == "en" ? .left : .right
        lblProfitTitle.textAlignment = lang == "en" ? .left : .right
        lblProfitValue.textAlignment = lang == "en" ? .left : .right
        lblVatAmountTitle.textAlignment = lang == "en" ? .left : .right
        lblVatAmountValue.textAlignment = lang == "en" ? .left : .right
        lblBalanceTitle.textAlignment = lang == "en" ? .left : .right
        lblBalanceValue.textAlignment = lang == "en" ? .left : .right
        lblSerialNoTitle.textAlignment = lang == "en" ? .left : .right
        lblSerialNoValue.textAlignment = lang == "en" ? .left : .right
        lblPasswordTitle.textAlignment = lang == "en" ? .left : .right
        lblPasswordValue.textAlignment = lang == "en" ? .left : .right
        lblUserNameTitle.textAlignment = lang == "en" ? .left : .right
        lblUserNameValue.textAlignment = lang == "en" ? .left : .right
        
        
    }
    func setData(log: TransactionLog, isHasSupportPermission: Bool = true,
                 isHasDiscountPermission: Bool = true,
                 isHasViewBalancePermission: Bool = true, isHasViewRecommendedRetailPrice: Bool = false){
        
        lblProductName.text = log.ProductName
        lblDate.text = DateUtils.getLogDate(log.TransactionDate)
        lblCostAfterValue.text = "\(log.Total)"
        lblTransIdValue.text = log.TransactionId
        lblCostValue.text = "\(log.Price)"
        lblRetailPriceValue.text = "\(log.RecommendedRetailPrice)"
        lblRetailPriceAfterVatValue.text = "\(log.RecommendedRetailPriceAfterVAT)"
        lblProfitValue.text = "\(log.ExpectedProfit)"
        lblVatAmountValue.text = "\(log.VatAmount)"
        lblBalanceValue.text = "\(log.Balance)"
        lblUserNameValue.text = "\(log.SubReselleraccount)"
        lblSerialNoValue.text = "\(log.ProductSerial)"

        if log.ChannelCode == CHANNEL_CODES.WALLET.rawValue{
            lblPasswordValue.text = log.ProductName
            stackDetails3.isHidden = true
        }else{
            if(log.ProductUserName.isEmpty || log.ProductType == ProductType.Serial.rawValue){
                stackDetails3.isHidden = true
                lblPasswordValue.text = log.ProductSecret
                lblPasswordTitle.text = log.ProductSecretTitle
            }else{
                stackDetails3.isHidden = false
                lblPasswordValue.text = log.ProductSecret
                lblPasswordTitle.text = log.ProductSecretTitle
                
                lblCredNameValue.text = log.ProductUserName
                lblCredNameTitle.text = log.ProductUserNameTitle
//
//                let boldText = "\(log.ProductUserNameTitle): "
//                let attrs = [NSAttributedString.Key.font : UIFont.semiBoldSmall]
//                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
//
//                let normalText = log.ProductUserName
//                let normalString = NSMutableAttributedString(string:normalText)
//
//                attributedString.append(normalString)
//
//                let boldText2 = "\n\n\(log.ProductSecretTitle): "
//                let attributedString2 = NSMutableAttributedString(string:boldText2, attributes:attrs)
//                attributedString.append(attributedString2)
//
//                let normalText2 = log.ProductSecret
//                let normalString2 = NSMutableAttributedString(string:normalText2)
//                attributedString.append(normalString2)
//
//                lblPasswordValue.attributedText = attributedString
                
            }
        }
        
        if log.cancelled{
            lblCancel.isHidden = false
            // viewPrint.isHidden = true
        }else{
            lblCancel.isHidden = true
            // viewPrint.isHidden = false
        }
        viewSupport.isHidden = !isHasSupportPermission
        heightConst.constant = isHasSupportPermission ? 25 : 0
        stackBalance.isHidden = !isHasViewBalancePermission
        
        if let user = DataService.getUserData(), let reseller = user.reseller{
            RessellerBalanceAccount = (reseller.resellerType == (Reseller_ACCOUNT_Type.BALANCE.rawValue))
            if user.accountType == Roles.SUB_ACCOUNT.rawValue{
                // subAccount or resseller limit
                if isHasDiscountPermission{
                    stackCostAfterVat.isHidden = false
                    stackCost.isHidden = false
                    stackVat.isHidden = false
                }else{
                    stackCostAfterVat.isHidden = true
                    stackCost.isHidden = true
                    stackVat.isHidden = true
                }
                
                if isHasViewRecommendedRetailPrice {
                    stackRetailPrice.isHidden = false
                    stackRetailPriceAfterVat.isHidden = false
                }else {
                    stackRetailPrice.isHidden = true
                    stackRetailPriceAfterVat.isHidden = true
                }
                
                if isHasDiscountPermission && isHasViewRecommendedRetailPrice {
                    stackProfit.isHidden = false
                }else {
                    stackProfit.isHidden = true
                }
                print("ddddddddddddd sub")

            }else if RessellerBalanceAccount{
                // resseller balanse
                print("ddddddddddddd bb")
                lblBalanceTitle.text = TransactionStrings.SubAccountBalanse.localizedValue
                lblRetailPriceTitle.text = TransactionStrings.SubAccountBrice.localizedValue
                lblRetailPriceAfterVatTitle.text = TransactionStrings.SubAccountBriceAfterVat.localizedValue
                lblProfitTitle.text = TransactionStrings.profit.localizedValue
                
                lblBalanceValue.text = "\(log.subTransactionPrice ?? 0)"
                lblRetailPriceValue.text = "\(log.subTransactionBalanceAfter ?? 0)"
                lblRetailPriceAfterVatValue.text = "\(log.subTransactionBalanceAfter ?? 0)"

                stackRetailPrice.isHidden = false
                stackRetailPriceAfterVat.isHidden = false
                stackVat.isHidden = false
                stackProfit.isHidden = false
                stackCostAfterVat.isHidden = false
                stackCost.isHidden = false

            }else{
                // resseller limit
                print("ddddddddddddd limit")

                stackProfit.isHidden = false
                stackRetailPrice.isHidden = false
                stackRetailPriceAfterVat.isHidden = false
                stackCostAfterVat.isHidden = false
                stackCost.isHidden = false
                stackVat.isHidden = false
                lblProfitTitle.text = TransactionStrings.profit.localizedValue



            }
        }
        
//        if isHasDiscountPermission{
//            stackCostAfterVat.isHidden = false
//            stackCost.isHidden = false
//            stackVat.isHidden = false
//        }else{
//            stackCostAfterVat.isHidden = true
//            stackCost.isHidden = true
//            stackVat.isHidden = true
//        }
        
        

        
    }
    @IBAction func onSupportClicked(_ sender: Any) {
        if delegate != nil{
            delegate!.onSupportClicked(index: self.tag)
        }
    }
    
}
