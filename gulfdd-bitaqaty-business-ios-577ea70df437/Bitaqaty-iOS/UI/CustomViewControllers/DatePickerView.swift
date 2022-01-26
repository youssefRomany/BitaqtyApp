//
//  DatePickerView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import UIKit

class DatePickerView: UIView {
    @IBOutlet weak var btnFrom: BtnSmallRegularFont!
    @IBOutlet weak var btnTo: BtnSmallRegularFont!
    @IBOutlet weak var btnClearFrom: UIButton!
    @IBOutlet weak var btnClearTo: UIButton!
    
    weak var delegate: DatePickerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
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
        btnFrom.layer.cornerRadius = 4
        btnFrom.setTitle(msgs.from.localizedValue, for: .normal)
        
        btnTo.layer.cornerRadius = 4
        btnTo.setTitle(msgs.to.localizedValue, for: .normal)
    }
    
    @IBAction func selectDate(_ sender: UIButton) {
        if (sender.tag == 1){
            delegate?.getFromDate()
        }else{
            delegate?.getToDate()
        }
        
    }
    
    @IBAction func clearDate(_ sender: UIButton) {
        if (sender.tag == 1){
            btnClearFrom.isHidden = true
            btnFrom.setTitle(msgs.from.localizedValue, for: .normal)
            delegate?.clearFromDate()
        }else{
            btnClearTo.isHidden = true
            btnTo.setTitle(msgs.to.localizedValue, for: .normal)
            delegate?.clearToDate()
        }
    }
    
    func setFromDate(_ date: String){
        btnFrom.setTitle(date, for: .normal)
        btnClearFrom.isHidden = false
    }
    
    func setToDate(_ date: String){
        btnTo.setTitle(date, for: .normal)
        btnClearTo.isHidden = false
    }
}
protocol DatePickerDelegate: AnyObject {
    func getFromDate()
    func getToDate()
    func clearFromDate()
    func clearToDate()
}
