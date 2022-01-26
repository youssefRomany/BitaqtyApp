//
//  MerchantCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class MerchantCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblTitle: LblSmallerRegularFont!
    let radius: CGFloat = UIDevice.isPad ? 10 : 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        img.layer.cornerRadius = radius
        viewShadow.roundedBttom(radius: radius)
        viewMain.setupWithRoundNoShadow(radius);
    }

}
