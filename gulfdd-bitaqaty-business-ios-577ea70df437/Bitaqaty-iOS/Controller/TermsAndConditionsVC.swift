//
//  TermsAndConditionsVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/8/21.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var lblMainTxt: UILabel!
    @IBOutlet weak var lblSubText: UILabel!
    @IBOutlet weak var lblAmission: UILabel!

    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleHeader()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
    }
    func handleHeader(){
        self.viewHeader.showLogo()
        self.viewHeader.btnClose.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    @objc func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupData(){
        let style = NSMutableParagraphStyle()
        style.alignment = lang == "en" ? .left : .right
        style.headIndent = 10
        style.firstLineHeadIndent = 0
        
        lblAmission.text = RechargeStrings.admition.localizedValue
        var content = ""
        if type == RechargeTypes.Credit.rawValue{
            lblMainTxt.text = RechargeStrings.credit_terms.localizedValue
            content = RechargeStrings.credit_content.localizedValue
        }else if type == RechargeTypes.Amex.rawValue{
            lblMainTxt.text = RechargeStrings.amex_terms.localizedValue
            content = RechargeStrings.amex_content.localizedValue
        }else if type == RechargeTypes.Mada.rawValue{
            lblMainTxt.text = RechargeStrings.mada_terms.localizedValue
            content = RechargeStrings.mada_content.localizedValue
        }else if type == RechargeTypes.PayPal.rawValue{
            lblAmission.isHidden = true
            let titleStr = NSMutableAttributedString(string: RechargeStrings.paypal_terms.localizedValue, attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.textColor])
            lblMainTxt.attributedText = titleStr
        }
//        let titleStr = NSMutableAttributedString(string: content, attributes: [NSAttributedString.Key.paragraphStyle: style])
       // lblSubText.attributedText = titleStr
        let strString = content.withBoldText(
            boldPartsOfString: ["\"العملية\"", "\"الخدمات\"" ,"\"البنك مصدر البطاقة\""], font: .regularSmall, boldFont: .boldSmall)
        lblSubText.attributedText = strString

        //
//        lblSubText.attributedText = content.withBoldText(
//            boldPartsOfString: [RechargeStrings.credit_bold_service.localizedValue, RechargeStrings.credit_bold_site.localizedValue, RechargeStrings.credit_bold_process.localizedValue], font: .regularSmall, boldFont: .boldSmall)
    }
}
