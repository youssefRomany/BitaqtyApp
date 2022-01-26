//
//  TermsAndConditionsView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/8/21.
//

import UIKit

class TermsAndConditionsView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInstructions: UILabel!

    @IBOutlet weak var imgDown: UIImageView!
    @IBOutlet weak var viewContainer: UIView!

    @IBOutlet weak var stackContainer: UIStackView!

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

        addSubview(nibView)
    }

}
