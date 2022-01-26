//
//  ResellerHomeAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 11/10/2021.
//

import Foundation
import Alamofire

class ResellerHomeAPIs{
    static func getDailySales(_ completed: @escaping (HomeSales)->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RESELLER_HOME_APIs.GET_DAILY_SALES)";
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(HomeSales.self, from: result);
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
    
    
    
    static func getDailyRecharge(_ completed: @escaping (HomeSales)->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RESELLER_HOME_APIs.GET_DAILY_RECHARGE)";
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(HomeSales.self, from: result);
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
    
    
    
    static func getHomeSubAccounts(searchPeriod: String,_ completed: @escaping ([HomeSubAccount])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RESELLER_HOME_APIs.GET_SUB_ACCOUNTS_SALES)";
                    let params = ["searchPeriod": searchPeriod] as [String : Any];
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(HomeSubAccountsResult.self, from: result);
                                    if let subAccounts = data.subAccounts, subAccounts.count > 0{
                                        completed(data.subAccounts!)
                                    }else{
                                        failed(ErrorMessage(errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"))
                                        
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
    
    
    static func getResellerReports(searchPeriod: String,_ completed: @escaping (ReportLog)->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(REPORT_APIs.GENERATE_REPORT)";
                    let params = ["pageNumber": 1,
                                  "pageSize": 10,
                                  "forTopSelling": true,
                                  "searchPeriod": searchPeriod] as [String : Any];
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else{
                            if let result = response.result.value {
                                do{
                                    let reportsResult = try JSONDecoder().decode(ReportLog.self, from: result);
                                    if reportsResult.elements != nil && reportsResult.elements!.count > 0{
                                       completed(reportsResult)
                                    }else if let errors = reportsResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage));
                                    }else if reportsResult.totalElementsCount == 0 || (reportsResult.elements != nil && reportsResult.elements!.count == 0){
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
    
    
    static func getBankRequests(_ completed: @escaping ([RequestLog])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(RESELLER_HOME_APIs.GET_SELLER_HOME_BANK_REQUESTS)";
                    let params = ["pageNumber": 1,
                                  "pageSize": 2] as [String : Any];
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else{
                            if let result = response.result.value {
                                do{
                                    let reseultLogs = try JSONDecoder().decode(RequestsLogs.self, from: result);
                                    if reseultLogs.requestsLogs != nil && reseultLogs.requestsLogs!.count > 0{                           completed(reseultLogs.requestsLogs!)
                                    }else if let errors = reseultLogs.errors{
                                        failed(ErrorMessage(errors[0].errorMessage));
                                    }else if (reseultLogs.requestTotalCount == 0){
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
