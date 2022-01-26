//
//  SavedAccountsCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/9/21.
//

import UIKit

class SavedAccountsCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblBankCountry: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblSenderName: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    var radius: CGFloat = UIDevice.isPad ? 15 : 10
    weak var delegate: SavedAccountsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblBankName.textAlignment = lang == "en" ? .left : .right
        lblBankCountry.textAlignment = lang == "en" ? .left : .right
        lblSenderName.textAlignment = lang == "en" ? .left : .right
        lblAccountNo.textAlignment = lang == "en" ? .left : .right
        self.layer.masksToBounds = false
        viewMain.setupWithRoundNoShadow(10)
        viewHeader.roundedTop(radius: 10)
        btnDelete.layer.cornerRadius = radius
        imgCheck.layer.cornerRadius = radius
        imgCheck.tintColor = .white
    }
    
    
    func selected(){
        imgCheck.backgroundColor = .accentColor
        let image = UIImage(named: "ic_check")?.withRenderingMode(.alwaysTemplate);
        imgCheck.image = image
        imgCheck.layer.borderWidth = 0
        imgCheck.layer.borderColor = UIColor.clear.cgColor
    }
    
    func unselected(){
        imgCheck.backgroundColor = .white
        imgCheck.image = nil
        imgCheck.layer.borderWidth = 1
        imgCheck.layer.borderColor = UIColor.lightBorderColor.cgColor
    }
    
    func setupData(_ account: SavedAccount){
        lblBankName.text = account.getBankName()
        lblBankCountry.text = account.getCountryNameWithBrackets()
        lblSenderName.text = account.getSenderName()
        lblAccountNo.text = account.bankAccountNumber
        if account.isSelected() {
            selected()
        }else{
            unselected()
        }
    }
    
    @IBAction func deleteAccount(_ sender: UIButton) {
        delegate?.onDeleteClicked(index: sender.tag)
    }
    

}
