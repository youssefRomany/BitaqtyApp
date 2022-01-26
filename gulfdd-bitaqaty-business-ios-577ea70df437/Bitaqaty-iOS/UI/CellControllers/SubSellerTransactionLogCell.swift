//
//  SubSellerTransactionLogCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/14/21.
//

import UIKit

class SubSellerTransactionLogCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrinted: UILabel!
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblSerialNoValue: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var viewSupport: UIView!
    @IBOutlet weak var lblSupport: UILabel!
    @IBOutlet weak var minWidth: NSLayoutConstraint!
    
    var openTicket: (()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (UIDevice.isPad){
            minWidth.constant = lang == "en" ? 90 : 130
        }else{
            minWidth.constant = lang == "en" ? 55 : 80
        }
        viewMain.setupWithRoundNoShadow(UIDevice.isPad ? 8 : 4)
        viewSupport.round(to: UIDevice.isPad ? 4 : 2)
        lblPrinted.text = HomeStrings.printed.localizedValue
        lblSupport.text = TransactionStrings.TLogSupport.localizedValue
        lblSerialNo.text = TransactionStrings.TLogSerialNo.localizedValue
        lblTotal.text = HomeStrings.total.localizedValue
    }
    
    func setData(_ log: TransactionLog){
//        lblPrinted.isHidden = log.printCounter == 0 || log.printCounter == nil
        viewSupport.isHidden = !DataService.showSupport()
        lblProductName.text = log.ProductName
        lblSerialNoValue.text = log.ProductSerial
        if (DataService.showCost()){
            lblTotal.isHidden = false
            lblTotalValue.isHidden = false
            lblTotalValue.text = "\(log.Total.removeZerosFromEnd()) \(DataService.getCurrentCurency())"
        }else{
            lblTotal.isHidden = true
            lblTotalValue.isHidden = true
        }
    }
    
    @IBAction func goToSupport(_ sender: UIButton) {
        openTicket?()
    }
    
}
