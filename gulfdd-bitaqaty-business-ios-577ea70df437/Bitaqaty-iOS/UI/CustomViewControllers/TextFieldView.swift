//
//  TextFieldView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
import UIKit

class TextFieldView: UIView{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnTogglePassword: UIButton!
    
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
        btnTogglePassword.tag = 0
        btnTogglePassword.isHidden = true
        btnTogglePassword.titleLabel?.font = UIFont(name: FONT_ICON, size: FONT_LARGE)
    }
    
    func showError(_ err: String){
        lblError.text = err
        lblError.isHidden = false
    }
    
    func hideError(){
        lblError.isHidden = true
    }
    
    func hidePassword(){
        btnTogglePassword.tag = 0
        btnTogglePassword.setTitle(icons.ic_hide.localizedValue, for: .normal)
        btnTogglePassword.isHidden = false
        txt.isSecureTextEntry = true
    }
    
    func showPassword(){
        btnTogglePassword.tag = 1
        btnTogglePassword.setTitle(icons.ic_show.localizedValue, for: .normal)
        btnTogglePassword.isHidden = false
        txt.isSecureTextEntry = false
    }
    @IBAction func TogglePassword(_ btn: UIButton) {
        if (btn.tag == 0){
            showPassword()
        }else{
            hidePassword()
        }
    }
}
