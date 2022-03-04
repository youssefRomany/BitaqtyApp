//
//  SplashView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/22/21.
//

import Foundation
import Lottie
import Kingfisher

class SplashView: UIViewController{

    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lblCR: UILabel!
    @IBOutlet weak var splashLogo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAnimationView()
        lblCR.text = strings.CRText.localizedValue
        if lang == "en"{
            lblCR.text = "Copyright © 2020 \(WhiteLabelLocal.shared.getLocalGoldRateList()?.nameEn ?? "") business. All rights reserved."
        }else{
            lblCR.text = "© 2020 \(WhiteLabelLocal.shared.getLocalGoldRateList()?.nameEn ?? "") جميع الحقوق محفوظة لصالح"
        }
        loadSettings()
        setImageView(forImageView: splashLogo, andURL: WhiteLabelLocal.shared.getLocalGoldRateList()?.logoPath ?? "", andPlaceHolderImage: "")
    }
    func loadSettings(){        
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

public func setImageView(forImageView imageView: UIImageView, andURL url: String, andPlaceHolderImage placeholder: String){
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(with: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), placeholder: UIImage(named: placeholder))

}
