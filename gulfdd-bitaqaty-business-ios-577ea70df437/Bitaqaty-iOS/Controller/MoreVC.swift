//
//  MoreVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/25/21.
//

import Foundation
import XLPagerTabStrip

class MoreVC: UIViewController {
    var itemInfo: IndicatorInfo = "View";

    @IBOutlet weak var manageView: MoreView!
    @IBOutlet weak var logView: MoreView!
    @IBOutlet weak var productListView: MoreView!
    @IBOutlet weak var reportsView: MoreView!
    @IBOutlet weak var supportView: MoreView!
    @IBOutlet weak var languageView: MoreView!
    @IBOutlet weak var btnFAQ: UIButton!
    @IBOutlet weak var btnTermOfUse: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI(){
        manageView.setData(for: #imageLiteral(resourceName: "ic_manage"), title: accountStrings.more_manage_sub_account.localizedValue, 0, self)
        reportsView.setData(for: #imageLiteral(resourceName: "ic_reports"), title: accountStrings.more_reports.localizedValue,showDetails: true, 1, self)
        supportView.setData(for: #imageLiteral(resourceName: "ic_support"), title: accountStrings.more_resellers_support_center.localizedValue, 2, self)
        languageView.setData(for: #imageLiteral(resourceName: "ic_language"), title: strings.language.localizedValue, 3, self)
        btnFAQ.setTitle(accountStrings.more_faq.localizedValue, for: .normal)
        btnTermOfUse.setTitle(accountStrings.more_terms_of_use.localizedValue, for: .normal)
        btnPrivacy.setTitle(accountStrings.more_privacy_policy.localizedValue, for: .normal)
        if let user = DataService.getUserData(), let type = user.accountType, type == Roles.SUB_ACCOUNT.rawValue{
            manageView.isHidden = true
            
            if (MORE_PERMISSIONS.contains(SUBACCOUNT_TABS.TRANSACTION_LOG.rawValue)){
                logView.isHidden = false
                logView.setData(for: #imageLiteral(resourceName: "ic_log"), title: strings.TransactionLog.localizedValue, 4, self)
            }else{
                logView.isHidden = true
            }
            
            if (MORE_PERMISSIONS.contains(SUBACCOUNT_TABS.PRODUCT_LIST.rawValue)){
                productListView.isHidden = false
                productListView.setData(for: #imageLiteral(resourceName: "ic_list_bulleted"), title: strings.moreProductList.localizedValue, 5, self)
            }else{
                productListView.isHidden = true
            }
            
            if (MORE_PERMISSIONS.contains(SUBACCOUNT_TABS.REPORTS.rawValue)){
                reportsView.isHidden = false
            }else{
                reportsView.isHidden = true
            }
            
            if (MORE_PERMISSIONS.contains(SUBACCOUNT_TABS.SUPPORT.rawValue)){
                supportView.isHidden = false
            }else{
                supportView.isHidden = true
            }
        }
    }
    
    @IBAction func openExtraMore(_ btn: UIButton) {
        let vc = MoreExtraVC(nibName: "MoreExtraVC", bundle: nil)
        vc.type = btn.tag
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
}
extension MoreVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension MoreVC: OnFinishDelegate{
    func onSuccess(tag: Int) {
        print("onSuccess \(tag)")
        if (tag == 0){
            let vc = ManageSubAccountListVC(nibName: "ManageSubAccountListVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }else if (tag == 1){
            let vc = SalesReportVC(nibName: "SalesReportVC", bundle: nil)
            vc.isMenu = true
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }else if (tag == 2){
            let vc = SupportCenterVC(nibName: "SupportCenterVC", bundle: nil)
            vc.isMenu = true
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }else if (tag == 4){
            let vc = TransactionsLogVC(nibName: "TransactionsLogVC", bundle: nil)
            vc.isMenu = true
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }else if (tag == 5){
            // list
            let vc = ProductListVC(nibName: "ProductListVC", bundle: nil)
            vc.isMenu = true
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }else{
            let vc = LanguageVC(nibName: "LanguageVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
