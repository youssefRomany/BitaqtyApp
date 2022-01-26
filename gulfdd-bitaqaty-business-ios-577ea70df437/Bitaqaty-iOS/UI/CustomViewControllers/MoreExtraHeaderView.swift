//
//  MoreExtraHeaderView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/28/21.
//

import UIKit

class MoreExtraHeaderView: UIView {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgHeader: UIImageView!
    var close: (()->())?
    
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
        btnBack.titleLabel?.font = UIFont(name: FONT_ICON, size: 20);
        btnBack.setTitle(icons.ic_arrow_r.localizedValue, for: .normal)
    }
    
    
    func setData(_ type: Int, close: (()->())?){
        switch type {
        case 2:
            lblHeader.text = accountStrings.more_terms_of_use.localizedValue
            imgHeader.image = #imageLiteral(resourceName: "ic_term_of_use")
        case 3:
            lblHeader.text = accountStrings.more_privacy_policy.localizedValue
            imgHeader.image = #imageLiteral(resourceName: "ic_privacy")
        default:
            lblHeader.text = accountStrings.more_faq.localizedValue
            imgHeader.image = #imageLiteral(resourceName: "ic_faq")
        }
        self.close = close
    }
    
    @IBAction func close(_ sender: UIButton) {
        close?()
    }
    
}
