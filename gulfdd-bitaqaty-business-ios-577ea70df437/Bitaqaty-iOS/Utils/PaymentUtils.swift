//
//  PaymentUtils.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/18/21.
//

import Foundation
class PaymentUtils: NSObject {

    static func SDKVersion() -> String? {
        if let path = Bundle.main.path(forResource: "OPPWAMobile-Resources.bundle/version", ofType: "plist") {
            if let versionDict = NSDictionary(contentsOfFile: path) as? [String: String] {
                return versionDict["OPPVersion"]
            }
        }
        return ""
    }
    
    static func amountAsString() -> String {
        return String(format: "%.2f", Config.amount) + " " + Config.currency
    }
    
    static func showResult(presenter: UIViewController, success: Bool, message: String?) {
        let title = success ? "Success" : "Failure"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func configureCheckoutSettings() -> OPPCheckoutSettings {
        let checkoutSettings = OPPCheckoutSettings.init()
        checkoutSettings.paymentBrands = Config.checkoutPaymentBrands
        checkoutSettings.shopperResultURL = Config.urlScheme + "://payment"
        
        checkoutSettings.theme.navigationBarBackgroundColor = .bgColor
        checkoutSettings.theme.confirmationButtonColor = .accentColor
        checkoutSettings.theme.accentColor = .textColor
        checkoutSettings.theme.cellHighlightedBackgroundColor = Config.mainColor
        checkoutSettings.theme.sectionBackgroundColor = Config.mainColor.withAlphaComponent(0.05)

        // General colors of the checkout UI
        checkoutSettings.theme.primaryBackgroundColor = UIColor.white
        checkoutSettings.theme.primaryForegroundColor = UIColor.black
        checkoutSettings.theme.confirmationButtonTextColor = .textColor
        checkoutSettings.theme.errorColor = UIColor.red
        checkoutSettings.theme.separatorColor = UIColor.lightGray

        // Navigation bar customization
        checkoutSettings.theme.navigationBarTintColor = .textColor
        checkoutSettings.theme.navigationBarTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        checkoutSettings.theme.navigationItemTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor]
        checkoutSettings.theme.cancelBarButtonImage = UIImage(named: "shopping_cart_black_icon")
        // Payment brands list customization
        checkoutSettings.theme.cellHighlightedBackgroundColor = UIColor.bgColor
        checkoutSettings.theme.cellHighlightedTextColor = .textColor

        // Fonts customization
        checkoutSettings.theme.primaryFont = .regularMedium
        checkoutSettings.theme.secondaryFont = .regularSmall
        checkoutSettings.theme.confirmationButtonFont = .regularMedium
        checkoutSettings.theme.errorFont = .regularSmall
        return checkoutSettings
    }
}
