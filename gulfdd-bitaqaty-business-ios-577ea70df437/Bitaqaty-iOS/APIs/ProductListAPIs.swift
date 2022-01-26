//
//  ProductListAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/14/21.
//

import Foundation
import Alamofire

class ProductListAPIs{
    
    static func getCategories(_ completed: @escaping ([Category])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(PURCHASE_API.GET_STORES)";
                    print(url)
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([Category].self, from: result);
                                    if data.count > 0{
                                        completed(data)
                                    }else{
                                        failed(ErrorMessage(errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"));
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
    
    static func getMerchants(_ id: Int,_ completed: @escaping ([Merchant])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if DataService.getUserData() != nil{
                    let url = "\(API.BASE_URL)\(PURCHASE_API.GET_MERCHANTS)\(id)";
                    print(url)
                    Alamofire.request(url, method: .post,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode([Merchant].self, from: result);
                                    if data.count > 0{
                                        completed(data)
                                    }else{
                                        failed(ErrorMessage(errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"));
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
    
    static func getProductList(pageNumber: Int ,categoryId: Int = -1, merchantId: Int = -1, searchCriteria: String = "",_ completed: @escaping ([Product])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let user = DataService.getUserData(), let reseller = user.reseller{
                    var param : [String: Any] = ["calculateVat": true, "orderByProducts": false, "byUrl": false, "resellerId": reseller.id!]
                    if(searchCriteria.isEmpty){
                        param["pageNumber"] = pageNumber
                        param["pageSize"] = PAGE_SIZE
                        param["applyPagination"] = true
                    }else{
                        param["searchCriteria"] = searchCriteria
                        param["applyPagination"] = false
                    }
                    if categoryId != -1{
                        param["categoryId"] = categoryId
                    }
                    
                    if merchantId != -1{
                        param["merchantId"] = merchantId
                    }
                    let url = "\(API.BASE_URL)\(PRODUCT_APIs.GET_PRODUCT_LIST)";
                    print(url)
                    print(param)
                    
                    Alamofire.request(url, method: .post,parameters: param,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(ProductListResult.self, from: result);
                                    if data.errors != nil && data.errors!.count > 0{
                                        failed(ErrorMessage(strings.noPermission.localizedValue, ERROR_CODES.NO_PERMISSION_FOR_PRODUCT_LIST.rawValue));
                                    }else{
                                        if data.productArr.count > 0{
                                            completed(data.productArr)
                                        }else{
                                            failed(ErrorMessage(errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"));
                                        }
                                    }
                                }catch let e{
                                    print(e.localizedDescription)
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
    
    static func getExportedProductList(pageNumber: Int ,categoryId: Int = -1, merchantId: Int = -1, searchCriteria: String = "",_ completed: @escaping ([Product])->(),_ failed: @escaping (ErrorMessage) -> ()){
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                if let user = DataService.getUserData(), let reseller = user.reseller{
                    var param : [String: Any] = ["calculateVat": true, "orderByProducts": true, "byUrl": false, "resellerId": reseller.id!]
                    if(searchCriteria.isEmpty){
                        param["pageNumber"] = 1
                        param["pageSize"] = PAGE_SIZE
                        param["applyPagination"] = false
                    }else{
                        param["searchCriteria"] = searchCriteria
                    }
                    if categoryId != -1{
                        param["categoryId"] = categoryId
                    }
                    
                    if merchantId != -1{
                        param["merchantId"] = merchantId
                    }
                    let url = "\(API.BASE_URL)\(PRODUCT_APIs.EXPORT_PRODUCT_LIST)";
                    print(url)
                    print(param)
                    
                    Alamofire.request(url, method: .post,parameters: param,encoding: JSONEncoding(), headers: DataService.getHeader()).responseData{ response in
                        if response.response?.statusCode == 401{
                            failed(ErrorMessage( errorMsgs.session_ended.localizedValue, "\(ErrorType.Auth.rawValue)"));
                        }else if response.response?.statusCode == 200{
                            if let result = response.result.value {
                                do{
                                    let data = try JSONDecoder().decode(ProductListResult.self, from: result);
                                    if data.errors != nil && data.errors!.count > 0{
                                        failed(ErrorMessage(strings.noPermission.localizedValue, ERROR_CODES.NO_PERMISSION_FOR_PRODUCT_LIST.rawValue));
                                    }else{
                                        if data.productArr.count > 0{
                                            completed(data.productArr)
                                        }else{
                                            failed(ErrorMessage(errorMsgs.no_data.localizedValue, "\(ErrorType.Empty.rawValue)"));
                                        }
                                    }
                                }catch let e{
                                    print(e.localizedDescription)
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
