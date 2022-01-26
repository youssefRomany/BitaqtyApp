//
//  SupportAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 10/17/21.
//

import Foundation
import Alamofire

class SupportAPIs{
    
    static func getTicketTypes(_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(SUPPORT_APIs.GET_TICKET_TYPE)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate?.onFailed(err: .unauthorized,0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([Ticket].self, from: result){
                                delegate?.onSuccess(dataResult)
                            }else{
                                delegate?.onFailed(err: .other,0)
                            }
                        }else{
                            delegate?.onFailed(err: .other,0)
                        }
                    }
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection,0)
            }
        }
    }
    
    static func addTicket(_ request: TicketRequestBody,_ delegate: OnFinishDelegate?){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(SUPPORT_APIs.ADD_TICKET)"
                if let params = try? request.asDictionary(){
                    print("\(url)")
                    print("\(params)")
                    Alamofire.request(url,method: .post,parameters: params,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                        if response.response?.statusCode == 401{
                            delegate?.onFailed(err: .unauthorized,0)
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                if let dataResult = try? JSONDecoder().decode([ErrorMessage].self, from: result),dataResult.isNotEmpty{
                                    if (dataResult[0].errorCode.lowercased() == "success"){
                                        delegate?.onSuccess()
                                    }else{
                                        delegate?.onFailed(err: .custom(dataResult[0]),1)
                                    }
                                }else{
                                    delegate?.onSuccess()
                                }
                            }else{
                                delegate?.onFailed(err: .other,1)
                            }
                        }
                    }
                }else{
                    delegate?.onFailed(err: .other,1)
                }
            }else{
                delegate?.onFailed(err: .noInternetConnection,1)
            }
        }
    }
}
