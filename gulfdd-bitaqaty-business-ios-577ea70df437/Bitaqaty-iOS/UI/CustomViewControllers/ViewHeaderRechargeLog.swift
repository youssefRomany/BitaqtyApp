//
//  ViewHeaderRechargeLog.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/7/21.
//

import UIKit

class ViewHeaderRechargeLog: UIView {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMethod: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblBalance: UILabel!

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
        setupUI()
    }
    func setupUI(){
        self.lblDate.text = RechargeStrings.recharginDateTime.localizedValue
        self.lblMethod.text = RechargeStrings.method.localizedValue
        self.lblAmount.text = RechargeStrings.recharging_amount.localizedValue
        self.lblBalance.text = RechargeStrings.balance_after.localizedValue
    }
}
