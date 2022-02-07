//
//  PurchaseAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import Foundation
import Alamofire

class PurchaseAPIs {
    static func loadStores(_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(PURCHASE_API.GET_STORES)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([Category].self, from: result){
                                delegate.onSuccess(dataResult)
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
    
    static func loadMerchants(categoryId: Int,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(PURCHASE_API.GET_MERCHANTS)\(categoryId)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode([Merchant].self, from: result){
                                delegate.onSuccess(dataResult)
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
    
    static func loadProduct(categoryId: Int,merchantId: Int,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(PURCHASE_API.GET_PRODUCTS)"
                let param = ["categoryId": categoryId,
                             "merchantId": merchantId,
                             "applyPagination": false,
                             "orderByProducts": true,
                             "calculateVat": true,
                             "resellerId": DataService.getUserData()?.reseller?.id ?? 0] as [String : Any]
                print("\(url)")
                print("\(param)")
                Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode(ProductListResult.self, from: result){
                                if let products = dataResult.products{
                                    print("joeResp", products)
                                    delegate.onSuccess(products)
                                }else{
                                    delegate.onFailed(err: .custom(ErrorMessage(btrrStrings.btrr_no_data.localizedValue, "\(ErrorType.Empty.rawValue)")))
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
    
    static func purchase(_ product: Product,_ qty: Int,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(PURCHASE_API.PURCHASE)"
                var param = ["resellerId": DataService.getUserData()?.reseller?.id ?? 0,
                             "productId": product.id!,
                             "itemsCount": qty] as [String : Any]
                if (product.Price.isNotEmpty && product.Price != "0.0" && product.Price != "0"){
                    param["currentPrice"] = product.Price
                }
                print(url)
                print(param)
                Alamofire.request(url,method: .post,parameters: param,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    print("\(response.response?.statusCode  ?? 500)")
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            if let dataResult = try? JSONDecoder().decode(ProductDetails.self, from: result){
                                AccountServices.getProfile {
                                    NotificationCenter.default.post(name: .reloadBalance, object: nil)
                                    NotificationCenter.default.post(name: .reloadTransaction, object: nil)
                                    delegate.onSuccess(dataResult)
                                } _: {
                                    delegate.onSuccess(dataResult)
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
}
