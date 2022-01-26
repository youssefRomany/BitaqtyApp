//
//  BankTransferLogCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit

class BankTransferLogCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTransferName: UILabel!
    @IBOutlet weak var lblCreationDate: UILabel!
    @IBOutlet weak var lblAmountHeader: UILabel!
    @IBOutlet weak var lblAmountCurrency: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblTransferDate: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var viewRejectionReason: UIView!
    @IBOutlet weak var lblRejectionReasonHeader: UILabel!
    @IBOutlet weak var lblRejectionReason: UILabel!
    @IBOutlet weak var imgArr: UIImageView!
    
    
    weak var delegate: OnFinishDelegate?
    var isRejected = false
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 4
        viewMain.clipsToBounds = true
        lblAmountHeader.text = btrrStrings.amount.localizedValue
        lblRejectionReasonHeader.text = btrrStrings.btrr_rejection_reason.localizedValue
        lblRejectionReason.textAlignment = lang == "en" ? .right : .left
        viewMain.addShadow(offset: CGSize(width: 1, height: 1), color: .shadow, opacity: 0.5, radius: 4)
    }
    
    func setupData(_ log: RequestLog){
        lblTransferName.text = log.getTransferPersonName()
        lblCreationDate.text = log.getCreationDate()
        lblAmount.text = log.getAmount()
        lblAmountCurrency.text = log.getCurrentCurrency()
        lblBankName.text = log.getCurrentBankName()
        lblTransferDate.text = log.getTransferDate()
        var status = btrrStrings.btrr_status_pending.localizedValue
        imgArr.isHidden = true
        isRejected = false
        switch log.getStatus().lowercased() {
        case BankTransferStatus.ACCEPTED.rawValue:
            status = btrrStrings.btrr_status_accepted.localizedValue
        case BankTransferStatus.REJECTED.rawValue:
            isRejected = true
            status = btrrStrings.btrr_status_rejected.localizedValue
            imgArr.isHidden = false
            imgArr.transform = CGAffineTransform(rotationAngle: (lang == "en" ? -CGFloat.pi / 2 : CGFloat.pi / 2))
        default:
            status = btrrStrings.btrr_status_pending.localizedValue
        }
        lblRejectionReason.text = log.getRejectionReason()
        btnStatus.setTitle(status, for: .normal)
        btnStatus.layer.cornerRadius = 2
        btnStatus.clipsToBounds = true
    }
    
    func openRejectionReason(){
        imgArr.transform = CGAffineTransform(rotationAngle: 0)
        viewRejectionReason.isHidden = false
    }
    
    func closeRejectionReason(){
        imgArr.transform = CGAffineTransform(rotationAngle: (lang == "en" ? -CGFloat.pi / 2 : CGFloat.pi / 2))
        viewRejectionReason.isHidden = true
    }
    
    @IBAction func openRejectionReason(_ btn: Any) {
        if (isRejected){
            delegate?.onSuccess(tag: btnStatus.tag)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
