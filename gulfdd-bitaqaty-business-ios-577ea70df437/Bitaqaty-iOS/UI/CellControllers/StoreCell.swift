//
//  StoreCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class StoreCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: LblMediumSemiBoldFont!
    @IBOutlet weak var imgArrow: UIImageView!
    
    let radius: CGFloat = UIDevice.isPad ? 6 : 4
    override func awakeFromNib() {
        super.awakeFromNib()
        if lang == "en"{
            imgArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        viewMain.layer.cornerRadius = radius
        viewMain.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
