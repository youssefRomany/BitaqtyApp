//
//  HomeSubAccountCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 12/10/2021.
//

import UIKit

class HomeSubAccountCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSales: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblSales.text = HomeStrings.home_sales.localizedValue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setData(data: HomeSubAccount){
        var currency = ""
        if let user = DataService.getUserData(), user.reseller != nil{
            currency = user.reseller!.Currency
        }
        lblName.text = data.Name
        lblType.text = SUB_ACCOUNT_TYPE.init(rawValue: data.AccountType)?.title
        let attriString = NSMutableAttributedString(string: "\(data.Sales)", attributes:
                                                [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                 NSAttributedString.Key.font: UIFont.boldSmall])
        let attriString2 = NSAttributedString(string: " " + currency, attributes:
                                                [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                 NSAttributedString.Key.font: UIFont.regularSmall])
        attriString.append(attriString2)
        lblPrice.attributedText = attriString
    }
    
}
