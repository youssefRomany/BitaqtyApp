//
//  ManageSubRadioView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/29/21.
//

import UIKit

class ManageSubRadioView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!

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
        self.imgRadio.tintColor = .secondryColor
        return view as! UIView
    }
    
    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
    }
    func setupImage(type: Int, isEnabled: Bool){
        let image = isEnabled ? type == ImageType.Radio.rawValue ? "ic_radio_checked" : "ic_checkbox_checked" : type == ImageType.Radio.rawValue ? "ic_radio_unchecked" : "ic_checkbox_unchecked"
        self.imgRadio.image = UIImage(named: image)
        self.imgRadio.tintColor = isEnabled ? .accentColor : type == ImageType.Radio.rawValue  ? .secondryColor : .textColor


    }
}
