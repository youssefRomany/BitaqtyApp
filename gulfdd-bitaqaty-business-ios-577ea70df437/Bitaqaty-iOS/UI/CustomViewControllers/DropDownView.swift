//
//  DropDownView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/8/21.
//

import UIKit

class DropDownView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbl: LblSmallLightFont!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var img: UIImageView!
    
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
        lblTitle.textAlignment = lang == "en" ? .left : .right
        lbl.textAlignment = lang == "en" ? .left : .right
        lbl.layer.cornerRadius = 4
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = UIColor.lightBorderColor.cgColor
    }
    
    func setup(_ title: String,_ controllTitle: String,_ action: (()->())?){
        lblTitle.text = title
        lbl.text = controllTitle
        self.action = action
    }
    
    func setIcon(named: String){
        img.image = UIImage(named: named)
    }
   

    @IBAction func onClick(_ sender: UIButton) {
        action?()
    }
}
