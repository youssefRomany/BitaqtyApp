//
//  GeneralAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/11/21.
//

import Foundation
import Alamofire


class GeneralAPIs{
    static func getSettings(_ completed: @escaping ()->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(SYSTEM_API.SYSTEM_SETTINGS)";
                    print("\(url)")
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        print("response.response?.statusCode", response.response?.statusCode)
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([SystemSettings].self, from: result);
                                    let _ = print("Noura \(data.count)")
                                    if data.count > 0{
                                        SETTINGS = data
                                        let _ = print("joooooooooooo \(SETTINGS)")
                                        completed()
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
                failed(ErrorMessage(msgs.noInternet.localizedValue))
            }
        }
    }
}
