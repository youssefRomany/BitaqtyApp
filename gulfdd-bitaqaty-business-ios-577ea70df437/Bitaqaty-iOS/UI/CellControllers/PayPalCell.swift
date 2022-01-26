//
//  PayPalCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/2/21.
//

import UIKit
import Alamofire
import AlamofireImage

class PayPalCell: UICollectionViewCell {
    @IBOutlet weak var viewContainer: UIView!

    @IBOutlet weak var lblAmountTitle: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPriceValue: UILabel!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var btnRecharge: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    func setupUI(){
        lblAmountTitle.text = RechargeStrings.cardAmount.localizedValue
        lblPriceTitle.text = RechargeStrings.paypal_price.localizedValue
        viewContainer.round(to: 5)
        btnRecharge.setTitle(strings.Recharge.localizedValue, for: .normal)
        btnRecharge.setupShadowsWithRound(5)
    }
    func setData(item: PayPalDenomination){
        lblAmountValue.text = "\(item.Amount)"
        lblPriceValue.text = "\(item.ResellerPrice)"
        if !item.Logo.isEmpty{
            let _ = print("Noura \(item.Logo)")
//            imgLogo.af_setImage(withURL: URL(string: item.Logo)!){(response) -> Void in
//                print("image: \(self.imgLogo.image)")
//                print(response.result.value) //# UIImage
//                print(response.result.error) //# NSError
//            }
            self.imgLogo.url(item.Logo, imageD: UIImage(named: "nerd")!)
        }
    }
}
