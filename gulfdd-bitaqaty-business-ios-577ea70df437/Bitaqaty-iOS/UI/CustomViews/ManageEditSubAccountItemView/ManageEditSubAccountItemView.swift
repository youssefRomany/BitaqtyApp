//
//  ManageEditSubAccountItemView.swift
//  Bitaqaty-iOS
//
//  Created by Youssef on 18/03/2022.
//

import UIKit

class ManageEditSubAccountItemView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var inputContentView: UIView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    
    //MARK:-  @IBAction
    @IBAction func arrowAction(_ sender: Any) {
        viewDropDown?()
    }

    var viewDropDown: (()->())? = nil
    
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
        inputContentView.drawBorder(.gray, 5, 1)
    }
    

}
