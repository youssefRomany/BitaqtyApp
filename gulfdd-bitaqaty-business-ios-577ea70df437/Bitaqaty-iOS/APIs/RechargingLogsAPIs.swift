//
//  RechargingLogsAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/29/21.
//

import Foundation
import Alamofire

class RechargingLogsAPIs{
    static func getRechargingLogMethods(_ completed: @escaping ([RechargeMethod])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RECHARGING_LOG_APIs.GET_RECHARGE_LOG_METHODS)";
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([RechargeMethod].self, from: result);
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
    static func getRechargeLogList(_ pageIndex: Int, discriminatorValue: String = "",dateFrom: String = "", dateTo: String = "",_ completed: @escaping ([RechargingLog])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let userData = DataService.getUserData(){
                    let url = "\(API.BASE_URL)\(RECHARGING_LOG_APIs.GET_RECHARGE_LOG_LIST)";
                    let user = userData.reseller!
                    var params = ["pageNumber": pageIndex,
                                  "pageSize": PAGE_SIZE,
                                  "customerId": user.id! as Any] as [String : Any];
                    if !discriminatorValue.isEmpty{
                        params["discriminatorValue"] = discriminatorValue
                    }
                    if !dateFrom.isEmpty{
                        params["dateFrom"] = dateFrom
                    }
                    if !dateTo.isEmpty{
                        params["dateTo"] = dateTo
                    }
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else{
                            if let result = response.result.value {
                                do{
                                    let rechargeResult = try JSONDecoder().decode(RechargingLogResult.self, from: result);
                                    if let list = rechargeResult.resultList, list.count > 0{
                                        completed(list)
                                    }else if let errors = rechargeResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage, errors[0].errorCode ));
                                    }else if rechargeResult.totalElementsCount == 0 {
                                        failed(ErrorMessage(  errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"));
                                    }else{
                                        failed(ErrorMessage(errorMsgs.server.localizedValue));
                                    }
                                }catch let err{
                                    print(err);
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
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
    
    static func getExportedRechargeLogList(_ pageIndex: Int, discriminatorValue: String = "",dateFrom: String = "", dateTo: String = "",_ completed: @escaping ([RechargingLog])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let userData = DataService.getUserData(){
                    let url = "\(API.BASE_URL)\(RECHARGING_LOG_APIs.EXPORT_RECHARGE_LOG_LIST)";
                    let user = userData.reseller!
                    var params = ["pageNumber": 1,
                                  "pageSize": PAGE_SIZE,
                                  "customerId": user.id! as Any] as [String : Any];
                    if !discriminatorValue.isEmpty{
                        params["discriminatorValue"] = discriminatorValue
                    }
                    if !dateFrom.isEmpty{
                        params["dateFrom"] = dateFrom
                    }
                    if !dateTo.isEmpty{
                        params["dateTo"] = dateTo
                    }
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else{
                            if let result = response.result.value {
                                do{
                                    let rechargeResult = try JSONDecoder().decode(RechargingLogResult.self, from: result);
                                    if let list = rechargeResult.resultList, list.count > 0{
                                        completed(list)
                                    }else if let errors = rechargeResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage, errors[0].errorCode ));
                                    }else if rechargeResult.totalElementsCount == 0 {
                                        failed(ErrorMessage(  errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"));
                                    }else{
                                        failed(ErrorMessage(errorMsgs.server.localizedValue));
                                    }
                                }catch let err{
                                    print(err);
                                    failed(ErrorMessage(errorMsgs.server.localizedValue));
                                }
                            }else{
                                failed(ErrorMessage(errorMsgs.server.localizedValue));
                            }
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
