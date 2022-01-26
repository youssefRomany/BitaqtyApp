//
//  DropDownFilterView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import UIKit

class DropDownFilterView: UIView {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHeader: LblSmallRegularFont!
    @IBOutlet weak var lblTitle: LblSmallerLightFont!
    @IBOutlet weak var btn: UIButton!
    
    var action: (()->())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
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
        viewMain.layer.borderWidth = 1
        viewMain.layer.borderColor = UIColor.lightBorderColor.cgColor
        viewMain.layer.cornerRadius = 4
        viewMain.clipsToBounds = true
        
        lblHeader.layer.borderWidth = 1
        lblHeader.layer.borderColor = UIColor.lightBorderColor.cgColor
    }
    
    func setupData(_ header: String,_ title: String,action: (()->())?){
        lblHeader.text = header
        lblTitle.text = title
        self.action = action
    }
    
    @IBAction func onClick(_ sender: Any) {
        action?()
    }
}
