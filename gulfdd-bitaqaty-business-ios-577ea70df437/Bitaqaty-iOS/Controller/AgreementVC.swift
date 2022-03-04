//
//  AgreementVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/11/21.
//

import Foundation
class AgreementVC: UIViewController {
    
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var header: SignHeaderView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnAgree: BtnStandard!
    @IBOutlet weak var lblCR: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblTermHeader: UILabel!
    @IBOutlet weak var lblTerm: UILabel!
    
    @IBOutlet weak var lblCopyRightHeader: UILabel!
    @IBOutlet weak var lblCopyRight: UILabel!
    
    @IBOutlet weak var lblTradeHeader: UILabel!
    @IBOutlet weak var lblTrade: UILabel!
    
    @IBOutlet weak var lblServicesHeader: UILabel!
    @IBOutlet weak var lblServices: UILabel!
    
    @IBOutlet weak var lblPrivacyHeader: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    fileprivate func setupUI(){
        viewMain.layer.cornerRadius = 2
        viewMain.clipsToBounds = true
        if lang == "en"{
            lblCR.text = "Copyright © 2020 \(WhiteLabelLocal.shared.getLocalGoldRateList()?.nameEn ?? "") business. All rights reserved."
        }else{
            lblCR.text = "© 2020 \(WhiteLabelLocal.shared.getLocalGoldRateList()?.nameEn ?? "") جميع الحقوق محفوظة لصالح"
        }
        header.setData(accountStrings.sign_welcome.localizedValue)
        
        lblTitle.text = accountStrings.agreement_reseller.localizedValue
        btnAgree.setTitle(accountStrings.agreement_agree.localizedValue, for: .normal)
        
        lblTermHeader.text = accountStrings.more_terms_of_use.localizedValue
        lblTerm.text = accountStrings.agreement_terms_of_use.localizedValue
        
        lblCopyRightHeader.text = accountStrings.agreement_copyright_notice_header.localizedValue
        lblCopyRight.text = accountStrings.agreement_copyright_notice.localizedValue
        
        lblTradeHeader.text = accountStrings.agreement_logos_and_trademarks_header.localizedValue
        lblTrade.text = accountStrings.agreement_logos_and_trademarks.localizedValue
        
        lblServicesHeader.text = accountStrings.agreement_reseller_services_header.localizedValue
        lblServices.text = accountStrings.agreement_reseller_services.localizedValue
        
        lblPrivacyHeader.text = accountStrings.agreement_privacy_and_confidentiality_header.localizedValue
        lblPrivacy.text = accountStrings.agreement_privacy_and_confidentiality.localizedValue
    }
    
    @IBAction func accept(_ sender: UIButton) {
        loaderView.startLoading(accountStrings.sign_signing.localizedValue)
        AccountServices.acceptAgreement(self)
    }
    
}

extension AgreementVC: OnFinishDelegate{
    func onSuccess() {
        loaderView.stopLoading()
        DataService.loadHome()
    }
    
    func onFailed(err: ServiceError) {
        loaderView.stopLoading()
        DataService.ds.showAlert(self, err.errorDescription)
    }
}
