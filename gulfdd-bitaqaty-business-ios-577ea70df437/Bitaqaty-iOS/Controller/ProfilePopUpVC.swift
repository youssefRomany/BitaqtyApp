//
//  ProfilePopUpVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
class ProfilePopUpVC: UIViewController {
    
    @IBOutlet weak var loader: ErrorView!
    @IBOutlet weak var marginTop: NSLayoutConstraint!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLastDateHeader: UILabel!
    @IBOutlet weak var lblLastDate: UILabel!
    @IBOutlet weak var lblAccountNoHeader: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var languageView: MoreView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var stackSettings: UIStackView!
    @IBOutlet weak var btnFaq: UIButton!
    @IBOutlet weak var btnTerm: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        viewMain.layer.cornerRadius = 5
        viewMain.clipsToBounds = true
        if let user = DataService.getUserData(), let userInfo = user.reseller{
            lblName.text = userInfo.fullName
            lblEmail.text = userInfo.email
            lblLastDate.text = DateUtils.ds.lastVisitDate(userInfo.LastLoginDate)
            lblAccountNo.text = userInfo.accountNumber
            if (user.accountType == Roles.SUB_ACCOUNT.rawValue){
                lblRole.text = accountStrings.profile_sub_account.localizedValue
                if MORE_PERMISSIONS.isEmpty {
                    languageView.setData(for: #imageLiteral(resourceName: "ic_language"), title: strings.language.localizedValue, 3, self)
                    languageView.arrow.isHidden = false
                    languageView.isHidden = false
                    line1.isHidden = false
                    line2.isHidden = false
                    stackSettings.isHidden = false
                    marginTop.constant = 0
                }
            }else{
                lblRole.text = accountStrings.profile_reseller.localizedValue
                languageView.isHidden = true
                line1.isHidden = true
                line2.isHidden = true
                stackSettings.isHidden = true
                marginTop.constant = 20
            }
        }
        lblLastDateHeader.text = accountStrings.profile_last_visit_date.localizedValue
        lblAccountNoHeader.text = accountStrings.profile_account_no.localizedValue
        btnChangePassword.setTitle(strings.change_password.localizedValue, for: .normal)
        btnChangePassword.layer.cornerRadius = btnChangePassword.frame.height / 2
        btnChangePassword.layer.borderWidth = 1
        btnChangePassword.layer.borderColor = UIColor.systemGray4.cgColor
        btnSignOut.setTitle(accountStrings.profile_sign_out.localizedValue, for: .normal)
        btnSignOut.layer.cornerRadius = 4
        btnFaq.setTitle(accountStrings.more_faq.localizedValue, for: .normal)
        btnTerm.setTitle(accountStrings.more_terms_of_use.localizedValue, for: .normal)
        btnPrivacy.setTitle(accountStrings.more_privacy_policy.localizedValue, for: .normal)
    }
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func openChangePassword(_ sender: UIButton) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let vc = ChangePasswordVC(nibName: "ChangePasswordVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            pvc?.present(vc, animated: true, completion: nil)
        })
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        loader.startLoading(accountStrings.profile_signing_out.localizedValue)
        AccountServices.logout(delegate: self)
    }
    
    @IBAction func openExtraMoreVC(_ sender: UIButton) {
        weak var pvc = self.presentingViewController
        dismiss(animated: false, completion: {
            let vc = MoreExtraVC(nibName: "MoreExtraVC", bundle: nil)
            vc.type = sender.tag
            vc.modalPresentationStyle = .overFullScreen
            pvc?.present(vc, animated: true, completion: nil)
        })
    }
}
extension ProfilePopUpVC: OnFinishDelegate{
    func onSuccess(tag: Int) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: false, completion: {
            let vc = LanguageVC(nibName: "LanguageVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            pvc?.present(vc, animated: true, completion: nil)
        })
    }
    
    func onSuccess() {
        loader.stopLoading()
        DataService.deleteUserData()
        DataService.loadHome()
    }
    
    func onFailed(err: ServiceError) {
        loader.stopLoading()
        switch err {
        case .custom(let error):
            DataService.ds.showAlert(self, error.errorMessage)
        case .unauthorized:
            DataService.ds.showAlert(self, err.errorDescription){
                DataService.deleteUserData()
                DataService.loadHome()
            }
        default:
            DataService.ds.showAlert(self, err.errorDescription)
        }
    }
}
