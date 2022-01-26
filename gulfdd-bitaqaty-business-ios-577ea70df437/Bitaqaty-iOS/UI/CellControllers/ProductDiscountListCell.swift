//
//  ProductDiscountListCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import UIKit

class ProductDiscountListCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewVat: UIView!
    @IBOutlet weak var viewLogo: UIView!
    @IBOutlet weak var viewDashed: UIView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblCostTitle: UILabel!
    @IBOutlet weak var lblCostValue: UILabel!
    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var lblVatAmountTitle: UILabel!
    @IBOutlet weak var lblVatAfterTitle: UILabel!
    @IBOutlet weak var lblServiceValue: UILabel!
    @IBOutlet weak var lblVatAmountValue: UILabel!
    @IBOutlet weak var lblVatAfterValue: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var stackView: UIStackView!

    
    var tableView: UITableView!
    var isHide = false
    var currency = ""


    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.round(to: 3)
        viewVat.setupShadowsWithRound(4)
        viewLogo.setupShadowsWithRound(2)
        lblCostTitle.text = productListStrings.costPrice.localizedValue
        lblServiceTitle.text = productListStrings.service.localizedValue
        lblVatAmountTitle.text = productListStrings.VAT_Amount.localizedValue
        lblVatAfterTitle.text = productListStrings.costAfterVat.localizedValue
        if let user = DataService.getUserData(), let reseller = user.reseller{
            currency = reseller.Currency
        }

        lblProductName.textAlignment = lang == "en" ? .left : .right
        lblCostTitle.textAlignment = lang == "en" ? .left : .right
        lblCostValue.textAlignment = lang == "en" ? .left : .right
        lblServiceTitle.textAlignment = lang == "en" ? .left : .right
        lblVatAmountTitle.textAlignment = lang == "en" ? .left : .right
        lblVatAfterTitle.textAlignment = lang == "en" ? .left : .right
        lblServiceValue.textAlignment = lang == "en" ? .left : .right
        lblVatAmountValue.textAlignment = lang == "en" ? .left : .right
        lblVatAfterValue.textAlignment = lang == "en" ? .left : .right

        // self.viewDashed.createDottedLine(width: 5.0, color: UIColor.accentColor.cgColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setData(product: Product, hasDiscountPermission: Bool = true){
        self.lblProductName.text = product.name
        self.lblCostValue.text = "\(product.Price) \(currency)"
        self.lblServiceValue.text = product.merchantName
        self.lblVatAmountValue.text = "\(product.Vat) \(currency)"
        self.lblVatAfterValue.text = "\(product.PriceAfterVat) \(currency)"
        
        if !product.ImagePath.isEmpty{
            self.imgLogo.url(product.ImagePath, imageD: UIImage(named: "nerd")!)
        }
        self.viewVat.isHidden = !hasDiscountPermission
        if !hasDiscountPermission{
            lblCostTitle.text = productListStrings.service.localizedValue
            self.lblCostValue.text = product.merchantName
            tableView.beginUpdates()
            tableView.endUpdates()
        }
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
        self.viewDashed.layer.addSublayer(lineLayer)
        lineLayer.position = CGPoint(
            x:lineLayer.bounds.midX,
            y:lineLayer.bounds.midY)
    }
    
}
