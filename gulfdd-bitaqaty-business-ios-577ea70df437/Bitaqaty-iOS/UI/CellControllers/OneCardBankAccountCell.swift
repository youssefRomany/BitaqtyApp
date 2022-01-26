//
//  OneCardBankAccountCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit

class OneCardBankAccountCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var lblAccountNoValue: UILabel!
    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var lblAccountNameValue: UILabel!
    @IBOutlet weak var lblBankAddress: UILabel!
    @IBOutlet weak var lblBankAddressValue: UILabel!
    @IBOutlet weak var lblIBAN: UILabel!
    @IBOutlet weak var lblIBANValue: UILabel!
    
    
    let radius: CGFloat = UIDevice.isPad ? 25 : 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        viewMain.setupWithRoundNoShadow(10)
        imgLogo.layer.cornerRadius = radius
        imgLogo.clipsToBounds = true
        lblAccountNo.text = btrrStrings.btrr_account_number.localizedValue
        lblAccountName.text = btrrStrings.btrr_account_name.localizedValue
        lblBankAddress.text = btrrStrings.btrr_bank_address.localizedValue
        lblIBAN.text = btrrStrings.btrr_iban.localizedValue
    }
    
    
    func setupData(_ account: Account){
        lblBankName.text = account.getBankName()
        lblAccountNoValue.text = account.getAccountNumber()
        lblAccountNameValue.text = account.getAccountName()
        lblBankAddressValue.text = account.getAccountAddress()
        lblIBANValue.text = account.getIban()
        if let logo = account.oneCardBankLogoPath{
            DataService.ds.downloadImageWithoutExtension(urlStr: logo, imageView: self.imgLogo)
        }else{
            self.imgLogo.image = nil
        }
    }

}
