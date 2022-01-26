//
//  ForgetPasswordVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
import UIKit
class ForgetPasswordVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var header: SignHeaderView!
    @IBOutlet weak var txtEmailView: TextFieldView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var LblCopyRight: UILabel!
    var resend = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func send(_ sender: UIButton) {
        view.endEditing(true)
        loaderView.startLoading()
        AccountServices.validateAndResetPassword(txtEmailView.txt.text!, self)
    }
}

extension ForgetPasswordVC{
    fileprivate func setupUI(){
        header.setData(accountStrings.sign_welcome.localizedValue, accountStrings.reset_password.localizedValue,accountStrings.reset_instruction.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        txtEmailView.setData(accountStrings.reset_email.localizedValue, accountStrings.reset_email.localizedValue, 0, .emailAddress, .done)
        btnSend.setTitle(accountStrings.send.localizedValue, for: .normal)
        LblCopyRight.text = strings.CRText.localizedValue
        txtEmailView.txt.delegate = self
    }
    
    fileprivate func resendCode(){
        resend = true
        send(btnSend)
    }
}
extension ForgetPasswordVC: OnFinishDelegate{
    func onFailed(err: ServiceError) {
        loaderView.stopLoading()
        DataService.ds.showAlert(self, err.errorDescription)
    }
    
    func onSuccess() {
        loaderView.stopLoading()
        if (!resend){
            var msg = accountStrings.reset_success_msg.localizedValue
            msg = msg.replacingOccurrences(of: "EMAIL_TXT", with: txtEmailView.txt.text!)
            DataService.ds.showDetailedAlert(self, msg, btn1Txt: msgs.doneTxt.localizedValue, btn2Txt: accountStrings.reset_resend.localizedValue) {
            } btn2Handler: {
                self.resendCode()
            }
        }else{
            DataService.ds.showAlert(self, accountStrings.reset_link_sent.localizedValue, btn1Txt: msgs.doneTxt.localizedValue,type: .success){
            }
        }
    }
    
    func onBadRequest(_ err: String, _ tag: Int) {
        loaderView.stopLoading()
        txtEmailView.lblError.text = err
        txtEmailView.lblError.isHidden = false
    }
}
extension ForgetPasswordVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtEmailView.lblError.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send(btnSend)
        return true
    }
}
