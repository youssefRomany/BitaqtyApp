//
//  SalesReportCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/23/21.
//

import UIKit

class SalesReportCell: UITableViewCell {
    @IBOutlet weak var viewProduct: UIView!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewInfo.setupWithRoundNoShadow(UIDevice.isPad ? 8 : 4)
        viewProduct.drawBorder(.borderColor, UIDevice.isPad ? 4 : 2, 1)
        lblService.text = reportStrings.service.localizedValue
        lblTransNo.text = reportStrings.trans_no.localizedValue
    }
    
    func setupData(with report: Report,_ showCost: Bool,_ currency: String){
        lblProduct.text = report.getProductName()
        lblServiceValue.text = report.getMerchantName()
        lblTransNoValue.text = "\(report.numberOfTrans ?? 0)"
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
