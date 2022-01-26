//
//  ManageSubAccountPurchaseView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/29/21.
//

import UIKit

class ManageSubAccountPurchaseView: UIView {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!
    @IBOutlet weak var imgDesc: UIImageView!
    @IBOutlet weak var btnView: UIButton!

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
        self.viewContainer.accentBoarderWithRound(to: 5)
        imgRadio.tintColor = .secondryColor
        imgDesc.tintColor = .accentColor
        return view as! UIView
    }
    
    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
    }
}
