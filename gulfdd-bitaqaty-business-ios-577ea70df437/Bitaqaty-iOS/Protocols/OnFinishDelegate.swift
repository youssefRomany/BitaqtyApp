//
//  OnFinishDelegate.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/12/21.
//

import Foundation
import UIKit

protocol OnFinishDelegate: AnyObject {
    func onSuccess()
    func onSuccess(tag: Int)
    func onSuccess(double: Double)
    func onSuccess(_ model: RemainingTrials)
    func onSuccess(_ logs: [RequestLog])
    func onSuccess(_ tickets: [Ticket])
    func onSuccess(_ transactionLogs: [TransactionLog])
    func onSuccess(_ countries: Countries)
    func onSuccess(_ countries: Countries,_ tag: Int)
    func onSuccess(_ account: OneCardAccount)
    func onSuccess(_ savedAccount: SavedAccountsList)
    func onSuccess(_ categories: [Category])
    func onSuccess(_ merchants: [Merchant])
    func onSuccess(_ merchants: [TopMerchant])
    func onSuccess(_ products: [Product])
    func onSuccess(_ productDetails: ProductDetails)
    func onSuccess(_ users: [TransactionUser])
    func onSuccess(_ reportLog: ReportLog)
    func onFailed()
    func onFailed(err: ServiceError)
    func onFailed(err: ServiceError,_ tag: Int)
    func onBadRequest(_ err: String,_ tag: Int)
    func onValidationSuccess(_ tag: Int)
}

extension OnFinishDelegate{
    func onSuccess() {
        
    }
    
    func onSuccess(tag: Int){
        
    }
    
    func onSuccess(double: Double){
        
    }
    
    func onSuccess(_ categories: [Category]){
        
    }
    
    func onSuccess(_ transactionLogs: [TransactionLog]){
        
    }
    
    func onSuccess(_ tickets: [Ticket]){
        
    }
    
    func onSuccess(_ merchants: [Merchant]){
        
    }
    
    func onSuccess(_ products: [Product]){
        
    }
    
    func onSuccess(_ users: [TransactionUser]){
        
    }
    
    func onSuccess(_ merchants: [TopMerchant]){
        
    }
    
    func onSuccess(_ productDetails: ProductDetails){
        
    }
    
    func onSuccess(_ reportLog: ReportLog){
        
    }
    
    func onSuccess(_ model: RemainingTrials){
        
    }
    
    func onSuccess(_ countries: Countries){
        
    }
    
    func onSuccess(_ countries: Countries,_ tag: Int){
        
    }
    
    func onSuccess(_ account: OneCardAccount){
        
    }
    
    func onSuccess(_ savedAccount: SavedAccountsList){
        
    }
    
    func onSuccess(_ logs: [RequestLog]){
        
    }
    
    func onFailed(err: ServiceError) {
        
    }
    
    func onFailed(err: ServiceError,_ tag: Int) {
        
    }
    
    func onFailed() {
        
    }
    
    func onBadRequest(_ err: String,_ tag: Int) {
        
    }
    
    func onValidationSuccess(_ tag: Int) {
        
    }
    
}
