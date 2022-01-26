//
//  ValidationView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/8/21.
//

import Foundation
import UIKit

class ValidationView: UIView {
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var lblIcon: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    
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
    
    
    func setupData(title: String,tag: Int){
        lblIcon.tag = tag
        lblTitle.text = title
        viewMain.layer.cornerRadius = 15
        setViewState(.normal)
    }
    
    func setViewState(_ type: Validation){
        switch type {
        case .valid:
            lblTitle.textColor = .colorValid
            lblIcon.textColor = .colorValid
            lblIcon.font = UIFont(name: FONT_ICON, size: FONT_SMALLER)
            lblIcon.text = icons.ic_correct.localizedValue
            viewMain.backgroundColor = .fromString("#D9EAE9")
        case .invalid:
            lblTitle.textColor = UIColor.colorInvalid
            lblIcon.textColor = UIColor.colorInvalid
            lblIcon.font = UIFont(name: FONT_ICON, size: FONT_SMALLER)
            lblIcon.text = icons.ic_error.localizedValue
            viewMain.backgroundColor = UIColor.fromString("#B6003B").withAlphaComponent(0.44)
        default:
            lblTitle.textColor = .textColor
            lblIcon.textColor = .textColor
            lblIcon.font = .lightSmaller
            lblIcon.text = "\(lblIcon.tag)"
            viewMain.backgroundColor = UIColor.fromString("#95A7D0").withAlphaComponent(0.41)
        }
    }
}
