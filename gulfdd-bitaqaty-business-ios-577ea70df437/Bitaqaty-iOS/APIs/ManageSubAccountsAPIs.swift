//
//  ManageSubAccountServices.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 7/27/21.
//
import Foundation
import Alamofire


class ManageSubAccountsAPIs {
    static func getSubAccountsList(_ pageIndex: Int, searchText: String,_ completed: @escaping ([UserInfo])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let userData = DataService.getUserData(){
                    let url = "\(API.BASE_URL)\(MANAGE_API.MANAGE_SUB_ACCOUNT_LIST)";
                    let user = userData.reseller!
                    var params = ["pageNumber": pageIndex,
                                  "pageSize": PAGE_SIZE,
                                  "masterAccountId": user.id! as Any] as [String : Any];
                    if !searchText.isEmpty{
                        params["subAccountName"] = searchText
                    }
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else{
                            if let result = response.result.value {
                                do{
                                    let manageResult = try JSONDecoder().decode(ManageSubAccountResult.self, from: result);
                                    if let list = manageResult.resultList, list.count > 0{
                                        completed(list)
                                    }else if manageResult.totalElementsCount == 0{
                                        failed(ErrorMessage( searchText.isEmpty ?  errorMsgs.no_data.localizedValue : manageStrings.no_search_result.localizedValue, "\(ErrorType.Empty.rawValue)"));
                                    }else if let errors = manageResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage));
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
                failed(ErrorMessage(msgs.noInternet.localizedValue))
            }
        }
    }
    static func updateSubaAccount(_ subAccount: UserInfo,_ completed: @escaping ()->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(MANAGE_API.UPDATE_SUB_ACCOUNT)";
                    var params = Parameters();
                    do {
                        params = try subAccount.asDictionary();
                    } catch _{
                    }
                    print(params)
////
//                    do{
//                    let jsonEncoder = JSONEncoder()
//                    let jsonData = try jsonEncoder.encode(subAccount)
//                    let json = String(data: jsonData, encoding: String.Encoding.utf8)
//                    print(json)
//                    completed()
//                    }catch _ {
//                        failed(ErrorMessage(errorMsgs.server.localizedValue));
//                    }
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let errorResult = try JSONDecoder().decode([ErrorMessage].self, from: result);
                                    if errorResult.count > 0{
                                        if errorResult[0].errorCode == ERROR_CODES.SELECT_RECHARGE_METHOD.rawValue{
                                            failed(ErrorMessage(ERROR_CODES.SELECT_RECHARGE_METHOD.message));
                                        }else{
                                            failed(ErrorMessage(errorMsgs.server.localizedValue));

                                        }
                                    }else{
                                        print(result)
                                        completed()
                                    }
                                }catch _{
                                    print(result)
                                    completed()
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
                failed(ErrorMessage(msgs.noInternet.localizedValue))
            }
        }
    }
    static func getExportedSubAccountsList(_ pageIndex: Int, searchText: String,_ completed: @escaping ([UserInfo])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let userData = DataService.getUserData(){
                    let url = "\(API.BASE_URL)\(MANAGE_API.EXPORT_SUB_ACCOUNT_LIST)";
                    let user = userData.reseller!
                    var params = ["pageNumber": 1,
                                  "pageSize": PAGE_SIZE,
                                  "masterAccountId": user.id! as Any] as [String : Any];
                    if !searchText.isEmpty{
                        params["subAccountName"] = searchText
                    }
                    print(params)
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else{
                            if let result = response.result.value {
                                do{
                                    let manageResult = try JSONDecoder().decode(ManageSubAccountResult.self, from: result);
                                    if let list = manageResult.resultList, list.count > 0{
                                        completed(list)
                                    }else if manageResult.totalElementsCount == 0{
                                        failed(ErrorMessage( searchText.isEmpty ?  errorMsgs.no_data.localizedValue : manageStrings.no_search_result.localizedValue, "\(ErrorType.Empty.rawValue)"));
                                    }else if let errors = manageResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage));
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
    
    
    static func resetLimit(id: Int, _ completed: @escaping ()->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(MANAGE_API.RESET_LIMIT)\(id)";
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            completed()
                        }else{
                            failed(ErrorMessage(errorMsgs.server.localizedValue));
                        }
                    };
                }else{
                    failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                }
            }else{
                failed(ErrorMessage(msgs.noInternet.localizedValue))
            }
        }
    }
}
