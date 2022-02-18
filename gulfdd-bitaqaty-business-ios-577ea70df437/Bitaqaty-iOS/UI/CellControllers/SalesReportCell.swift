//
//  SalesReportCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/23/21.
//

import UIKit

class SalesReportCell: UITableViewCell {
    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var imgArr: UIImageView!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblOtherValue: UILabel!
    @IBOutlet weak var stackUsername: UIStackView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUsernameValue: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var lblTransNo: UILabel!
    @IBOutlet weak var lblTransNoValue: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblServiceValue: UILabel!
    @IBOutlet weak var stackCost: UIStackView!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblTotalCostValue: UILabel!
    
    @IBOutlet weak var viewFullInfo: UIView!
    @IBOutlet weak var lblTransNo1: UILabel!
    @IBOutlet weak var lblTransNoValue1: UILabel!
    
    @IBOutlet weak var lblService1: UILabel!
    @IBOutlet weak var lblServiceValue1: UILabel!
    
    @IBOutlet weak var stackCost1: UIStackView!
    @IBOutlet weak var lblTotalCost1: UILabel!
    @IBOutlet weak var lblTotalCostValue1: UILabel!
    
    @IBOutlet weak var stackRetailPrice: UIStackView!
    @IBOutlet weak var lblRetailPriceTitle: UILabel!
    @IBOutlet weak var lblRetailPriceValue: UILabel!
    
    @IBOutlet weak var stackTotalRetailPrice: UIStackView!
    @IBOutlet weak var lblTotalRetailPriceTitle: UILabel!
    @IBOutlet weak var lblTotalRetailPriceValue: UILabel!
    
    @IBOutlet weak var stackProfit: UIStackView!
    @IBOutlet weak var lblProfitTitle: UILabel!
    @IBOutlet weak var lblProfitValue: UILabel!
    
    var ic_back = lang == "en" ? "ic_back_left" : "ic_back"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        viewInfo.setupWithRoundNoShadow(UIDevice.isPad ? 8 : 4)
        viewFullInfo.setupWithRoundNoShadow(UIDevice.isPad ? 8 : 4)
        viewProduct.drawBorder(.borderColor, UIDevice.isPad ? 4 : 2, 1)
        
        lblService.text = reportStrings.service.localizedValue
        lblTransNo.text = reportStrings.trans_no.localizedValue
        lblService1.text = reportStrings.service.localizedValue
        lblTransNo1.text = reportStrings.trans_no.localizedValue
        lblTotalCost1.text = reportStrings.total_cost_price.localizedValue
        
        lblProduct.textAlignment = lang == "en" ? .left : .right
        lblUsernameValue.textAlignment = lang == "en" ? .left : .right
        lblTransNo1.textAlignment = lang == "en" ? .left : .right
        lblTransNoValue1.textAlignment = lang == "en" ? .left : .right
        lblService1.textAlignment = lang == "en" ? .left : .right
        lblServiceValue1.textAlignment = lang == "en" ? .left : .right
        lblTotalCost1.textAlignment = lang == "en" ? .left : .right
        lblTotalCostValue1.textAlignment = lang == "en" ? .left : .right
        lblRetailPriceTitle.textAlignment = lang == "en" ? .left : .right
        lblRetailPriceValue.textAlignment = lang == "en" ? .left : .right
        lblTotalRetailPriceTitle.textAlignment = lang == "en" ? .left : .right
        lblTotalRetailPriceValue.textAlignment = lang == "en" ? .left : .right
        lblProfitTitle.textAlignment = lang == "en" ? .left : .right
        lblProfitValue.textAlignment = lang == "en" ? .left : .right
        
        imgArr.image = UIImage(named: ic_back)
    }
    
    func setupData(with report: Report,_ showCost: Bool,_ currency: String, _ showRecomendPrice: Bool, _ isRessellerBalanceAccount: Bool){
        lblProduct.text = report.getProductName()
        lblServiceValue.text = report.getMerchantName()
        lblTransNoValue.text = "\(report.numberOfTrans ?? 0)"
        lblServiceValue1.text = report.getMerchantName()
        lblTransNoValue1.text = "\(report.numberOfTrans ?? 0)"
        if (showCost){
            stackUsername.isHidden = false
            stackCost.isHidden = false
            lblOther.text = reportStrings.cost_price.localizedValue
            lblOtherValue.text = "\(report.price?.removeZerosFromEnd() ?? "") \(currency)"
            lblTotalCost.text = reportStrings.total_cost_price.localizedValue
            lblTotalCostValue.text = "\(report.totalTransAmount?.removeZerosFromEnd() ?? "") \(currency)"
            lblUsername.text = reportStrings.username.localizedValue
            lblUsernameValue.text = "\(report.subAccountName ?? "")"
        }else{
            stackUsername.isHidden = true
            stackCost.isHidden = true
            lblOther.text = reportStrings.username.localizedValue
            lblOtherValue.text = "\(report.subAccountName ?? "")"
        }
        
        lblRetailPriceTitle.text = isRessellerBalanceAccount ? reportStrings.sub_account_price.localizedValue : reportStrings.recommended_retail_price.localizedValue
        lblTotalRetailPriceTitle.text = isRessellerBalanceAccount ? reportStrings.total_sub_account_price.localizedValue : reportStrings.total_recommended_retail_price.localizedValue
        lblProfitTitle.text = isRessellerBalanceAccount ? reportStrings.total_profit.localizedValue : reportStrings.total_expected_profit.localizedValue
        
        //@Pending
        lblTotalCostValue1.text = isRessellerBalanceAccount ? "\(report.totalTransAmount?.removeZerosFromEnd() ?? "") \(currency)" : "\(report.totalTransAmount?.removeZerosFromEnd() ?? "") \(currency)"
        lblRetailPriceValue.text = "\(report.recommendedPrice?.removeZerosFromEnd() ?? "") \(currency)"
        lblTotalRetailPriceValue.text = isRessellerBalanceAccount ? "\(report.totalRecommendedPrice?.removeZerosFromEnd() ?? "") \(currency)" : "\(report.totalRecommendedPrice?.removeZerosFromEnd() ?? "") \(currency)"
        lblProfitValue.text = isRessellerBalanceAccount ? "\(report.totalExpectedProfit ?? "") \(currency)" : "\(report.totalExpectedProfit ?? "") \(currency)"
        
        if showRecomendPrice {
            stackRetailPrice.isHidden = false
            stackTotalRetailPrice.isHidden = false
        }else {
            stackRetailPrice.isHidden = true
            stackTotalRetailPrice.isHidden = true
        }
        
        if showCost && showRecomendPrice {
            stackProfit.isHidden = false
        }else {
            stackProfit.isHidden = true
        }
        
//        
        drawDashedLine()
    }
    
    func drawDashedLine(){
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.accentColor.cgColor
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [4,4]
        let path = CGMutablePath()
        let frm: CGRect = stackView.frame
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: 0, y: frm.height)])
        lineLayer.path = path
        self.viewLine.layer.addSublayer(lineLayer)
        lineLayer.position = CGPoint(
            x:lineLayer.bounds.midX,
            y:lineLayer.bounds.midY)
    }
    
}
