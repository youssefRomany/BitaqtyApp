//
//  RechargeItemView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/5/21.
//

import UIKit

class RechargeItemView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var viewCircle: UIView!
    var itemType = 0
    var rechargeMethod: RechargeMethod?
  //  weak var delegate: RechargePopDelegate!
//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    // MARK: setup view
    
    private func loadViewFromNib() -> UIView {
        let viewBundle = Bundle(for: type(of: self))
        let view = viewBundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]
        self.tag = 0;
        return view as! UIView
    }
    
    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
        self.viewCircle.setupWithRoundNoShadow(UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40)
    }
    func setData(_ type: Int,_ title: String = ""){
        self.itemType = type
        switch type {
        case RechargeTypes.Bank.rawValue:
            lblTitle.text = title.isEmpty ? strings.bankTransfer.localizedValue : title
            image.image = UIImage(named: "bank_transfer_icon")
        case RechargeTypes.Mada.rawValue:
            lblTitle.text = title.isEmpty ? strings.mada.localizedValue : title
            image.image = UIImage(named: "mada_icon")
        case RechargeTypes.Credit.rawValue:
            lblTitle.text = title.isEmpty ? strings.credit.localizedValue : title
            image.image = UIImage(named: "credit_icon")
        case RechargeTypes.Amex.rawValue:
            lblTitle.text = title.isEmpty ? strings.amex.localizedValue : title
            image.image = UIImage(named: "amex_icon")
        case RechargeTypes.PayPal.rawValue:
            lblTitle.text = title.isEmpty ? strings.paypal.localizedValue : title
            image.image = UIImage(named: "paypal_icon")
        default:
            print("nothing")
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        var result:[String: Any] = ["TYPE" : itemType]
        if rechargeMethod != nil{
            result["METHOD"] = rechargeMethod!
        }
        NotificationCenter.default.post(name: .rechargeSelected, object: nil, userInfo: result)
    }
}
