//
//  HomeBankRequestCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 12/10/2021.
//

import UIKit

class HomeBankRequestCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTransferName: UILabel!
    @IBOutlet weak var lblCreationDate: UILabel!
    @IBOutlet weak var lblAmountHeader: UILabel!
    @IBOutlet weak var lblAmountCurrency: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblTransferDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblAmountHeader.text = btrrStrings.amount.localizedValue
        lblStatus.roundCorners(view: lblStatus, corners: [lang == "en" ?.topRight : .topLeft], radius: 5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ log: RequestLog){
        lblTransferName.text = log.getTransferPersonName()
        lblCreationDate.text = DateUtils.getHomeBankDate(log.getCreationDate())
        lblAmount.text = log.getAmount()
        lblAmountCurrency.text = log.getCurrentCurrency()
        lblBankName.text = log.getCurrentBankName()
        lblTransferDate.text = log.getTransferDate()
        var status = btrrStrings.btrr_status_pending.localizedValue
        switch log.getStatus().lowercased() {
        case BankTransferStatus.ACCEPTED.rawValue:
            status = btrrStrings.btrr_status_accepted.localizedValue
        case BankTransferStatus.REJECTED.rawValue:
            status = btrrStrings.btrr_status_rejected.localizedValue
        default:
            status = btrrStrings.btrr_status_pending.localizedValue
        }
        lblStatus.text = status
    }
    
}
