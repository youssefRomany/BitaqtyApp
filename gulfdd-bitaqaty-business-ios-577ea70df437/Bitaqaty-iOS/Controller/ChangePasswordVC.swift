//
//  ChangePasswordVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
import UIKit
class ChangePasswordVC: UIViewController {
    @IBOutlet weak var headerView2: UIView!
    @IBOutlet weak var lblTitle: LblMediumBoldFont!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var marginTop: NSLayoutConstraint!
    @IBOutlet weak var marginBottom: NSLayoutConstraint!
    @IBOutlet weak var marginTrailling: NSLayoutConstraint!
    @IBOutlet weak var marginLeading: NSLayoutConstraint!
    @IBOutlet weak var headerView: SignHeaderView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var txtCurrentPasswordView: TextFieldView!
    @IBOutlet weak var txtNewPasswordView: TextFieldView!
    @IBOutlet weak var viewValidation1: ValidationView!
    @IBOutlet weak var viewValidation2: ValidationView!
    @IBOutlet weak var viewValidation3: ValidationView!
    @IBOutlet weak var viewValidation4: ValidationView!
    @IBOutlet weak var viewValidation5: ValidationView!
    @IBOutlet weak var txtConfNewPasswordView: TextFieldView!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblCopyRight: UILabel!
    var isError = false
    var resetPasswordToken: String? = nil
    
    var type: ChangePasswordType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        view.endEditing(true)
        loaderView.startLoading(accountStrings.pass_applying_change.localizedValue)
        var currentPassword: String? = nil
        let newPassword = txtNewPasswordView.txt.text!
        let confNewPassword = txtConfNewPasswordView.txt.text!
        if (type == .normal){
            currentPassword = txtCurrentPasswordView.txt.text!
        }
        AccountServices.validateAndChangePassword(currentPassword,resetPasswordToken,newPassword,confNewPassword,self)
    }
    
}

extension ChangePasswordVC{
    fileprivate func setupUI(){
        if lang == "en"{
            lblCopyRight.text = "Copyright © 2020 \(WhiteLabelLocal.shared.getLocalWhiteLabelList()?.nameEn ?? "") business. All rights reserved."
        }else{
            lblCopyRight.text = "© 2020 \(WhiteLabelLocal.shared.getLocalWhiteLabelList()?.nameEn ?? "") جميع الحقوق محفوظة لصالح"
        }

        txtCurrentPasswordView.txt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtNewPasswordView.txt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtConfNewPasswordView.txt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        if (type == .login){
            headerView2.isHidden = true
            headerHeight.constant = 1
            marginTop.constant = 10
            marginLeading.constant = 10
            marginBottom.constant = 10
            marginTrailling.constant = 10
            headerView.isHidden = false
            profileView.isHidden = true
            headerView.setData(accountStrings.sign_welcome.localizedValue, resetPasswordToken != nil ? accountStrings.reset_password.localizedValue : accountStrings.pass_enter_new_password.localizedValue, accountStrings.pass_instruction.localizedValue){
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            if let user = DataService.getUserData(), let userInfo = user.reseller{
                lblUserName.text = userInfo.fullName ?? ""
                lblEmail.text = userInfo.email ?? ""
                lblAccountNo.text = "\(accountStrings.profile_account_no.localizedValue) \(userInfo.accountNumber ?? "")".adjustAlignment
            }
            lblTitle.text = strings.change_password.localizedValue
            scv.layer.cornerRadius = 4
            scv.layer.borderColor = UIColor.borderColor.cgColor
            scv.layer.borderWidth = 1
            headerView.isHidden = true
            profileView.isHidden = false
            txtCurrentPasswordView.isHidden = false
            txtCurrentPasswordView.setData(accountStrings.pass_current_pass.localizedValue, accountStrings.sign_dots.localizedValue, 0, .default, .next)
            txtCurrentPasswordView.hidePassword()
        }
        btnChange.setTitle(accountStrings.pass_change.localizedValue, for: .normal)
        txtNewPasswordView.setData(accountStrings.pass_new_pass.localizedValue, accountStrings.sign_dots.localizedValue, 1, .default, .next)
        txtNewPasswordView.hidePassword()
        txtConfNewPasswordView.setData(accountStrings.pass_conf_new_pass.localizedValue, accountStrings.sign_dots.localizedValue, 2, .default, .done)
        txtConfNewPasswordView.hidePassword()
        viewValidation1.setupData(title: accountStrings.pass_validation_1.localizedValue, tag: 1)
        viewValidation2.setupData(title: accountStrings.pass_validation_2.localizedValue, tag: 2)
        viewValidation3.setupData(title: accountStrings.pass_validation_3.localizedValue, tag: 3)
        viewValidation4.setupData(title: accountStrings.pass_validation_4.localizedValue, tag: 4)
        viewValidation5.setupData(title: accountStrings.pass_validation_5.localizedValue, tag: 5)
    }
    
    fileprivate func setupDelegate(){
        txtCurrentPasswordView.txt.delegate = self
        txtNewPasswordView.txt.delegate = self
        txtConfNewPasswordView.txt.delegate = self
    }
    
    fileprivate func handleErrorCode(_ error: ErrorMessage) {
        switch error.errorCode {
        case API_ERRORS.InvalidLoginProcessToken.rawValue:
            DataService.ds.showAlert(self, errorMsgs.unauthorized.localizedValue){
                DataService.loadHome()
            }
        case API_ERRORS.NewPassNotEqualsConfPass.rawValue:
            DataService.ds.showAlert(self, errorMsgs.passwords_mismatch.localizedValue)
        case API_ERRORS.NewPassEqualsOldPass.rawValue:
            DataService.ds.showAlert(self, errorMsgs.new_pass_match_old_pass.localizedValue)
        case API_ERRORS.IncorrectCurrentPassword.rawValue:
            DataService.ds.showAlert(self, errorMsgs.wrong_current_pass.localizedValue)
        case "-1":
            DataService.ds.showAlert(self, error.errorMessage)
        default:
            DataService.ds.showAlert(self, errorMsgs.server.localizedValue)
        }
    }
    
    fileprivate func validatePassword(_ password: String){
        let showError = isError && !password.isEmpty
        if (password.isEnglishOnly()){
            viewValidation1.setViewState(.valid)
        }else{
            viewValidation1.setViewState(showError ? .invalid : .normal)
        }
        
        if (password.count >= 8){
            viewValidation2.setViewState(.valid)
        }else{
            viewValidation2.setViewState(showError ? .invalid : .normal)
        }
        
        if (password.containSmallLetter()){
            viewValidation3.setViewState(.valid)
        }else{
            viewValidation3.setViewState(showError ? .invalid : .normal)
        }
        
        if (password.containCapitalLetter()){
            viewValidation4.setViewState(.valid)
        }else{
            viewValidation4.setViewState(showError ? .invalid : .normal)
        }
        
        if (password.containNumbers()){
            viewValidation5.setViewState(.valid)
        }else{
            viewValidation5.setViewState(showError ? .invalid : .normal)
        }
    }
}
extension ChangePasswordVC: OnFinishDelegate{
    func onSuccess() {
        loaderView.stopLoading()
        DataService.ds.showAlert(self, accountStrings.pass_change_success.localizedValue,type: .success) {
            DataService.deleteUserData()
            DataService.loadHome()
        }
    }
    
