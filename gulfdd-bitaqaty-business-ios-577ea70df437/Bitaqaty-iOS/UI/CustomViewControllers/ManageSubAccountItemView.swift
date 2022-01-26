//
//  ManageSubAccountItemView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/29/21.
//

import UIKit

class ManageSubAccountItemView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var viewReset: UIStackView!
    @IBOutlet weak var btnReset: BtnSmallRegularFont!
    
    var reset: (()->())? = nil
    
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
        btnReset.setTitle(manageStrings.renewal_limit_to_default.localizedValue, for: .normal)
    }
    
    @IBAction func resetLimit(_ sender: Any) {
        reset?()
    }
    
    func setupAction(_ action: (()->())?){
        self.reset = action
    }
}
