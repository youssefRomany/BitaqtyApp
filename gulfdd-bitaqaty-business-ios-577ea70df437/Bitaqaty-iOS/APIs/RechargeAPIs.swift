//
//  RechargeApis.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/3/21.
//

import Foundation
import Alamofire


class RechargeAPIs{
    static func getResellerRechargeMethods(_ completed: @escaping ([RechargeMethod])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGE_API.RESELLER_RECHARGE_METHODS)";
                    print(url)
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([RechargeMethod].self, from: result);
                                    if data.count > 0{
                                        completed(data.sorted(by: { obj1, obj2 in
                                            return obj1.getDisplayOrder() < obj2.getDisplayOrder()
                                        }))
                                    }else{
                                        failed(ErrorMessage(errorMsgs.no_data.localizedValue));
                                    }
                                }catch{
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue, "\(ErrorType.Network.rawValue)"))
            }
        }
    }
    
    static func getAmountAfter(rechargeMethod: RechargeMethod, amount: Double, _ completed: @escaping (TransferAmount)->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGE_API.GET_AMOUNT_AFTER)";
                    
                    var params = Parameters()
                    
                    let request = RechargeTransferData(method: rechargeMethod, amount: amount)
                    do {
                        params = try! request.asDictionary()
                    } catch _{
                        failed(ErrorMessage(errorMsgs.server.localizedValue))
                    }
                    Alamofire.request(url, method: .post,parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(TransferAmount.self, from: result);
                                    completed(data)
                                }catch{
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue, "\(ErrorType.Network.rawValue)"))
            }
        }
    }
    static func getCheckOutId(rechargeMethod: RechargeMethod, amount: Double, payPalDenomination: PayPalDenomination? = nil, _ completed: @escaping (CheckOutResult)->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGE_API.GET_CHECKOUT_ID)";
                    
                    var params = Parameters()
            let  request = RechargeTransferData(method: rechargeMethod, amount: amount)
                    if payPalDenomination != nil{
                        request.PayPalDenominationDto = payPalDenomination!
                    }
                    do {
                        params = try! request.asDictionary()
                        print(params)
                    } catch _{
                        failed(ErrorMessage(errorMsgs.server.localizedValue));
                    }
                    Alamofire.request(url, method: .post,parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(CheckOutResult.self, from: result);
                                    if !data.CheckoutId.isEmpty{
                                        completed(data)
                                    }else{
                                        if data.errors != nil && data.errors!.count > 0{
                                            if data.errors!.count > 1{
                                                failed(ErrorMessage(ERROR_CODES.init(rawValue: data.errors![1].errorCode)!.message, data.errors![1].errorCode))
                                            }else{
                                                failed(ErrorMessage(ERROR_CODES.init(rawValue: data.errors![0].errorCode)!.message, data.errors![0].errorCode))
                                            }
                                        }else{
                                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                                        }
                                    }
                                }catch{
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue, "\(ErrorType.Network.rawValue)"))
            }
        }
    }
    static func getPaymentStatus(rechargeMethod: RechargeMethod, amount: String,checkoutId: String,paypalDenomation: PayPalDenomination? = nil, _ completed: @escaping ()->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGE_API.GET_PAYMENT_STATUS)";
                    var params = Parameters()
                    let request = PaymentStatusRequest(method: rechargeMethod, amount: amount, checkoutId: checkoutId, disciminatorValue: rechargeMethod.DiscriminatorValue, chargingCode: rechargeMethod.ChargingCode)
                    if(paypalDenomation != nil){
                        request.PayPalDenominationDto = paypalDenomation
                    }
                    do {
                        params = try! request.asDictionary()
                        print(params)
                    } catch _{
                        failed(ErrorMessage(errorMsgs.server.localizedValue));
                    }
                    print(params)
                    Alamofire.request(url, method: .post,parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                if let returnData = String(data: result, encoding: .utf8) {
                                          print("DATA = \(returnData)")
                                        } else {
                                          print("COULDN")
                                        }
                                do{
                                    let data = try JSONDecoder().decode(PaymentStatusError.self, from: result);
                                    if data.body == "SUCCESS"{
                                        AccountServices.getProfile {
                                            NotificationCenter.default.post(name: .reloadBalance, object: nil)
                                            completed()
                                        } _: {
                                            completed()
                                        }
                                    }else{
                                        failed(ErrorMessage(errorMsgs.server.localizedValue));
                                    }
                                }catch  let e as NSError{
                                    print("error: \(e)")
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue, "\(ErrorType.Network.rawValue)"))
            }
        }
    }
    static func getPayPalDenominations(_ completed: @escaping ([PayPalDenomination])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGE_API.GET_PAYPAL_DENOMANATIONS)";
                    print(url)
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([PayPalDenomination].self, from: result);
                                    let _ = print("Noura \(data.count)")
                                    if data.count > 0{
                                        completed(data)
                                    }else{
                                        failed(ErrorMessage(errorMsgs.no_data.localizedValue));
                                    }
                                }catch{
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue, "\(ErrorType.Network.rawValue)"))
            }
        }
    }
    static func getPayPalAmountAfter(rechargeMethod: RechargeMethod, amount: Double,payPalDenomination: PayPalDenomination, _ completed: @escaping (PayPalDenomination)->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGE_API.GET_PAYPAL_AMOUNT)";
                    
                    var params = Parameters()
                    
                    let request = RechargeTransferData(method: rechargeMethod, amount: amount)
                    request.PayPalDenominationDto = payPalDenomination
                    do {
                        params = try request.asDictionary()
                    } catch _{
                        failed(ErrorMessage(errorMsgs.server.localizedValue))
                    }
                    print(params)
                    Alamofire.request(url, method: .post,parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(PayPalDenomination.self, from: result);
                                    completed(data)
                                }catch{
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue, "\(ErrorType.Network.rawValue)"))
            }
        }
    }
}
