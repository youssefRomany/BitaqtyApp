//
//  LiveChatVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/17/21.
//

import UIKit
import LiveChat

class LiveChatVC: UIViewController, LiveChatDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        LiveChat.delegate = self
        LiveChat.customPresentationStyleEnabled = true
        if let user = DataService.getUserData(), let userinfo = user.reseller{
            LiveChat.name = userinfo.fullName
            LiveChat.email = user.accountType == Roles.MASTER_ACCOUNT.rawValue ? userinfo.email : userinfo.parentResellerEmail
            LiveChat.setVariable(withKey:"Mobileno", value: userinfo.mobileNumber ?? "")
        }
        let vc = LiveChat.chatViewController!
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.present(LiveChat.chatViewController!, animated: false) {
                print("Presentation completed")
            }
        }
        // Do any additional setup after loading the view.
    }

    func chatDismissed() {
        LiveChat.chatViewController!.dismiss(animated: false) {  [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
