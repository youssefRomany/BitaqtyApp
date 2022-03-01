//
//  SplashView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/22/21.
//

import Foundation
import Lottie

class SplashView: UIViewController{

    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lblCR: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setAnimationView()
        lblCR.text = strings.CRText.localizedValue
        loadSettings()
        
    }
    func loadSettings(){
        AccountServices.requestWhiteLAbel(self)
        
        if let _ = DataService.getUserData(){
            GeneralAPIs.getSettings {
                AccountServices.getProfile {
                    self.loadHome()
                } _: {
                    self.loadHome(true)
                }
            } _: { (err) in
                self.loadHome(true)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadHome()
            }
        }
    }
    
    func setAnimationView(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        let keypath = AnimationKeypath(keys: ["**", "Fill 1", "**", "Color"])
        let colorProvider = ColorValueProvider(UIColor.accentColor.lottieColorValue)
        animationView.setValueProvider(colorProvider, keypath: keypath)
        animationView.play()
    }
    
    func loadHome(_ resetAccess: Bool = false){
        if resetAccess {
            DataService.deleteUserData()
        }
        DataService.loadHome(sessionEnded: resetAccess)
    }
}

extension SplashView: OnFinishDelegate {
    func onSuccess(_ model: WhiteLabelResp) {
        print("rrrrrrr", model)
    }

}
