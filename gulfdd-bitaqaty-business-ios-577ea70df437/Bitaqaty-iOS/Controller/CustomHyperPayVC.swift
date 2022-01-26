//
//  CustomHyperPayVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/19/21.
//

import UIKit
import SafariServices
enum CardParamsError: Error {
    case invalidParam(String)
}
class CustomHyperPayVC: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var viewHeader: CloseHeaderView!
    
    @IBOutlet var holderTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var expiryMonthTextField: UITextField!
    @IBOutlet var cvvTextField: UITextField!
    @IBOutlet var processingView: UIActivityIndicatorView!
    
    @IBOutlet var cardBrandLabel: UILabel!
    @IBOutlet var lblCardNo: UILabel!
    @IBOutlet var lblCardHolder: UILabel!
    @IBOutlet var lblCardDate: UILabel!
    @IBOutlet var lblCardCVV: UILabel!
    @IBOutlet var lblCardType: UILabel!
    @IBOutlet var lblSaveCard: UILabel!
    
    @IBOutlet var btnPayNow: UIButton!
    @IBOutlet var imgType: UIImageView!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var imgSavedCredit: UIImageView!
    
    @IBOutlet var viewCardType: UIView!
    @IBOutlet var viewSaveCard: UIView!
    
    var provider: OPPPaymentProvider?
    var transaction: OPPTransaction?
    var safariVC: SFSafariViewController?
    
    // MARK: - Life cycle methods
    var checkoutId: String!
    var rechargeMethod: RechargeMethod!
    var amount: String!
    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleHeader()
        setupUI()
        self.provider = OPPPaymentProvider.init(mode: .test)
        //TODO LIVE
        //provider = OPPPaymentProvider(mode: OPPProviderMode.live)
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
    
    func handleHeader(){
        var title = ""
        var img = ""
        switch type {
        case RechargeTypes.Mada.rawValue:
            title = strings.mada.localizedValue
            img = "ic_mada_pay"
        case RechargeTypes.Amex.rawValue:
            title = strings.amex.localizedValue
            img = "ic_amer_pay"
        case RechargeTypes.Credit.rawValue:
            title = strings.credit.localizedValue
            img = "ic_visa_pay"
        default:
            title = ""
        }
        
        cardBrandLabel.text = RechargeTypes.init(rawValue: type)?.brandTitle
        imgType.image = UIImage(named: img)
        
        self.viewHeader.showX(title){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupUI(){
        holderTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        numberTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        expiryMonthTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//        cvvTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
//
        numberTextField.delegate = self
        cvvTextField.delegate = self
        expiryMonthTextField.delegate = self
        holderTextField.delegate = self

        self.lblCardType.text = RechargeStrings.cardType.localizedValue
        self.lblCardHolder.text = RechargeStrings.cardHolder.localizedValue
        self.lblCardNo.text = RechargeStrings.cardNumber.localizedValue
        self.lblCardDate.text = RechargeStrings.expiryDate.localizedValue
        self.lblCardCVV.text = RechargeStrings.cvv.localizedValue
        self.lblSaveCard.text = RechargeStrings.saveCredentials.localizedValue
        
        self.lblCardHolder.textAlignment = lang == "en" ? .left : .right
        self.lblCardNo.textAlignment = lang == "en" ? .left : .right
        self.lblCardDate.textAlignment = lang == "en" ? .left : .right
        self.lblCardCVV.textAlignment = lang == "en" ? .left : .right
        
        self.numberTextField.textAlignment = lang == "en" ? .left : .right
        self.expiryMonthTextField.textAlignment = lang == "en" ? .left : .right
        self.holderTextField.textAlignment = lang == "en" ? .left : .right
        self.cvvTextField.textAlignment = lang == "en" ? .left : .right

        self.btnPayNow.setTitle(RechargeStrings.payNow.localizedValue, for: .normal)
        
        self.holderTextField.placeholder = RechargeStrings.cardHolder.localizedValue
        self.numberTextField.placeholder = RechargeStrings.cardNumber.localizedValue
        self.expiryMonthTextField.placeholder = RechargeStrings.dateHint.localizedValue
        self.cvvTextField.placeholder = RechargeStrings.cvv.localizedValue
        
        imgBg.setupShadows()
        btnPayNow.setupShadowsWithRound(5)
        viewCardType.round(to: 5)
        viewSaveCard.tag = 0
        
        if let cardData = DataService.getCartData(type: type){
            self.holderTextField.text = cardData.name
            self.numberTextField.text = cardData.number
            self.expiryMonthTextField.text = cardData.expiryDate
            viewSaveCard.tag = 1
            imgSavedCredit.image = UIImage(named: "ic_checkbox_checked")
            
        }
    }
    
    @IBAction func onSaveClicked(_ sender: Any) {
        if viewSaveCard.tag == 0{
            do {
                try self.validateFields()
                viewSaveCard.tag = 1
                imgSavedCredit.image = UIImage(named: "ic_checkbox_checked")
                let cardData = CardData(holderTextField.text!, numberTextField.text!,expiryMonthTextField.text!)
                DataService.setCardData(cardData, type: type)
            } catch CardParamsError.invalidParam(let reason) {
                DataService.ds.showAlert(self, reason)
                viewSaveCard.tag = 0
                imgSavedCredit.image = UIImage(named: "ic_checkbox_unchecked")
                return
            } catch {
                DataService.ds.showAlert(self, msgs.errServer.localizedValue)
                viewSaveCard.tag = 0
                imgSavedCredit.image = UIImage(named: "ic_checkbox_unchecked")
                return
            }
        }else{
            viewSaveCard.tag = 0
            imgSavedCredit.image = UIImage(named: "ic_checkbox_unchecked")
            DataService.deleteCardData(type: type)
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func payButtonAction(_ sender: Any) {
        do {
            try self.validateFields()
        } catch CardParamsError.invalidParam(let reason) {
            DataService.ds.showAlert(self, reason)
            return
        } catch {
            DataService.ds.showAlert(self, msgs.errServer.localizedValue)
            return
        }
        
        self.view.endEditing(true)
        DataService.ds.isConnectedToNetwork { connectionSuccess in
            if(connectionSuccess){
                guard let transaction = self.createTransaction(checkoutID: self.checkoutId) else {
                    return
                }
                self.processingView.startAnimating()
                self.provider!.submitTransaction(transaction, completionHandler: { (transaction, error) in
                    DispatchQueue.main.async {
                        self.handleTransactionSubmission(transaction: transaction, error: error)
                    }
                })
            }else{
                DataService.ds.showAlert(self, msgs.noInternet.localizedValue)
                
            }
        }
    }
    
    // MARK: - Payment helpers
    
    func createTransaction(checkoutID: String) -> OPPTransaction? {
        do {
            let date = self.expiryMonthTextField.text!
            let expire = date.components(separatedBy: "/")
            var year = ""
            var month = ""
            if expire.count != 2{
                throw CardParamsError.invalidParam(RechargeStrings.errExpiryDate.localizedValue)
            }else{
                year = expire[1].trimmingCharacters(in:
                                                        CharacterSet.whitespaces)
                month = expire[0].trimmingCharacters(in:
                                                        CharacterSet.whitespaces)
                if year.count == 2{
                    year = "20"+year
                }
            }
            
            let params = try OPPCardPaymentParams.init(checkoutID: checkoutID, paymentBrand: RechargeTypes.init(rawValue: type)!.brandName, holder: self.holderTextField.text!, number: self.numberTextField.text!, expiryMonth: month, expiryYear: year, cvv: self.cvvTextField.text!)
            params.shopperResultURL = Config.urlScheme + "://payment"
            return OPPTransaction.init(paymentParams: params)
            
        } catch let error as NSError {
            DataService.ds.showAlert(self, error.localizedDescription)
            return nil
        }
    }
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        self.processingView.stopAnimating()
        guard let transaction = transaction else {
            
            PaymentUtils.showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, you should open transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
            self.presenterURL(url: self.transaction!.redirectURL!)
        } else {
            self.handleTransactionError()
        }
    }
    
    func presenterURL(url: URL) {
        self.safariVC = SFSafariViewController(url: url)
        self.safariVC?.delegate = self;
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    func requestPaymentStatus() {
        self.transaction = nil
        self.processingView.startAnimating()
        RechargeAPIs.getPaymentStatus(rechargeMethod: self.rechargeMethod!, amount: amount, checkoutId: checkoutId) {
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
    
    // MARK: - Async payment callback
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        self.safariVC?.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        })
    }
    
    // MARK: - Fields validation
    func validateFields() throws {
        if let text = holderTextField.text, text.isEmpty{
            throw CardParamsError.invalidParam(RechargeStrings.emptyCard.localizedValue)
            
        }
        if let text = numberTextField.text, text.isEmpty{
            throw CardParamsError.invalidParam(RechargeStrings.emptyCard.localizedValue)
            
        }
        if let text = expiryMonthTextField.text, text.isEmpty{
            throw CardParamsError.invalidParam(RechargeStrings.emptyCard.localizedValue)
            
        }
        if let text = cvvTextField.text, text.isEmpty{
            throw CardParamsError.invalidParam(RechargeStrings.emptyCard.localizedValue)
            
        }
        guard let holder = self.holderTextField.text, OPPCardPaymentParams.isHolderValid(holder) else {
            throw CardParamsError.invalidParam(RechargeStrings.errCardHolderName.localizedValue)
        }
        
        guard let number = self.numberTextField.text, OPPCardPaymentParams.isNumberValid(number, luhnCheck: true) else {
            throw CardParamsError.invalidParam(RechargeStrings.errCardNumber.localizedValue)
        }
//        if let name = self.holderTextField.text{
//            let arr = name.split(separator: " ")
//            if arr.count < 2{
//                throw CardParamsError.invalidParam(RechargeStrings.errCardHolderName.localizedValue)
//            }
//        }
        guard let holderName = self.holderTextField.text, OPPCardPaymentParams.isHolderValid(holderName) else {
            throw CardParamsError.invalidParam(RechargeStrings.errCardHolderName.localizedValue)
        }
        if let date = self.expiryMonthTextField.text{
            let expire = date.components(separatedBy: "/")
            var year = ""
            var month = ""
            if expire.count != 2{
                throw CardParamsError.invalidParam(RechargeStrings.errExpiryDate.localizedValue)
            }else{
                year = expire[1].trimmingCharacters(in:
                                                        CharacterSet.whitespaces)
                month = expire[0].trimmingCharacters(in:
                                                        CharacterSet.whitespaces)
                if year.count == 2{
                    year = "20"+year
                }
            }
            print("year =\(year)")
            print("month= \(month)")
            if OPPCardPaymentParams.isExpired(withExpiryMonth: month, andYear: year) {
                throw CardParamsError.invalidParam(RechargeStrings.errExpiryDate.localizedValue)
            }
        }
        
        guard let cvv = self.cvvTextField.text, OPPCardPaymentParams.isCvvValid(cvv) else {
            throw CardParamsError.invalidParam(RechargeStrings.errCVV.localizedValue)
        }
    }
    
    // MARK: - Safari Delegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        }
    }
    
    // MARK: - Keyboard dismissing on tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension CustomHyperPayVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expiryMonthTextField{
            if expiryMonthTextField.text?.count == 2{
                if !(string == "") {
                    expiryMonthTextField.text = expiryMonthTextField.text! + "/"
                }
            }
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            let value = allowedCharacters.isSuperset(of: characterSet)
            if value{
                return !(textField.text!.count > 7 && (string.count ) > range.length)
            }
            return value
        }else if textField != self.holderTextField{
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        viewSaveCard.tag = 0
        imgSavedCredit.image = UIImage(named: "ic_checkbox_unchecked")
        if sender == numberTextField{
            //SET SPACE
            if sender.text!.count > 0 && sender.text!.count % 5 == 0 && sender.text!.last! != " " {
                sender.text!.insert(" ", at:sender.text!.index(sender.text!.startIndex, offsetBy: sender.text!.count-1) )
            }
        }else if sender == expiryMonthTextField{
            expiryMonthTextField.text = String(expiryMonthTextField.text!.prefix(7))
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == holderTextField{
            cvvTextField.becomeFirstResponder()
        }
        return true
    }
}
