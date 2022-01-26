//
//  InstructionsView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/8/21.
//

import UIKit

class InstructionsView: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewTable: UIView!

    @IBOutlet weak var imgDown: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var stackContainer: UIStackView!
    @IBOutlet weak var stackTable: UIStackView!

    @IBOutlet weak var tableHeightConst: NSLayoutConstraint!

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
        lblTitle.text = RechargeStrings.follow_instructions.localizedValue
        lblTitle.textAlignment = lang == "en" ? .left : .right
        self.viewContainer.round(to: 3)
        stackTable.setupShadows()
        addSubview(nibView)
    }
    func setData(_ type: Int){
        let style = NSMutableParagraphStyle()
        style.alignment = lang == "en" ? .left : .right
        style.headIndent = 30
        style.firstLineHeadIndent = 0
        
        var text = ""
        var arr: [String] = []
        switch type {
        case RechargeTypes.Mada.rawValue, RechargeTypes.Credit.rawValue:
            arr = [RechargeStrings.mada_alert1.localizedValue, RechargeStrings.mada_alert2.localizedValue,
                RechargeStrings.mada_alert3.localizedValue]
        case RechargeTypes.Credit.rawValue:
            arr = [RechargeStrings.credit_alert1.localizedValue, RechargeStrings.credit_alert2.localizedValue,
                RechargeStrings.credit_alert3.localizedValue]
        case RechargeTypes.Amex.rawValue:
            arr = [RechargeStrings.amex_alert.localizedValue]
        default:
            arr = []
        }

        let title = NSMutableAttributedString(string: text)
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "ic_warning_filled")
        attachment.image = attachment.image?.withTintColor(UIColor.accentColor)
        attachment.bounds = CGRect(x: 0, y: -4, width: 15, height: 15)
        let replacement = NSAttributedString(attachment: attachment)
        let titleStr = NSMutableAttributedString(string: "  ", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.textColor])
        titleStr.append(replacement)
        for item in arr{
            text = item
            title.append(titleStr)
            let titleStr = NSMutableAttributedString(string: "   \(text)\n\n", attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.textColor])
                    title.append(titleStr)
            
        }
        lblInstructions.attributedText = title

    }
    @IBAction func onTapped(_ sender: Any) {
        tableView.isHidden = !tableView.isHidden
        if tableView.isHidden{
            self.imgDown.image = UIImage(named: "ic_arr_down")
        }else{
            self.imgDown.image = UIImage(named: "ic_arrow_up")
        }
    }
    
}
