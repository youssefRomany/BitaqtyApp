//
//  SalesReportAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/26/21.
//

import Foundation
import Alamofire

class SalesReportAPIs{
    
    static func loadUsers(_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(REPORT_APIs.GET_USER_NAME)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate?.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([TransactionUser].self, from: result){
                                delegate?.onSuccess(dataResult)
                            }else{
                                delegate?.onFailed(err: .other)
                            }
                        }else{
                            delegate?.onFailed(err: .other)
                        }
                    }
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func loadStores(_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(REPORT_APIs.GET_STORES)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate?.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([Category].self, from: result){
                                if dataResult.isEmpty{
                                    delegate?.onFailed(err: .custom(ErrorMessage(errorMsgs.no_data.localizedValue)))
                                }else{
                                    delegate?.onSuccess(dataResult)
                                }
                            }else{
                                delegate?.onFailed(err: .other)
                            }
                        }else{
                            delegate?.onFailed(err: .other)
                        }
                    }
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func loadMerchants(categoryId: Int,_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(REPORT_APIs.GET_MERCHANTS)\(categoryId)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate?.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([Merchant].self, from: result){
                                if dataResult.isEmpty{
                                    delegate?.onFailed(err: .custom(ErrorMessage(errorMsgs.no_data.localizedValue)))
                                }else{
                                    delegate?.onSuccess(dataResult)
                                }
                            }else{
                                delegate?.onFailed(err: .other)
                            }
                        }else{
                            delegate?.onFailed(err: .other)
                        }
                    }
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func loadProduct(categoryId: Int,merchantId: Int,_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(REPORT_APIs.GET_PRODUCTS)"
                let param = ["categoryId": categoryId,
                             "merchantId": merchantId,
                             "applyPagination": false,
                             "resellerId": DataService.getUserData()?.reseller?.id ?? 0] as [String : Any]
                print("\(url)")
                print("\(param)")
                Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate?.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([Product].self, from: result){
                                delegate?.onSuccess(dataResult)
                            }else{
                                delegate?.onFailed(err: .custom(ErrorMessage(errorMsgs.no_data.localizedValue)))
                            }
                        }else{
                            delegate?.onFailed(err: .other)
                        }
                    }
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    
    
    static func generateReport(request: ReportRequestBody,_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(REPORT_APIs.GENERATE_REPORT)"
                print("\(url)")
                if let param = try? request.asDictionary(){
                    print("\(param)")
                    Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                        if response.response?.statusCode == 401{
                            delegate?.onFailed(err: .unauthorized)
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                if let dataResult = try? JSONDecoder().decode(ReportLog.self, from: result){
                                    delegate?.onSuccess(dataResult)
                                }else{
                                    delegate?.onFailed(err: .other, 1)
                                }
                            }else{
                                delegate?.onFailed(err: .other, 1)
                            }
                        }
                    }
                }else{
                    delegate?.onFailed(err: .other, 1)
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection, 1)
            }
        }
    }
    
    
    static func exportSalesReport(_ request: ReportRequestBody,completed: @escaping (ReportLog)->(),failed: @escaping ()->()){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(REPORT_APIs.EXPORT_REPORT)"
                do{
                    Alamofire.request(url,method: .post,parameters: try request.asDictionary(),encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                        if response.response?.statusCode == 401{
                            failed()
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                do{
                                    let dataResult = try JSONDecoder().decode(ReportLog.self, from: result)
                                    if let logs = dataResult.elements, logs.isNotEmpty{
                                        completed(dataResult)
                                    }else{
                                        failed()
                                    }
                                }catch{
                                    failed()
                                }
                            }else{
                                failed()
                            }
                        }
                    }
                }catch _ {
                    failed()
                }
            }else{
                failed()
            }
        }
    }
}
