//
//  BankTransferAPIs.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/29/21.
//

import Foundation
import Alamofire

class BankTransferAPIs {
    
    static func loadBankTransfers(_ request: RequestLogBody,_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.SEARCH_BANK_TRANSFER_REQUEST)"
                do{
                    Alamofire.request(url,method: .post,parameters: try request.asDictionary(),encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                        if response.response?.statusCode == 401{
                            delegate.onFailed(err: .unauthorized)
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                do{
                                    let dataResult = try JSONDecoder().decode(RequestsLogs.self, from: result)
                                    if let error = dataResult.errors,error.count > 0{
                                        delegate.onFailed(err: .custom(error[0]))
                                    }else if let logs = dataResult.requestsLogs{
                                        delegate.onSuccess(logs)
                                    }else{
                                        delegate.onSuccess([RequestLog]())
                                    }
                                }catch{
                                    delegate.onFailed(err: .other)
                                }
                            }else{
                                delegate.onFailed(err: .other)
                            }
                        }
                    }
                }catch _ {
                    delegate.onFailed(err: .other)
                }
            }else{
                delegate.onFailed(err: .noInternetConnection)
            }
        }
    }
    
    static func exportBankTransfers(_ request: RequestLogBody,completed: @escaping ([RequestLog])->(),failed: @escaping ()->()){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.EXPORT_BANK_TRANSFER_REQUEST)"
                do{
                    Alamofire.request(url,method: .post,parameters: try request.asDictionary(),encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                        if response.response?.statusCode == 401{
                            failed()
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                do{
                                    let dataResult = try JSONDecoder().decode(RequestsLogs.self, from: result)
                                    if let logs = dataResult.requestsLogs{
                                        completed(logs)
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
    
    static func getOneCardCountries(_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.ONE_CARD_COUNTRIES)"
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized, 0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            do{
                                let dataResult = try JSONDecoder().decode(Countries.self, from: result)
                                if let lookup = dataResult.lookupList,lookup.count > 0 {
                                    delegate.onSuccess(dataResult)
                                }else{
                                    delegate.onFailed(err: .custom(ErrorMessage(btrrStrings.btrr_no_data.localizedValue, "\(ErrorType.Empty.rawValue)")), 0)
                                }
                            }catch{
                                delegate.onFailed(err: .other, 0)
                            }
                        }else{
                            delegate.onFailed(err: .other, 0)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 0)
            }
        }
    }
    static func getOneCardAccounts(countryId: Int,_ delegate: OnFinishDelegate){
        if let userData = DataService.getUserData(), let profile = userData.reseller{
            DataService.ds.isConnectedToNetwork { success in
                if (success){
                    let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.ONE_CARD_ACCOUNTS)"
                    let request = RequestOneCardAccountsBody(resellerUsername: profile.Username, countryId: countryId)
                    do{
                        Alamofire.request(url,method: .post,parameters: try request.asDictionary(),encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                            if response.response?.statusCode == 401{
                                delegate.onFailed(err: .unauthorized, 1)
                            }else{
                                if let result = response.result.value, response.response?.statusCode == 200{
                                    do{
                                        let dataResult = try JSONDecoder().decode(OneCardAccount.self, from: result)
                                        if let lookup = dataResult.accounts, lookup.count > 0 {
                                            delegate.onSuccess(dataResult)
                                        }else{
                                            delegate.onFailed(err: .custom(ErrorMessage(btrrStrings.btrr_no_data.localizedValue, "\(ErrorType.Empty.rawValue)")), 0)
                                        }
                                    }catch{
                                        delegate.onFailed(err: .other, 1)
                                    }
                                }else{
                                    delegate.onFailed(err: .other, 1)
                                }
                            }
                        }
                    }catch _ {
                        delegate.onFailed(err: .other, 1)
                    }
                }else{
                    delegate.onFailed(err: .noInternetConnection, 1)
                }
            }
        }else{
            delegate.onFailed(err: .unauthorized, 1)
        }
    }
    
    
    static func getSavedAccount(_ delegate: OnFinishDelegate){
        if let userData = DataService.getUserData(), let profile = userData.reseller{
            DataService.ds.isConnectedToNetwork { success in
                if (success){
                    let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.SAVED_ACCOUNTS)"
                    print("(url): \(url)")
                    let request = RequestOneCardAccountsBody(resellerUsername: profile.Username)
                    do{
                        Alamofire.request(url,method: .post,parameters: try request.asDictionary(),encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                            print("getSavedAccount: \(response.response?.statusCode ?? 0)")
                            if response.response?.statusCode == 401{
                                delegate.onFailed(err: .unauthorized, 0)
                            }else{
                                if let result = response.result.value, response.response?.statusCode == 200{
                                    do{
                                        let dataResult = try JSONDecoder().decode(SavedAccountsList.self, from: result)
                                        if let error = dataResult.errors,error.count > 0{
                                            delegate.onFailed(err: .custom(error[0]), 0)
                                        }else{
                                            delegate.onSuccess(dataResult)
                                        }
                                    }catch{
                                        delegate.onFailed(err: .other, 0)
                                    }
                                }else{
                                    delegate.onFailed(err: .other, 0)
                                }
                            }
                        }
                    }catch _ {
                        delegate.onFailed(err: .other, 0)
                    }
                }else{
                    delegate.onFailed(err: .noInternetConnection, 0)
                }
            }
        }else{
            delegate.onFailed(err: .unauthorized, 0)
        }
    }
    
    static func getSenderCountries(_ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.SENDER_COUNTRIES)"
                print("(url): \(url)")
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    print("getSenderCountries: \(response.response?.statusCode ?? 0)")
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized, 0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            do{
                                let dataResult = try JSONDecoder().decode(Countries.self, from: result)
                                if let error = dataResult.errors,error.count > 0{
                                    delegate.onFailed(err: .custom(error[0]), 1)
                                }else if let _ = dataResult.lookupList{
                                    delegate.onSuccess(dataResult,0)
                                }else{
                                    delegate.onFailed(err: .other, 1)
                                }
                            }catch{
                                delegate.onFailed(err: .other, 1)
                            }
                        }else{
                            delegate.onFailed(err: .other, 1)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 1)
            }
        }
    }
    
    static func getSenderAccountsByCountry(countryId: Int, _ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.SENDER_ACCOUNTS_BY_COUNTRY)\(countryId)"
                print("(url): \(url)")
                Alamofire.request(url,method: .post,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized, 0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            do{
                                let dataResult = try JSONDecoder().decode(Countries.self, from: result)
                                if let error = dataResult.errors,error.count > 0{
                                    delegate.onFailed(err: .custom(error[0]), 2)
                                }else {
                                    delegate.onSuccess(dataResult,1)
                                }
                            }catch{
                                delegate.onFailed(err: .other, 2)
                            }
                        }else{
                            delegate.onFailed(err: .other, 2)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 2)
            }
        }
    }
    
    static func deleteSavedAccount(savedAccount: SavedAccount,_ index: Int, _ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.DELETE_SENDER_ACCOUNT)"
                print("(url): \(url)")
                let params = ["fromBankId": savedAccount.fromBankId!,"bankAccountNumber": savedAccount.bankAccountNumber!,"resellerUsername": DataService.getUserData()!.reseller!.username!]
                Alamofire.request(url,method: .post,parameters: params,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized, 0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            let dataResult = try? JSONDecoder().decode(ErrorMessage.self, from: result)
                            if let error = dataResult{
                                delegate.onFailed(err: .custom(error), 3)
                            }else {
                                delegate.onSuccess(tag: index)
                            }
                        }else{
                            delegate.onFailed(err: .other, 3)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 3)
            }
        }
    }
    
    static func calculateRecharge(request: PlaceBTR, _ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.CALCULATE_RECHARGE_AMOUNT)"
                print("(url): \(url)")
                let params = try? request.asDictionary()
                Alamofire.request(url,method: .post,parameters: params,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized, 0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            let dataResult = try? JSONDecoder().decode(Double.self, from: result)
                            if let d = dataResult{
                                delegate.onSuccess(double: d)
                            }else{
                                delegate.onFailed(err: .other, 1)
                            }
                        }else{
                            delegate.onFailed(err: .other, 1)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 1)
            }
        }
    }
    
    
    static func saveAccount(request: BankTransferViewModel, _ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.SAVE_SENDER_ACCOUNT)"
                print("(url): \(url)")
                if let params = try? request.senderAccount.asDictionary(){
                    print(params)
                    Alamofire.request(url,method: .post,parameters: params,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                        if response.response?.statusCode == 401{
                            delegate.onFailed(err: .unauthorized, 0)
                        }else{
                            if let result = response.result.value, response.response?.statusCode == 200{
                                let dataResult = try? JSONDecoder().decode(ErrorMessage.self, from: result)
                                if let result = dataResult{
                                    delegate.onFailed(err: .custom(result),2)
                                }else{
                                    placeRequest(request,delegate)
                                }
                            }else{
                                delegate.onFailed(err: .other, 2)
                            }
                        }
                    }
                }else{
                    delegate.onFailed(err: .other, 2)
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 2)
            }
        }
    }
    
    
    static func placeRequest(_ request: BankTransferViewModel, _ delegate: OnFinishDelegate){
        DataService.ds.isConnectedToNetwork { success in
            if (success){
                let url = "\(API.BASE_URL)\(BANK_TRANSFER_API.PLACE_REQUEST)"
                print("(url): \(url)")
                let params = try? request.request.asDictionary()
                Alamofire.request(url,method: .post,parameters: params,encoding: JSONEncoding(),headers: DataService.getHeader()).responseData { response in
                    if response.response?.statusCode == 401{
                        delegate.onFailed(err: .unauthorized, 0)
                    }else{
                        if let result = response.result.value, response.response?.statusCode == 200{
                            print(String(decoding: result, as: UTF8.self))
                            let dataResult = try? JSONDecoder().decode([ErrorMessage].self, from: result)
                            if let result = dataResult, result.count > 0{
                                delegate.onFailed(err: .custom(result[0]),2)
                            }else{
                                delegate.onSuccess()
                            }
                        }else{
                            delegate.onFailed(err: .other, 2)
                        }
                    }
                }
            }else{
                delegate.onFailed(err: .noInternetConnection, 2)
            }
        }
    }
}
class BankTransferViewModel{
    var request: PlaceBTR = PlaceBTR()
    var oneCardCountry: Country? = nil
    var oneCardAccount: Account? = nil
    var senderAccount: SavedAccount? = nil
    var saveAccount = false
}
