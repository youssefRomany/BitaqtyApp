//
//  DataService.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
import AlamofireImage
import SwiftKeychainWrapper


class DataService {
    static let ds = DataService();
    
    func isConnectedToNetwork(completed:  @escaping (Bool)->()) {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            completed(false);
            return;
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            completed(false)
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return completed(isReachable && !needsConnection);
    }
    
    func confirmationAlert(_ vc: UIViewController,_ msg: String,okHandler: @escaping (UIAlertAction)->(),cancelHandler: @escaping (UIAlertAction)->()){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: msgs.yes.localizedValue, style: .default, handler: okHandler);
        let cancelAction = UIAlertAction(title: msgs.cancel.localizedValue, style: .default, handler: cancelHandler)
        cancelAction.setValue(UIColor.accentColor, forKey: "titleTextColor");
        alert.addAction(action);
        alert.addAction(cancelAction);
        alert.view.tintColor = UIColor.textColor
        vc.present(alert, animated: true);
    }
    
    
    func showDetailedAlert(_ vc: UIViewController,_ msg: String,btn1Txt: String,btn2Txt: String,type: AlertType = .none,btn1Handler: @escaping ()->(),btn2Handler: @escaping ()->()){
        let alert = AlertVC(nibName: "AlertVC", bundle: nil)
        alert.modalPresentationStyle = .overCurrentContext
        alert.setupData(type: type, msg: msg, btn1Txt: btn1Txt,btn2Txt: btn2Txt,onClick1: btn1Handler,onClick2: btn2Handler)
        vc.present(alert, animated: false, completion: nil)
    }
    
    func showAlert(_ vc: UIViewController,_ msg: String,btn1Txt: String,type: AlertType = .none,btn1Handler: @escaping ()->()){
        let alert = AlertVC(nibName: "AlertVC", bundle: nil)
        alert.modalPresentationStyle = .overCurrentContext
        alert.setupData(type: type, msg: msg,btn1Txt: btn1Txt,onClick1: btn1Handler)
        vc.present(alert, animated: false, completion: nil)
    }
    
    func showAlert(_ vc: UIViewController,_ msg: String,type: AlertType = .none,btn1Handler: @escaping ()->()){
        let alert = AlertVC(nibName: "AlertVC", bundle: nil)
        alert.modalPresentationStyle = .overCurrentContext
        alert.setupData(type: type, msg: msg,onClick1: btn1Handler)
        vc.present(alert, animated: false, completion: nil)
    }
    
    func showAlert(_ vc: UIViewController,_ msg: String,_ type: AlertType = .warning){
        let alert = AlertVC(nibName: "AlertVC", bundle: nil)
        alert.modalPresentationStyle = .overCurrentContext
        alert.setupData(type: type, msg: msg)
        vc.present(alert, animated: false, completion: nil)
    }
    
    func retryAlert(_ vc: UIViewController,_ msg: String,okHandler: @escaping ()->(),cancelHandler: @escaping ()->()){
        let alert = AlertVC(nibName: "AlertVC", bundle: nil)
        alert.modalPresentationStyle = .overCurrentContext
        alert.setupData(type: .warning, msg: msg, btn1Txt: msgs.retry.localizedValue, btn2Txt:  msgs.cancel.localizedValue, onClick1: okHandler, onClick2: cancelHandler)
        vc.present(alert, animated: true);
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func ShowToast (msg: String,view: UIView){
        let subView = UIView()
        subView.layer.cornerRadius = 2;
        subView.layer.shadowColor = UIColor.darkGray.cgColor;
        subView.layer.shadowOpacity = 0.8
        subView.layer.shadowRadius = 4;
        subView.layer.shadowOffset = .zero
        subView.backgroundColor = UIColor(red: 55 / 255, green: 55 / 255, blue: 55 / 255, alpha: 1.0)
        let lbl = UILabel()
        lbl.frame.origin.x = 8;
        lbl.frame.origin.y = 8;
        lbl.textColor = .white;
        lbl.font = UIFont(name: "Helvetica", size: 12)
        lbl.text = msg;
        lbl.numberOfLines = 0;
        lbl.sizeToFit()
        subView.frame = CGRect(x: ((view.bounds.width) - (lbl.frame.width + 16)) / 2, y: view.bounds.height - (lbl.frame.height + 60), width: lbl.frame.width + 20, height: lbl.frame.height + 16)
        lbl.textAlignment = .center;
        subView.addSubview(lbl);
        view.addSubview(subView)
        view.bringSubviewToFront(subView)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeToast(timer:)), userInfo: subView, repeats: false);
    }
    
    @objc func removeToast(timer: Timer){
        let view = timer.userInfo as! UIView;
        view.removeFromSuperview();
    }
    
    static func loadHome(sessionEnded: Bool = false){
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        if let user = getUserData()?.reseller{
            if user.AcceptAgreement{
                let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNAvigation") as! UINavigationController
                mainVC.setStatusBar(color: .accentColor)
                sceneDelegate.window?.rootViewController = mainVC
            }else{
                sceneDelegate.window?.rootViewController = AgreementVC(nibName: "AgreementVC", bundle: nil)
            }
        }else{
            let vc = LoginVC(nibName: "LoginVC", bundle: nil)
            vc.sessionEnded = sessionEnded
            sceneDelegate.window?.rootViewController = vc
        }
    }
    static func getHeader() -> HTTPHeaders{
        print("getDeviceId() \(getDeviceId())")
        var headers: HTTPHeaders!;
        let userData = getUserData()
        if let userData = userData, var token = userData.token{
            if (!token.hasPrefix("Bearer")){
                token = "Bearer \(token)"
            }
            print("\(userData.token!)")
            print("\(userData.reseller!.id!)")
            headers = [
                "Authorization": "\(token)",
                "Accept": "application/json",
                "OS" : "IOS",
                "locale": lang,
                "Accept-Language": lang,
                "device-id": getDeviceId(),
                "Application-name" : "BITAQATY_BUSINESS_MOBILE" // ""
            ];
        }else{
            headers = [
                "Accept": "application/json",
                "locale": lang,
                "OS" : "IOS",
                "Accept-Language": lang,
                "device-id": getDeviceId(),
                "Application-name" : "BITAQATY_BUSINESS_MOBILE" // "BITAQATY_BUSINESS_MOBILE"
            ];
        }
        return headers;
    }
    
    static func saveLoginToken(_ loginToken: String){
        let splitedToken = loginToken.split(separator: "/")
        var token = loginToken
        if splitedToken.count > 0{
            token = "\(splitedToken[0])"
        }
        KeychainWrapper.standard.set(token, forKey: LOGIN_TOKEN, withAccessibility: .none)
    }
    
    static func getDeviceId() -> String{
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
        //return "F9CB58C5-10CF-4F0B-8FD8-C95DE3A35B1A"//alia92ziada@gmail.com
        //return "491277AC-0E79-46E5-9573-E939589849BE" // alia92ziada.sub
        //return "016E2A6B-7691-4DDB-AC9F-AB45C0120742" //noha.nasrat+519@onecard.net
        //return "5ba6899af329996"
        //return "8dffdf11a4d22849" //nesma.abdallah@gmail.com P@ssw0rd
        //return "6581EA8E-B344-436B-94C8-3128A7C32648" //IOS RESELLER NOURA
        //return "7ea62e3c0e12652b" // ANDROID RESELLER NOURA
        //return "4184CE9E-DDCF-40CA-A691-2F64F6FAA0D9" //IOS SUB NOURA
        //return "23E43AF1-49DD-4057-863E-69073FA4048F" //noha.nasrat+9945@onecard.net  Aa12345678
        //return "23E43AF1-49DD-4057-863E-69073FA4048F" // aya.hassan+17@onecard.net A123456a
    }
    
    static func getLoginToken() -> String?{
        return KeychainWrapper.standard.string(forKey: LOGIN_TOKEN)
    }
    
    static func setUserData(_ user: User){
        do{
            let data = try JSONEncoder().encode(user)
            KeychainWrapper.standard.set(data, forKey: USER_DATA, withAccessibility: .none);
            if let username = user.reseller?.username{
                KeychainWrapper.standard.set(username, forKey: UserDefaults.Key.USER_NAME, withAccessibility: .none);
            }
        }catch let error{
            print("setUserData error \(error)");
        }
    }
    
    static func getUsername()-> String?{
        if let username = KeychainWrapper.standard.string(forKey: UserDefaults.Key.USER_NAME){
            return username
        }
        return nil;
    }
    
    static func getUserData() -> User?{
        let data = KeychainWrapper.standard.data(forKey: USER_DATA);
        if(data != nil){
            do {
                let user = try JSONDecoder().decode(User.self, from: data!);
                return user
            } catch {
                KeychainWrapper.standard.removeObject(forKey: USER_DATA);
                return nil;
            }
            
        }
        return nil;
    }
    
    static func showCost() -> Bool{
        let user = getUserData()
        return user?.accountType == Roles.MASTER_ACCOUNT.rawValue || user?.reseller?.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_PRODUCT_DISCOUNT.rawValue})?.Enabled == true
    }
    
    static func showAllAccounts() -> Bool{
        let user = getUserData()
        return user?.accountType == Roles.MASTER_ACCOUNT.rawValue || user?.reseller?.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_REPORTS.rawValue})?.ChildPermissions.first(where: {$0.id == 22})?.Enabled == true
    }
    
    static func showSupport() -> Bool{
        let user = getUserData()
        return user?.accountType == Roles.MASTER_ACCOUNT.rawValue || user?.reseller?.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_SUPPORT_CENTER.rawValue})?.Enabled == true
    }
    
    static func showTransactionLog() -> Bool{
        let user = getUserData()
        return user?.accountType == Roles.MASTER_ACCOUNT.rawValue || user?.reseller?.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.VIEW_TRANSACTION_LOG.rawValue})?.Enabled == true
    }
    
    static func cantPurchase() -> Bool{
        let user = getUserData()
        return user?.accountType == Roles.MASTER_ACCOUNT.rawValue || user?.reseller?.PermissionsArr.first(where: {$0.id == PERMISSIONS_IDS.PURCHASE.rawValue})?.Enabled == true
    }
    
    static func deleteUserData(){
        KeychainWrapper.standard.removeObject(forKey: USER_DATA);
    }
    static func copyObject(user: UserInfo) -> UserInfo?{
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            //let json = String(data: jsonData, encoding: String.Encoding.utf8)
           // let _ = print("Noura \(json)")
            let jsonDecoder = JSONDecoder()
            let newObject = try jsonDecoder.decode(UserInfo.self, from: jsonData)
            return newObject
        }catch {
            return nil
        }
    }
    static func setCardData(_ cardData: CardData, type: Int){
        do{
            let data = try JSONEncoder().encode(cardData)
            var key = RechargeTypes.init(rawValue: type)?.brandName
            if let user = getUserData(), let reseller = user.reseller{
                key = "\(key!)_\(reseller.id!)"
            }
            KeychainWrapper.standard.set(data, forKey: key!, withAccessibility: .none);
        }catch let error{
            print("setCardDataError error \(error)");
        }
    }
    
    static func getCartData(type: Int) -> CardData?{
        var key = RechargeTypes.init(rawValue: type)?.brandName
        if let user = getUserData(), let reseller = user.reseller{
            key = "\(key!)_\(reseller.id!)"
        }
        let data = KeychainWrapper.standard.data(forKey: KeychainWrapper.Key(rawValue: key!));
        if(data != nil){
            do {
                let cardData = try JSONDecoder().decode(CardData.self, from: data!);
                return cardData
            } catch {
                KeychainWrapper.standard.removeObject(forKey: key!);
                return nil;
            }
            
        }
        return nil;
    }
    
    static func deleteCardData(type: Int){
        var key = RechargeTypes.init(rawValue: type)?.brandName
        if let user = getUserData(), let reseller = user.reseller{
            key = "\(key!)_\(reseller.id!)"
        }
        KeychainWrapper.standard.removeObject(forKey: key!);
    }
    func downloadImageWithoutExtension(urlStr: String, imageView: UIImageView){
        let url = URL(string: urlStr)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
              guard let data = data, error == nil else { return }
              
              DispatchQueue.main.async { /// execute on main thread
                  imageView.image = UIImage(data: data)
              }
          }
          
          task.resume()
