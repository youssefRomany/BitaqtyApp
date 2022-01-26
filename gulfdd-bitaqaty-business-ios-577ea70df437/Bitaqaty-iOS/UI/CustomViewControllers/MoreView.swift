//
//  MoreView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/13/21.
//

import Foundation
import UIKit

class MoreView: UIView {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbl: LblMediumSemiBoldFont!
    @IBOutlet weak var lblDesc: LblSmallRegularFont!
    @IBOutlet weak var arrow: UILabel!
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var stackDetails: UIStackView!
    @IBOutlet weak var iconDetails: UIImageView!
    @IBOutlet weak var lblDetails: LblMediumSemiBoldFont!
    
    weak var delegate: OnFinishDelegate? = nil
    var showDetails = false
    
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
    
    func setData(for image: UIImage, title: String,showDetails: Bool = false,_ tag: Int,_ delegate: OnFinishDelegate){
        lbl.text = title
        icon.image = image
        mainView.tag = tag
        self.delegate = delegate
        arrow.font = UIFont(name: FONT_ICON, size: 20)
        arrow.text = icons.ic_arrow_r.localizedValue
        if (showDetails){
            self.showDetails = true
            lblDetails.text = accountStrings.more_sales_report.localizedValue
            arrow.isHidden = false
        }
        if (tag == 3){
            lblDesc.isHidden = false
            lblDesc.text = strings.current_lang.localizedValue
        }
        if (lang != "en"){
            icon.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @IBAction func headerClicked(_ sender: Any) {
        if (showDetails){
            if (stackDetails.tag == 0){
                stackDetails.tag = 1
                animateDetails(false)
                mainView.backgroundColor = UIColor.accentColor.withAlphaComponent(0.09)
            }else{
                stackDetails.tag = 0
                animateDetails(true)
                mainView.backgroundColor = UIColor.clear
            }
        }else{
            print("headerClicked \(mainView.tag)")
            delegate?.onSuccess(tag: mainView.tag)
        }
    }
    
    @IBAction func detailsClicked(_ sender: Any) {
        print("detailsClicked \(mainView.tag)")
        delegate?.onSuccess(tag: mainView.tag)
    }
    
    
    func animateDetails(_ hide: Bool){
        UIView.animate(withDuration: 0.7,delay: 0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 1,options: [],animations:{
            self.stackDetails.isHidden = hide
            self.arrow.transform = CGAffineTransform(rotationAngle: hide ? 0 : (lang == "en" ? CGFloat.pi : -CGFloat.pi) / 2)
            self.stackMain.layoutIfNeeded()
        },
        completion: nil)
    }
    
}
