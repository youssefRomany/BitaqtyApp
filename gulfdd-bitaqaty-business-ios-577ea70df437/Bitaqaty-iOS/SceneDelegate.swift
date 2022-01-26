//
//  SceneDelegate.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/22/21.
//

import UIKit
import SwiftUI
import SwiftKeychainWrapper
import IQKeyboardManagerSwift
import LiveChat

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        LiveChat.licenseId = "8646654"
        LiveChat.windowScene = (scene as? UIWindowScene)
        
        if !UserDefaults.standard.bool(forKey: UserDefaults.Key.installedBefore){
            KeychainWrapper.standard.removeObject(forKey: UserDefaults.Key.USER_NAME);
            DataService.deleteUserData()
            UserDefaults.standard.setValue(true, forKey: UserDefaults.Key.installedBefore)
            Bundle.set("en")
        }
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let urlinfo = userActivity.webpageURL{
            print("Universial Link Open at SceneDelegate on App Start ::::::: \(urlinfo)")
        }
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
            let _ = print("Noura HEREEEEEEE")
        }
        
        //deeplink Open
        if connectionOptions.urlContexts.first?.url != nil {
            let urlinfo = connectionOptions.urlContexts.first?.url
            print("Deeplink Open at SceneDelegate on App Start ::::::: \(String(describing: urlinfo))")
            if urlinfo?.scheme?.localizedCaseInsensitiveCompare(Config.urlScheme) == .orderedSame {
                let _ = print("Noura ISIDEE ")
                NotificationCenter.default.post(name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
            }
        }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            self.window?.backgroundColor = .bgColor
            window.makeKeyAndVisible()
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetApp(Notify:)), name: NSNotification.Name(rawValue: UserDefaults.Key.langChanged), object: nil)
        IQKeyboardManager.shared.enable = true;
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true;
        window?.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft;
        navigationBarSettings();
        changeLanguage();
        
        let vc = SplashView(nibName: "SplashView", bundle: nil);
        window?.rootViewController = vc;
    }
    
    // Universial link Open when app is onPause
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let urlinfo = userActivity.webpageURL{
            print("Universial Link Open at SceneDelegate on App Pause  ::::::: \(urlinfo)")
        }
    }
    
    // Deeplink Open when app in onPause
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let urlinfo = URLContexts.first?.url
        print("Deeplink Open on SceneDelegate at App Pause :::::::: \(String(describing: urlinfo))")
        if urlinfo?.scheme?.localizedCaseInsensitiveCompare(Config.urlScheme) == .orderedSame {
            let _ = print("Noura ISIDEE ")
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func navigationBarSettings(){
        let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBar.backgroundColor = .primary
        window?.addSubview(statusBar)
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //appearance.shadowImage = UIImage()
        appearance.backgroundColor = .primary
        appearance.barTintColor =  .primary
        appearance.tintColor = .textColor;
        appearance.isTranslucent = true
        appearance.castShadow = ""
        appearance.addShadow(location: .bottom)
        
        var font = UIDevice.current.userInterfaceIdiom == .pad ? 22 : 17
        var attributes = [NSAttributedString.Key.font: UIFont(name: enBold, size: CGFloat(font))!, NSAttributedString.Key.foregroundColor:UIColor.textColor];
        if(lang != "en"){
            font = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 15
            attributes = [NSAttributedString.Key.font: UIFont(name: arBold, size: CGFloat(font))!, NSAttributedString.Key.foregroundColor: UIColor.textColor];
        }
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
    
    func changeLanguage(){
        let langs = UserDefaults.standard.object(forKey: "AppleLanguages")as! [String]
        lang = langs[0].components(separatedBy: "-")[0];
        FONT_LIGHT = lang == "en" ? enLight: arLight;
        FONT_REG = lang == "en" ? enReg: arReg;
        FONT_SEMI_BOLD = lang == "en" ? enSemiBold: arSemiBold;
        FONT_BOLD = lang == "en" ? enBold : arBold;
        
        FONT_SMALLER = FontSize.Smaller.size
        FONT_SMALL = FontSize.Small.size
        FONT_MEDUIM = FontSize.Medium.size
        FONT_LARGE = FontSize.Large.size
        FONT_LARGER = FontSize.Larger.size
        navigationBarSettings();
        
    }
    
    @objc func resetApp(Notify: NotificationCenter){
        changeLanguage();
        DataService.loadHome();
    }
}