    func onFailed(err: ServiceError) {
        loaderView.stopLoading()
        switch err {
        case .custom(let error):
            handleErrorCode(error)
        case .unauthorized:
            DataService.ds.showAlert(self, err.errorDescription){
                DataService.deleteUserData()
                DataService.loadHome()
            }
        default:
            DataService.ds.showAlert(self, err.errorDescription)
        }
    }
    
    func onBadRequest(_ err: String, _ tag: Int) {
        loaderView.stopLoading()
        if (tag == 0){
            txtCurrentPasswordView.lblError.isHidden = false
            txtCurrentPasswordView.lblError.text = err
        }else if (tag == 1){
            txtNewPasswordView.lblError.isHidden = false
            txtNewPasswordView.lblError.text = errorMsgs.field_required.localizedValue
        }else if (tag == 2){
            isError = true
            validatePassword(txtNewPasswordView.txt.text!)
        }else{
            txtConfNewPasswordView.lblError.isHidden = false;
            txtConfNewPasswordView.lblError.text = err
        }
    }
}

extension ChangePasswordVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (txtCurrentPasswordView.txt.tag == textField.tag){
            txtNewPasswordView.txt.becomeFirstResponder()
        }else if (txtNewPasswordView.txt.tag == textField.tag){
            txtConfNewPasswordView.txt.becomeFirstResponder()
        }else{
            txtConfNewPasswordView.txt.resignFirstResponder()
            changePassword(btnChange)
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) -> Void {
        if (textField.tag == txtCurrentPasswordView.txt.tag){
            txtCurrentPasswordView.hideError()
        }
        if (textField.tag == txtNewPasswordView.txt.tag){
            if (txtNewPasswordView.txt.text == txtConfNewPasswordView.txt.text){
                txtConfNewPasswordView.hideError()
            }
            txtNewPasswordView.hideError()
            validatePassword(textField.text!)
        }
        if (textField.tag == txtConfNewPasswordView.txt.tag){
            txtConfNewPasswordView.hideError()
        }
    }
}
