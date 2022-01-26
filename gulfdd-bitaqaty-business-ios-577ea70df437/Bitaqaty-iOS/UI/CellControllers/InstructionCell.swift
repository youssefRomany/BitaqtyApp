//
//  InstructionCell.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/30/21.
//

import UIKit

class InstructionCell: UITableViewCell {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var viewIcon: UIView!
    let radius: CGFloat = UIDevice.isPad ? 15 : 12.5
    override func awakeFromNib() {
        super.awakeFromNib()
        viewIcon.layer.cornerRadius = radius
        viewIcon.layer.borderWidth = radius / 2.5
        viewIcon.layer.borderColor = UIColor.white.cgColor
        viewIcon.setupShadowsWithRound(radius)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
