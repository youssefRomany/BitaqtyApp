//
//  SuccessErrorPaymentVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/15/21.
//

import UIKit

class SuccessErrorPaymentVC: UIViewController {
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgRequest: UIImageView!
    var type: Int = -1
    var isSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if type == RechargeTypes.Bank.rawValue{
            NotificationCenter.default.post(name: .reloadHomeBankRequests, object: nil)
        }else{
            if isSuccess{
                NotificationCenter.default.post(name: .reloadHomeRecharge, object: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
    }
    //    override func viewWillDisappear(_ animated: Bool) {
    //        self.setStatusBar(color: .white)
    //    }
    func setupUI(){
        var title = ""
        if type == RechargeTypes.Amex.rawValue{
            title = strings.amex.localizedValue
        }else if type == RechargeTypes.Mada.rawValue{
            title = strings.mada.localizedValue
        }else if type == RechargeTypes.Credit.rawValue{
            title = strings.credit.localizedValue
        }else if type == RechargeTypes.PayPal.rawValue{
            title = strings.paypal.localizedValue
        }else if (type == RechargeTypes.Bank.rawValue){
            title = btrrStrings.btrr_bank_transfer.localizedValue
        }
        viewHeader.lblTitle.text = title
        self.viewHeader.btnClose.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        if isSuccess{
            imgRequest.image = UIImage(named: "ic_success_request")
            if (type == RechargeTypes.Bank.rawValue){
                lblTitle.text = btrrStrings.btrr_success.localizedValue
                lblError.text = btrrStrings.btrr_success_msg.localizedValue
                lblError.isHidden = false
                btnDone.setTitle(RechargeStrings.done.localizedValue, for: .normal)
            }else{
                lblTitle.text = RechargeStrings.success_recharged.localizedValue
                lblError.isHidden = true
                btnDone.setTitle(RechargeStrings.done.localizedValue, for: .normal)
            }
        }else{
            imgRequest.image = UIImage(named: "ic_error_request")
            lblTitle.text = RechargeStrings.error_recharged.localizedValue
            lblError.text = RechargeStrings.error_recharged_sub.localizedValue
            lblError.isHidden = false
            btnDone.setTitle(RechargeStrings.retryRecharge.localizedValue, for: .normal)
        }
        btnDone.round(to: 4)
    }
    
    @objc func closeView(_ sender: UIButton) {
        handleClose()
    }
    @IBAction func onDoneClicked(_ sender: Any) {
        if type == RechargeTypes.Bank.rawValue || isSuccess{
            NotificationCenter.default.post(name: .hideRechargePopup, object: nil)
            handleClose()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    func handleClose(){
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)       
    }
}
