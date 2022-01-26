//
//  MoreExtraCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/28/21.
//

import UIKit

class MoreExtraCell: UITableViewCell {
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblArrow: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var lblBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTitle.backgroundColor = .white
        viewTitle.setupShadowsWithRound(8)
        viewBody.setupShadowsWithRound(8)
        lblArrow.text = icons.ic_arrow_r.localizedValue
        self.bringSubviewToFront(viewTitle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
