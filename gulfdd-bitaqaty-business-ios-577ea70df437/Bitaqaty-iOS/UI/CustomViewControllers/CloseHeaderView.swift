//
//  CloseHeaderView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/26/21.
//

import UIKit

class CloseHeaderView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    var close: (()->())? = nil
    
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
    }
    func showLogo(){
        
        self.lblTitle.isHidden = true
        self.imgLogo.isHidden = false
        setImageView(forImageView: imgLogo, andURL: WhiteLabelLocal.shared.getLocalWhiteLabelList()?.logoPath ?? "", andPlaceHolderImage: "")

        self.btnClose.setImage(UIImage(named: lang == "en" ? "ic_back_left" : "ic_back"), for: .normal)
        self.btnClose.imageView?.tintColor = .textColor
    }
    
    func showX(_ title: String = "",_ close: (()->())? = nil){
        self.lblTitle.isHidden = false
        self.lblTitle.text = title
        self.imgLogo.isHidden = true
        self.btnClose.setImage(UIImage(named: "ic_close"), for: .normal)
        self.btnClose.imageView?.tintColor = .textColor
        self.close = close
    }
    
    @IBAction func closeVC(_ sender: UIButton) {
        close?()
    }
    
}
