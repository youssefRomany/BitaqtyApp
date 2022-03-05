//
//  SignHeaderView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
import UIKit

class SignHeaderView: UIView{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var splashLogo: UIImageView!

    var close: (() -> ())? = nil
    
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
    
    
    func setData(_ header: String,_ title: String = "",_ subTitle: String = "",close: (() -> ())? = nil){
        setImageView(forImageView: splashLogo, andURL: WhiteLabelLocal.shared.getLocalWhiteLabelList()?.logoPath ?? "", andPlaceHolderImage: "")

        if lang == "en"{
            lblHeader.text = "Welcome\nto \(WhiteLabelLocal.shared.getLocalWhiteLabelList()?.nameEn ?? "")"
        }else{
            lblHeader.text = "مرحبا بك\nفي \(WhiteLabelLocal.shared.getLocalWhiteLabelList()?.nameAr ?? "")"
        }
        if (title.isEmpty){
            lblTitle.isHidden = true
        }else{
            lblTitle.text = title
        }
        if (subTitle.isEmpty){
            lblSubTitle.isHidden = true
        }else{
            lblSubTitle.text = subTitle
        }
        if (close == nil){
            btnClose.isHidden = true
        }else{
            btnClose.isHidden = false
            self.close = close;
        }
    }
    
    @IBAction func close(_ sender: Any) {
        close?()
    }
    
}
