//
//  ProductDataHeaderCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/19/21.
//

import UIKit

class ProductDataHeaderCell: UITableViewCell {

    @IBOutlet weak var lblSerial: LblSmallBoldFont!
    @IBOutlet weak var lblUsername: LblSmallBoldFont!
    @IBOutlet weak var lblPassword: LblSmallBoldFont!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
