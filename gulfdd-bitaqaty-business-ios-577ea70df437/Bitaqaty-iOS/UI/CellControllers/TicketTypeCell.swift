//
//  TicketTypeCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/17/21.
//

import UIKit

class TicketTypeCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func checked(){
        img.image = UIImage(named: "ic_radio_checked")
        img.image = img.image?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .accentColor
    }
    
    func unchecked(){
        img.image = UIImage(named: "ic_radio_unchecked")
        img.image = img.image?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .textColor
    }
}
