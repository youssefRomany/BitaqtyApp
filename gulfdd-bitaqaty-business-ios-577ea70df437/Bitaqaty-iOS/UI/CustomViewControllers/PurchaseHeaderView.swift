//
//  PurchaseHeaderView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class PurchaseHeaderView: UIView {
    @IBOutlet weak var lblTitle: LblMediumBoldFont!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    var action: (()->())?
    
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
        heightConst.constant = .getNavBarHeight()
        if (lang == "en"){
            btnBack.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    func setup(_ title: String,_ logo: String?,_ action: (()->())?){
        lblTitle.text = title
        if let logo = logo, logo.isNotEmpty{
            DataService.ds.downloadImageWithoutExtension(urlStr: logo, imageView: imgLogo)
        }
        self.action = action
    }
    @IBAction func onBackClicked(_ sender: UIButton) {
        action?()
    }
    
}
