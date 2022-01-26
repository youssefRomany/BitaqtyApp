//
//  LoginVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var headerView: SignHeaderView!
    @IBOutlet weak var txtUserNameView: TextFieldView!
    @IBOutlet weak var txtPasswordView: TextFieldView!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnArabic: UIButton!
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var lblCopyRight: UILabel!
    @IBOutlet weak var stackLang: UIStackView!
    
    var sessionEnded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if (self.sessionEnded){
                DataService.ds.showAlert(self, errorMsgs.session_ended.localizedValue, btn1Txt: accountStrings.sign_in.localizedValue,type: .warning) {
                    
                }
            }
        }
        if let username = DataService.getUsername(){
            txtUserNameView.txt.text = username
        }
    }
    
    @IBAction func openForgetPassword(_ sender: UIButton) {
        view.endEditing(true)
        let vc = ForgetPasswordVC(nibName: "ForgetPasswordVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Login(_ sender: UIButton) {
        view.endEditing(true)
        loaderView.startLoading(accountStrings.sign_signing.localizedValue)
        AccountServices.validateAndLogin(txtUserNameView.txt.text!, txtPasswordView.txt.text!, self)
    }
    
    @IBAction func changeLang(_ btn: UIButton) {
        view.endEditing(true)
        if (lang != "en" && btn.tag == 2) || (lang == "en" && btn.tag == 1){
            lang = btn.tag == 1 ? "ar" : "en"
            Bundle.set(lang)
        }
    }
}
extension LoginVC{
    fileprivate func setupUI() {
        stackLang.semanticContentAttribute = .forceLeftToRight
        lblCopyRight.text = strings.CRText.localizedValue
        headerView.setData(accountStrings.sign_welcome.localizedValue,accountStrings.sign_in.localizedValue , accountStrings.sign_instruction.localizedValue)
        txtUserNameView.setData(accountStrings.sign_username.localizedValue, accountStrings.sign_username.localizedValue, 0, .emailAddress, .next)
        
        txtPasswordView.setData(accountStrings.sign_password.localizedValue, accountStrings.sign_dots.localizedValue, 1, .default,.done)
        txtPasswordView.hidePassword()
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle: 1,
            NSAttributedString.Key.font: UIFont.regularMedium,
            NSAttributedString.Key.foregroundColor: UIColor.textColor
        ]
        
        let attributedString = NSMutableAttributedString(string: accountStrings.sign_forgot_password.localizedValue, attributes: attributes)
        btnForgetPassword.setAttributedTitle(attributedString, for: .normal)
        btnSignIn.setTitle(accountStrings.sign_in.localizedValue,for: .normal)
        btnArabic.setTitle(accountStrings.arabic.localizedValue, for: .normal)
        btnEnglish.setTitle(accountStrings.english.localizedValue, for: .normal)
        if (lang == "en"){
            btnArabic.titleLabel?.font = UIFont.regularSmall
            btnEnglish.titleLabel?.font = UIFont.semiBoldSmall
        }else{
            btnArabic.titleLabel?.font = UIFont.semiBoldSmall
            btnEnglish.titleLabel?.font = UIFont.regularSmall
        }
    }
    
    fileprivate func setupDelegate(){
        txtUserNameView.txt.delegate = self
        txtPasswordView.txt.delegate = self
    }
    
    fileprivate func openChangePassword(){
        let vc = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.type = .login
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func openCodeVerification(){
        let vc = VerificationVC(nibName: "VerificationVC", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func handleErrorCode(_ error: ErrorMessage) {
        switch error.errorCode {
        case API_ERRORS.PasswordNotChanged.rawValue:
            openChangePassword()
        case API_ERRORS.SmsAuthSent.rawValue,API_ERRORS.IpLocationSMSAuthSent.rawValue:
            openCodeVerification()
        case API_ERRORS.ExceededMaxAllowedResendSmsLimit.rawValue:
            DataService.ds.showAlert(self, errorMsgs.sms_resend_exceeded.localizedValue)
        case "-1":
            DataService.ds.showAlert(self, error.errorMessage)
        default:
            DataService.ds.showAlert(self, errorMsgs.incorrect_username_password.localizedValue)
        }
    }
}

extension LoginVC: OnFinishDelegate{
    func onSuccess() {
        loaderView.stopLoading()
        DataService.loadHome()
    }
    
    func onFailed(err: ServiceError) {
        loaderView.stopLoading()
        switch err {
        case .custom(let error):
            handleErrorCode(error)
        default:
            DataService.ds.showAlert(self, err.errorDescription)
        }
    }
    
    func onBadRequest(_ err: String, _ tag: Int) {
        loaderView.stopLoading()
        if (tag == 0){
            txtUserNameView.lblError.text = err
            txtUserNameView.lblError.isHidden = false
        }else{
            txtPasswordView.lblError.text = err
            txtPasswordView.lblError.isHidden = false
        }
    }
}

extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == txtUserNameView.txt.tag){
            txtPasswordView.txt.becomeFirstResponder()
        }else{
            txtPasswordView.txt.resignFirstResponder()
            view.endEditing(true)
            Login(btnSignIn)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.tag == txtUserNameView.txt.tag){
            txtUserNameView.lblError.isHidden = true
        }else{
            txtPasswordView.lblError.isHidden = true
        }
        return true
    }
}
