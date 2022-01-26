//
//  PayPalCustomPayVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/5/21.
//

import UIKit


class PayPalCustomPayVC: UIViewController {
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var imgPayPal: UIImageView!
    @IBOutlet weak var btnPayPal: UIButton!

    @IBOutlet var processingView: UIActivityIndicatorView!
    
    var type: Int = -1
    var rechargeMethod: RechargeMethod?
    var amount: Double = 0.0
    var payPalDemoniation: PayPalDenomination?
    var checkoutId: String = ""
    
    var checkoutProvider: OPPCheckoutProvider?
    var transaction: OPPTransaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.showX(strings.paypal.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        btnPayPal.customBoarderWithRound(to: 5, with: .lightGray)
        self.view.semanticContentAttribute = .forceLeftToRight
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.setStatusBar(color: .white)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func openPayPal(_ sender: Any) {
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                self.checkoutProvider = self.configureCheckoutProvider(checkoutID: self.checkoutId)
                self.checkoutProvider?.delegate = self
                self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
                    DispatchQueue.main.async {
                        self.handleTransactionSubmission(transaction: transaction, error: error)
                    }
                })
            }else{
                DataService.ds.showAlert(self, msgs.noInternet.localizedValue)
                
            }
        }
        
    }
    func handleTransactionError(){
        self.processingView.stopAnimating()
        let vc = SuccessErrorPaymentVC(nibName: "SuccessErrorPaymentVC", bundle: nil)
        vc.isSuccess = false
        vc.type = self.type
        vc.modalPresentationStyle = .overFullScreen
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            pvc?.present(vc, animated: true, completion: nil)
        })
    }
}

extension PayPalCustomPayVC: OPPCheckoutProviderDelegate{
    func checkoutProvider(_ checkoutProvider: OPPCheckoutProvider, continueSubmitting transaction: OPPTransaction, completion: @escaping (String?, Bool) -> Void) {
        completion(transaction.paymentParams.checkoutID, false)
    }
    
    // MARK: - Payment helpers
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            DataService.ds.showAlert(self, msgs.errServer.localizedValue)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        } else {
            self.handleTransactionError()
            
        }
    }
    
    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        let provider = OPPPaymentProvider.init(mode: .test)
        //TODO LIVE
        //let provider = OPPPaymentProvider.init(mode: .live)

        let checkoutSettings = PaymentUtils.configureCheckoutSettings()
        checkoutSettings.storePaymentDetails = .prompt
        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
    }
    
    func requestPaymentStatus() {
        self.transaction = nil
        RechargeAPIs.getPaymentStatus(rechargeMethod: self.rechargeMethod!, amount: "\(amount)", checkoutId: checkoutId, paypalDenomation: self.payPalDemoniation) {
            self.processingView.stopAnimating()
            let vc = SuccessErrorPaymentVC(nibName: "SuccessErrorPaymentVC", bundle: nil)
            vc.isSuccess = true
            vc.type = self.type
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        } _: { (err) in
            print(err)
            self.handleTransactionError()
        }
    }
    
    // MARK: - Async payment callback
    
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        self.checkoutProvider?.dismissCheckout(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        }
    }
}


