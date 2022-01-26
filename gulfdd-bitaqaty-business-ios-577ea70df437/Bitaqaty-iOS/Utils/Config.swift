import UIKit

class Config: NSObject {
    
    // MARK: - The default amount and currency that are used for all payments
    static let amount: Double = 49.99
    static let currency: String = "EUR"
    
    // MARK: - The payment brands for Ready-to-use UI
    static let checkoutPaymentBrands = ["PAYPAL"]
    
    // MARK: - The default payment brand for Payment Button
    static let paymentButtonBrand = "VISA"
    
    // MARK: - The card parameters for SDK & Your Own UI form
    static let cardBrand = "VISA"
    static let cardHolder = "JOHN DOE"
    static let cardNumber = "4200 0000 0000 0000"
    static let cardExpiryMonth = "05"
    static let cardExpiryYear = "2025"
    static let cardCVV = "123"
    
    // MARK: - Other constants
    static let asyncPaymentCompletedNotificationKey = "AsyncPaymentCompletedNotificationKey"
    static let urlScheme = "OneCard.async"
    static let mainColor: UIColor = UIColor.init(red: 10.0/255.0, green: 134.0/255.0, blue: 201.0/255.0, alpha: 1.0)
}
