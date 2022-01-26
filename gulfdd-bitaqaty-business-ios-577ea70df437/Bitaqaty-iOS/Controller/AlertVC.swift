//
//  AlertVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/11/21.
//

import Foundation
import UIKit

class AlertVC: UIViewController {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    var type: AlertType = .none
    var msg: String = ""
    var btn1Txt: String = ""
    var btn2Txt: String = ""
    var onClick1: (() ->())? = nil
    var onClick2: (() ->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI(){
        viewMain.layer.cornerRadius = 8
        switch type {
        case .warning:
            img.isHidden = false
            img.image = #imageLiteral(resourceName: "ic_warning")
        case .success:
            img.isHidden = false
            img.image = #imageLiteral(resourceName: "ic_success")
        default:
            img.isHidden = true
        }
        lbl.text = msg
        btn1.setTitle(btn1Txt, for: .normal)
        if (btn2Txt.isEmpty){
            btn2.isHidden = true
        }else{
            btn2.setTitle(btn2Txt, for: .normal)
        }
    }
    
    func setupData(type: AlertType,msg: String,btn1Txt: String = msgs.doneTxt.localizedValue,btn2Txt: String = "", onClick1: (() ->())? = nil, onClick2: (() ->())? = nil){
        self.type = type
        self.msg = msg
        self.btn1Txt = btn1Txt
        self.btn2Txt = btn2Txt
        self.onClick1 = onClick1
        self.onClick2 = onClick2
    }
    
    
    
    @IBAction func cancel(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btn1Clicked(_ sender: UIButton) {
        dismiss(animated: false){
            self.onClick1?()
        }
    }
    
    @IBAction func btn2Clicked(_ sender: UIButton) {
        dismiss(animated: false){
            self.onClick2?()
        }
    }
    
}
