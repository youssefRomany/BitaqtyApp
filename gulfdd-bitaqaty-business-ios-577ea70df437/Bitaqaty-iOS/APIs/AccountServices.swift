//
//  AccountServices.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/12/21.
//

import Foundation
import Alamofire

class AccountServices {
    static func validateAndLogin(_ username: String,_ password: String,_ delegate: OnFinishDelegate){
        var valid = true
        if (username.isEmpty){
            valid = false
            delegate.onBadRequest(errorMsgs.field_required.localizedValue, 0);
        }
        if (password.isEmpty){
            valid = false
            delegate.onBadRequest(errorMsgs.field_required.localizedValue, 1);
        }
        
        if (valid){
            login(username,password,delegate);
        }
    }
    
    private static func login(_ username: String,_ password: String,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                let url = "\(API.BASE_URL)\(AUTH_API.login)";
                let param = ["username": username,"password": password]
                print(url)
                print(param)
                Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData{ response in
                    if let result = response.result.value, response.response?.statusCode == 200{
                        do{
                            let dataResult = try JSONDecoder().decode(DataResult.self, from: result)
                            if let loginToken = dataResult.loginProcessToken{
                                DataService.saveLoginToken(loginToken)
                            }
                            print(dataResult,"rrrrrrrr")
                            if let errors = dataResult.errors{
                                delegate.onFailed(err: ServiceError(errors))
                            }else{
                                authenticatedLogin(delegate)
                            }
                        }catch{
                            delegate.onFailed(err: .other)
                        }
                    }else{
                        delegate.onFailed(err: .other)
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    
    static func requestWhiteLAbel(_ delegate: OnFinishDelegate){

        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let token = DataService.getLoginToken(){
                    let url = "\(API.BASE_URL)\(AUTH_API.whiteLabel)"
                    //let param = ["loginProcessToken": token]

                    var request = URLRequest(url: URL(string: url)!)
                    request.httpMethod = HTTPMethod.post.rawValue
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                    let pjson = "whitelabel.ocstaging.net"
                    let data = (pjson.data(using: .utf8))! as Data

                    request.httpBody = data

                    Alamofire.request(request).responseData { (response) in
                        if let result = response.result.value, response.response?.statusCode == 200{
                            do{
                                let resp = try JSONDecoder().decode(WhiteLabelResp.self, from: result)
                                if let _ = resp.id{
                                    print(resp, "hhhhhhhhhhhh")
                                    WhiteLabelLocal.shared.appendValueToLocalWhiteLabelList(whiteLabel: resp)
                                    delegate.onSuccess()
                                }else if let errors = resp.errors{
                                    print(resp, "hhhhhhhhhhhh errrr")

//                                    delegate.onFailed(err: ServiceError(errors))
                                }else{
                                    print( "hhhhhhhhhhhh faild")

                                    delegate.onFailed(err: .other)
                                }
                            }catch{
                                print ("hhhhhhhhhhhh other")

                                delegate.onFailed(err: .other)
                            }
                        }else{
                            print(response, "hhhhhhhhhhhh els")
                            print(response.response, "hhhhhhhhhhhh els")
                            print(response.response?.statusCode, "hhhhhhhhhhhh els")

                            delegate.onFailed(err: .other)
                        }
                    }

                }else{
                    print ("hhhhhhhhhhhh tttttt")

                    delegate.onFailed(err: .custom(ErrorMessage(errorMsgs.session_ended.localizedValue)))
                }
            }else{
                print ("hhhhhhhhhhhh mmmmm")

                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func authenticatedLogin(_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let token = DataService.getLoginToken(){
                    let url = "\(API.BASE_URL)\(AUTH_API.authenticated_login)"
                    let param = ["loginProcessToken": token]
                    print("url \(url)")
                    print("param \(param)")
                    Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData{ response in
                        if let result = response.result.value, response.response?.statusCode == 200{
                            do{
                                let user = try JSONDecoder().decode(User.self, from: result)
                                if let _ = user.reseller{
                                    DataService.setUserData(user)
                                    delegate.onSuccess()
                                }else if let errors = user.errors{
                                    delegate.onFailed(err: ServiceError(errors))
                                }else{
                                    delegate.onFailed(err: .other)
                                }
                            }catch{
                                delegate.onFailed(err: .other)
                            }
                        }else{
                            delegate.onFailed(err: .other)
                        }
                    }
                }else{
                    delegate.onFailed(err: .custom(ErrorMessage(errorMsgs.session_ended.localizedValue)))
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func validateAndChangePassword(_ current: String?,_ resetPasswordToken: String?,_ new: String,_ conf: String,_ delegate: OnFinishDelegate){
        var valid = true
        if let currentPassword = current{
            if currentPassword.isEmpty {
                valid = false
                delegate.onBadRequest(errorMsgs.field_required.localizedValue, 0)
            }
        }
        if (new.isEmpty){
            valid = false
            delegate.onBadRequest(errorMsgs.field_required.localizedValue, 1)
        }else if (!validPassword(new)){
            valid = false
            delegate.onBadRequest(errorMsgs.invalid_password.localizedValue, 2)
        }
        if (!new.isEmpty){
            if (conf.isEmpty){
                valid = false
                delegate.onBadRequest(errorMsgs.field_required.localizedValue, 3)
            }else if (conf != new){
                valid = false
                delegate.onBadRequest(errorMsgs.passwords_mismatch.localizedValue, 3)
            }
        }
        if (valid){
            changePassword(current,resetPasswordToken,new,conf,delegate)
        }
    }
    
    private static func changePassword(_ current: String?,_ resetPasswordToken: String?,_ new: String,_ conf: String,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if (connectionSuccess){
                var url = "\(API.BASE_URL)\(AUTH_API.login_change_password)"
                var param = ["newPassword": new,"confirmNewPassword": conf]
                if let currentPassword = current, let user = DataService.getUserData()?.reseller{
                    url = "\(API.BASE_URL)\(AUTH_API.change_password)"
                    param["username"] = user.username
                    param["password"] = currentPassword
                }else if let token = resetPasswordToken{
                    url = "\(API.BASE_URL)\(AUTH_API.reset_change_password)"
                    param["resetPasswordToken"] = token
                } else{
                    url = "\(API.BASE_URL)\(AUTH_API.login_change_password)"
                    if let loginToken = DataService.getLoginToken(){
                        param["loginProcessToken"] = loginToken
                    }else{
                        delegate.onFailed(err: .custom(ErrorMessage(errorMsgs.session_ended.localizedValue)))
                    }
                }
                print(url)
                print(param)
                Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response  in
                    if let statusCode = response.response?.statusCode{
                        if (statusCode == 200){
                            if let data = response.result.value{
                                do{
                                    let dataResult = try JSONDecoder().decode(DataResult.self, from: data)
                                    if let errors = dataResult.errors,!errors.isEmpty{
                                        delegate.onFailed(err: .custom(errors[0]))
                                        return;
                                    }
                                }catch{}
                            }
                            delegate.onSuccess()
                        }else if (statusCode == 401){
                            delegate.onFailed(err: .unauthorized)
                        }else{
                            
                        }
                    }else{
                        delegate.onFailed(err: .other)
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func validPassword(_ password: String) -> Bool{
        if (!password.containNumbers()){
            return false
        }else if (!password.containCapitalLetter()){
            return false
        }else if (!password.containSmallLetter()){
            return false
        }else if (!password.isEnglishOnly()){
            return false
        }else if (password.count < 8){
            return false
        }
        return true
    }
    
    static func validateAndResetPassword(_ email: String,_ delegate: OnFinishDelegate){
        if (email.isEmpty){
            delegate.onBadRequest(errorMsgs.field_required.localizedValue, 0)
//        }else if (!email.isEmail()){
//            delegate.onBadRequest(errorMsgs.invalid_email.localizedValue, 0)
        }else{
            resetPassword(email, delegate)
        }
    }
    
    private static func resetPassword(_ email: String,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if (connectionSuccess){
                let url = "\(API.BASE_URL)\(AUTH_API.forget_password)"
                let param = ["email": email]
                print(url)
                print(param)
                Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response  in
                    if let statusCode = response.response?.statusCode, statusCode == 200{
                        if let data = response.result.value, let result = try? JSONDecoder().decode(DataResult.self, from: data){
                            if result.errors != nil{
                                delegate.onFailed(err: .other)
                            }else{
                                delegate.onSuccess()
                            }
                        }else{
                            delegate.onSuccess()
                        }
                    }else{
                        delegate.onFailed(err: .other)
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func getRemeaniningTrials(_ invalidCode: Bool = false,_ delegate: OnFinishDelegate){
        if let token = DataService.getLoginToken(){
            DataService.ds.isConnectedToNetwork { connectionSuccess in
                if (connectionSuccess){
                    let url = "\(API.BASE_URL)\(AUTH_API.remaining_trials)"
                    let param = ["loginProcessToken": token]
                    print(url)
                    print(param)
                    Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader())
                        .responseData{ response in
                            if let data = response.result.value, response.response?.statusCode == 200{
                                do{
                                    let model = try JSONDecoder().decode(RemainingTrials.self, from: data)
                                    if let errors = model.errors,!errors.isEmpty{
                                        delegate.onFailed(err: .custom(errors[0]))
                                    }else{
                                        delegate.onSuccess(model)
                                        if (invalidCode){
                                            delegate.onFailed(err: .custom(ErrorMessage("",API_ERRORS.InvalidSmsVerificationCode.rawValue)))
                                        }
                                    }
                                }catch{
                                    delegate.onFailed(err: .other)
                                }
                            }else{
                                delegate.onFailed(err: .other)
                            }
                        }
                }else{
                    delegate.onFailed(err: .noInternetConnection)
                }
            }
        }else{
            delegate.onFailed(err: .custom(ErrorMessage(errorMsgs.session_ended.localizedValue)))
        }
    }
    
    static func validateAndVerify(code: String, _ delegate: OnFinishDelegate){
        if (code.isEmpty){
            delegate.onBadRequest(errorMsgs.field_required.localizedValue, 0)
        }else{
            verify(code,delegate)
        }
    }
    
    private static func verify(_ code: String, _ delegate: OnFinishDelegate){
        if let token = DataService.getLoginToken(){
            DataService.ds.isConnectedToNetwork { connectionSuccess in
                if (connectionSuccess){
                    let url = "\(API.BASE_URL)\(AUTH_API.validate_sms_code)"
                    let param = ["loginProcessToken": token, "smsVerificationCode": code]
                    print(url)
                    print(param)
                    Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader())
                        .responseData{ response in
                            if let data = response.result.value, response.response?.statusCode == 200{
                                do{
                                    let user = try JSONDecoder().decode(User.self, from: data)
                                    if let _ = user.reseller{
                                        DataService.setUserData(user);
                                        delegate.onSuccess()
                                    }else if let errors = user.errors, !errors.isEmpty{
                                        if errors[0].errorCode == API_ERRORS.InvalidSmsVerificationCode.rawValue {
                                            getRemeaniningTrials(true,delegate)
                                        }else{
                                            delegate.onFailed(err: .custom(errors[0]))
                                        }
                                    }else{
                                        delegate.onFailed(err: .other)
                                    }
                                }catch let err{
                                    print("\(err)")
                                    delegate.onFailed(err: .other)
                                }
                            }else{
                                delegate.onFailed(err: .other)
                            }
                        }
                }else{
                    delegate.onFailed(err: .noInternetConnection)
                }
            }
        }else{
            delegate.onFailed(err: .custom(ErrorMessage(errorMsgs.session_ended.localizedValue)))
        }
    }
    
    static func acceptAgreement( _ delegate: OnFinishDelegate){
        if var user = DataService.getUserData(),let userData = user.reseller{
            DataService.ds.isConnectedToNetwork { connectionSuccess in
                if (connectionSuccess){
                    let url = "\(API.BASE_URL)\(AUTH_API.accept_agreement)"
                    let param = ["username": userData.Username]
                    print(url)
                    print(param)
                    Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData{ response in
                        if let statusCode = response.response?.statusCode, statusCode == 200{
                            userData.acceptAgreement = true
                            user.reseller = userData
                            DataService.setUserData(user)
                            delegate.onSuccess()
                        }else{
                            delegate.onFailed(err: .other)
                        }
                    }
                }else{
                    delegate.onFailed(err: .noInternetConnection)
                }
            }
        }else{
            delegate.onFailed(err: .custom(ErrorMessage(errorMsgs.session_ended.localizedValue)))
        }
    }
    
    
    
    static func logout(delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if (connectionSuccess){
                let url = "\(API.BASE_URL)\(AUTH_API.logout)"
                print(url)
                Alamofire.request(url,method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response  in
                    if let statusCode = response.response?.statusCode{
                        if (statusCode == 200){
                            if let data = response.result.value{
                                do{
                                    let dataResult = try JSONDecoder().decode(DataResult.self, from: data)
                                    if let errors = dataResult.errors,!errors.isEmpty{
                                        delegate.onFailed(err: .custom(errors[0]))
                                        return
                                    }
                                }catch{}
                            }
                            delegate.onSuccess()
                        }else if (statusCode == 401){
                            delegate.onFailed(err: .unauthorized)
                        }else{
                            
                        }
                    }else{
                        delegate.onFailed(err: .other)
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func getProfile(_ completed: @escaping ()->(),_ failed: @escaping () -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if (connectionSuccess){
                let url = "\(API.BASE_URL)\(AUTH_API.profile)"
                print(url)
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader())
                    .responseData{ response in
                        if let data = response.result.value, response.response?.statusCode == 200{
                            do{
                                let user = try JSONDecoder().decode(User.self, from: data)
                                if let _ = user.reseller{
                                    DataService.setUserData(user);
                                    completed()
                                }else{
                                    failed()
                                }
                            }catch let err{
                                print("\(err)")
                                failed()
                            }
                        }else{
                            failed()
                        }
                    }
            }else{
                failed()
            }
        }
    }
}
