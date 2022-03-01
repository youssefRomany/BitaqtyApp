//
//  TransactionLogAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/21/21.
//

import Foundation
import Alamofire

class TransactionLogAPIs{
    static func getTransactionUsers(_ completed: @escaping ([TransactionUser])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(TRANSACTION_LOG_APIs.GET_USERNAMES_LIST)";
                    print("\(url)")
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([TransactionUser].self, from: result);
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
    static func getTransactionLog(_ pageIndex: Int, subAccountId: Int = -1,serialNo: String = "",secret: String = "", channel: String = "",dateFrom: String = "", dateTo: String = "",printed: String = "",_ completed: @escaping ([TransactionLog])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(TRANSACTION_LOG_APIs.GET_TRANSACTIONS_LIST)";
                    var params = ["pageNumber": pageIndex,
                                  "pageSize": PAGE_SIZE] as [String : Any];
                    if (subAccountId != -1) {
                        params["subAccountId"] = subAccountId

                     }
                    if !serialNo.isEmpty{
                        params["productSerial"] = serialNo
                    }
                    if !secret.isEmpty{
                        params["productSecret"] = secret
                    }
                    if !channel.isEmpty{
                        params["channel"] = channel
                    }
                    
                    if (!printed.isEmpty) {
                       params["isPrinted"] = printed
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
                                    let transactionResult = try JSONDecoder().decode(TransactionLogResult.self, from: result);
                                    print(transactionResult, "dddddewdwedwedwed")
                                    if transactionResult.TranscationList.count > 0{
                                        completed(transactionResult.TranscationList)
                                    }else if let errors = transactionResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage , errors[0].errorCode))
                                    }else if transactionResult.totalElementsCount == 0 || transactionResult.TranscationList.count == 0{
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
    
    
    static func getExportedTransactionLog(_ pageIndex: Int, subAccountId: Int = -1,serialNo: String = "",secret: String = "", channel: String = "",dateFrom: String = "", dateTo: String = "",printed: String = "",_ completed: @escaping ([TransactionLog])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(TRANSACTION_LOG_APIs.EXPORT_TRANSACTIONS_LIST)";
                    var params = ["pageNumber": 1,
                                  "pageSize": PAGE_SIZE] as [String : Any];
                    if (subAccountId != -1) {
                        params["subAccountId"] = subAccountId

                     }
                    if !serialNo.isEmpty{
                        params["productSerial"] = serialNo
                    }
                    if !secret.isEmpty{
                        params["productSecret"] = secret
                    }
                    if !channel.isEmpty{
                        params["channel"] = channel
                    }
                    
                    if (!printed.isEmpty) {
                       params["isPrinted"] = printed
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
                                    let transactionResult = try JSONDecoder().decode(TransactionLogResult.self, from: result);
                                    if transactionResult.TranscationList.count > 0{
                                        completed(transactionResult.TranscationList)
                                    }else if let errors = transactionResult.errors{
                                        failed(ErrorMessage(errors[0].errorMessage));
                                    }else if transactionResult.totalElementsCount == 0 || transactionResult.TranscationList.count == 0{
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
