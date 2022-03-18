//
//  ManageSubAccountCell.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/26/21.
//

import UIKit

class ManageSubAccountCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblTypeTitle: UILabel!
    @IBOutlet weak var lblTypeValue: UILabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblStatusValue: UILabel!
    @IBOutlet weak var lblEnabledTitle: UILabel!
    @IBOutlet weak var lblEnabledValue: UILabel!
    @IBOutlet weak var btnTransLog: UIButton!
    @IBOutlet weak var btnManage: UIButton!
    
    weak var delegate: ManageSubAccountDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    func setupUI(){
        viewContainer.setupShadowsWithRound(4)
        btnTransLog.setupShadowsWithRound(3)
        btnManage.drawBorder(.accentColor, 3, 1)
        btnManage.setupShadows()
        
        lblTypeTitle.text = manageStrings.accountType.localizedValue
        lblStatusTitle.text = manageStrings.status.localizedValue
        lblEnabledTitle.text = manageStrings.purchasing_limit.localizedValue
        
        btnTransLog.setTitle(strings.TransactionLog.localizedValue, for: .normal)
        btnManage.setTitle(manageStrings.manage.localizedValue, for: .normal)

    }
    func setData(user: UserInfo){
        lblUserName.text = user.Username.isEmpty ? user.email : user.Username
        lblFullName.text = user.fullName
        lblTypeValue.text = SUB_ACCOUNT_TYPE.init(rawValue: (user.subAccountDetailsDTO?.SubResellerType)!)?.title
        if user.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue{
            lblTypeValue.text = strings.periodic_limit.localizedValue
        }
        
        var status = manageStrings.disabled.localizedValue
        
        if (!user.accountLocked!) {
            status = manageStrings.enabled.localizedValue
        }
        lblStatusValue.text = status
        lblEnabledValue.text = ""
        if user.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.LIMIT.rawValue || user.subAccountDetailsDTO?.SubResellerType == SUB_ACCOUNT_TYPE.PERIODIC_LIMIT.rawValue{
            lblEnabledValue.text = "\(formatted: user.subAccountDetailsDTO!.Purchaselimit) \(user.Currency)"
        } 
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func onManageClicked(_ sender: Any) {
        if delegate != nil{
            delegate!.onManage(index: self.tag)
        }
    }
    @IBAction func onTransClicked(_ sender: Any) {
        if delegate != nil{
            delegate!.onTransactionLog(index: self.tag)
        }
    }
}
