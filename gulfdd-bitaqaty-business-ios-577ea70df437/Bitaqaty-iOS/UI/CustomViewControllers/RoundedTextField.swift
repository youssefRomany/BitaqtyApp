//
//  RoundedTextField.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/9/21.
//

import UIKit

class RoundedTextField: UIView {
    @IBOutlet weak var lblTransferCurrency: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var lblError: UILabel!
    
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
        lblHeader.textAlignment = lang == "en" ? .left : .right
        txt.textAlignment = lang == "en" ? .left : .right
        txt.font = UIFont(name: FONT_SEMI_BOLD, size: FONT_SMALL)
    }
    
    func setData(_ header: String,_ placeHolder: String,_ tag: Int,_ keyboardType: UIKeyboardType = .default,_ returnType: UIReturnKeyType = .next){
        lblHeader.text = header
        txt.placeholder = placeHolder
        txt.keyboardType = keyboardType
        txt.returnKeyType = returnType
        txt.tag = tag
        txt.layer.cornerRadius = 4
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.lightBorderColor.cgColor
    }
    
    func showError(_ err: String){
        lblError.text = err
        lblError.isHidden = false
    }
    
    func hideError(){
        lblError.isHidden = true
    }

}
