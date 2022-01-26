//
//  LanguageCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/13/21.
//

import UIKit

class LanguageCell: UITableViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func selectCell(){
        viewMain.backgroundColor = UIColor.accentColor.withAlphaComponent(0.1)
        viewMain.layer.cornerRadius = 4
        imgCheck.isHidden = false
    }
    
    func unselectCell(){
        viewMain.backgroundColor = UIColor.white
        imgCheck.isHidden = true
    }
}
