//
//  SubResellerHomeAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/14/21.
//

import Foundation
import Alamofire

class SubResellerHomeAPIs {
    
    static func loadTopMerchants(_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(SUB_SELLER_HOME_APIs.SUB_ACCOUNT_HOME)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized,0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            do{
                                let dataResult = try JSONDecoder().decode(TopMerchants.self, from: result)
                                if let error = dataResult.errors,error.count > 0{
                                    delegate.onFailed(err: .custom(error[0]),0)
                                }else if let merchants = dataResult.merchants{
                                    delegate.onSuccess(merchants)
                                }else{
                                    delegate.onSuccess([TopMerchant]())
                                }
                            }catch{
                                delegate.onFailed(err: .other,0)
                            }
                        }else{
                            delegate.onFailed(err: .other,0)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection,0)
            }
        }
    }
    
    static func loadMerchants(categoryId: Int,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(SUB_SELLER_HOME_APIs.SUB_ACCOUNT_HOME_CHILD)"
                let params = ["catrgoryId": categoryId,"pageSize": 1000,"pageNumber": 1]
                Alamofire.request(url,method: .post,parameters: params,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode(TopChildMerchant.self, from: result){
                                if let merchants = dataResult.merchants{
                                    delegate.onSuccess(merchants)
                                }else{
                                    delegate.onSuccess([Merchant]())
                                }
                            }else{
                                delegate.onFailed(err: .other)
                            }
                        }else{
                            delegate.onFailed(err: .other)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    
    static func getTransactionLog(_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(TRANSACTION_LOG_APIs.GET_TRANSACTIONS_LIST)";
                    let params = ["pageNumber": 1,"pageSize": 5] as [String : Any];
                    Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            delegate.onFailed(err: .unauthorized,0)
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                do{
                                    let dataResult = try JSONDecoder().decode(TransactionLogResult.self, from: result)
                                    if let error = dataResult.errors,error.count > 0{
                                        delegate.onFailed(err: .custom(error[0]),1)
                                    }else if let logs = dataResult.transactionLogList{
                                        delegate.onSuccess(logs)
                                    }else{
                                        delegate.onSuccess([TransactionLog]())
                                    }
                                }catch{
                                    delegate.onFailed(err: .other,1)
                                }
                            }else{
                                delegate.onFailed(err: .other,1)
                            }
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection,1)
            }
        }
    }
}
