//
//  HomeBestSellingCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 12/10/2021.
//

import UIKit

class HomeBestSellingCell: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewChild: UIView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewChild.round(to: 6)
    }
    
    func setData(_ data: Report, color: UIColor){
        if self.tag == 0{
            viewContainer.setupShadowsWithRound(10)
        }
        else{
            viewContainer.round(to: 0)
        }
        viewChild.backgroundColor = color
        lblTitle.text = "\(data.getProductName()) (\(formatted: data.getPercentage())%)"
        
    }

}