//
//        let dataTask = URLSession.shared.dataTask(with: url) {(data, _, err) in
//            let _ = print("Noura \(err?.localizedDescription) \(urlStr)")
//              if let data = data {
//                  DispatchQueue.main.async {
//                    imageView.image = UIImage(data: data)
//                  }
//              }
//          }
//          dataTask.resume()
    }
    static func getCurrentCurency()-> String{
        if let user = getUserData()?.reseller{
            return user.Currency
        }
        return ""
    }
    
    
    static func getDate(from position: Int) -> String?{
        switch position{
        case 0:
           return DATE.CURRENT_MONTH.rawValue
        case 1:
           return DATE.LAST_MONTH.rawValue
        case 2:
           return DATE.LAST_SEVEN_DAYS.rawValue
        case 3:
           return DATE.YESTERDAY.rawValue
        case 4:
           return DATE.TODAY.rawValue
        default:
            return nil
        }
    }
    static func getChannel(from position: Int) -> String?{
        switch position{
        case 1:
            return CHANNEL_CODES.PORTAL.rawValue
        case 2:
           return CHANNEL_CODES.POS.rawValue
        case 3:
           return CHANNEL_CODES.INTEGRATION.rawValue
        case 4:
           return CHANNEL_CODES.WALLET.rawValue
        default:
            return nil
        }
    }
}
