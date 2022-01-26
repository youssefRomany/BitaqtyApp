//
//  RemainingTrials.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/11/21.
//

import Foundation

struct RemainingTrials: Codable {
    var errors: [ErrorMessage]?
    var allowedSmsTrials: Int?
    var remainingInvalidSmsTrials: Int?
    var waitingSecondsToResendSms: Int?
    var showResendSmsLinkAfter: Double?
    var resendSmsTrials: Int?
    var remainingResendSmsTrials: Int?
    var showResendSMSLinkMinutes: Double?
    
    
    var AllowedSmsTrials: Int{
        set{
            allowedSmsTrials = newValue
        }
        get{
            return allowedSmsTrials ?? 0
        }
    }
    var RemainingInvalidSmsTrials: Int{
        set{
            remainingInvalidSmsTrials = newValue
        }
        get{
            return remainingInvalidSmsTrials ?? 0
        }
    }
    var WaitingSecondsToResendSms: Int{
        set{
            waitingSecondsToResendSms = newValue
        }
        get{
            return waitingSecondsToResendSms ?? 0
        }
    }
    var ResendSmsTrials: Int{
        set{
            resendSmsTrials = newValue
        }
        get{
            return resendSmsTrials ?? 0
        }
    }
    var RemainingResendSmsTrials: Int{
        set{
            remainingResendSmsTrials = newValue
        }
        get{
            return remainingResendSmsTrials ?? 0
        }
    }
    var ShowResendSmsLinkMinutes: Double{
        set{
            showResendSMSLinkMinutes = newValue
        }
        get{
            return showResendSMSLinkMinutes ?? 0.0
        }
    }
}
