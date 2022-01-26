//
//  RechargingLogCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/22/21.
//

import UIKit

class RechargingLogCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMethod: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnShowReason: UIButton!
    @IBOutlet weak var lblReasonTitle: UILabel!
    @IBOutlet weak var lblReasonValue: UILabel!
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var btnExpand: UIButton!

    var tableView: UITableView!
    var reason = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnShowReason.round(to: 7.5)
        lblReasonTitle.text = RechargeStrings.rechargingReason.localizedValue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(log: RechargingLog){
        self.lblDate.text =  DateUtils.getHomeBankDate(log.RechargeDate)
        self.lblMethod.text = log.ChargingMethod
        self.lblBalance.text = "\(log.BalanceAfter) \(log.Currency)"
        self.lblAmount.text = "\(log.Amount) \(log.Currency)"
        btnShowReason.isHidden = true
        viewSeperator.isHidden = true
        btnExpand.tag = 0
        reason = log.ManualReason
        if !log.ManualReason.isEmpty{
            if lang == "ar"{
                btnShowReason.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            btnShowReason.isHidden = false
            lblReasonValue.text = log.ManualReason
        }
    }
    @IBAction func onShowReasonClicked(_ sender: UIButton) {
        if (reason.isNotEmpty){
            if sender.tag == 0{
                btnExpand.tag = 1
                btnShowReason.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                viewSeperator.isHidden = false
            }else{
                viewSeperator.isHidden = true
                btnExpand.tag = 0
                if lang == "ar"{
                    btnShowReason.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                }
                btnShowReason.transform = lang == "en" ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
