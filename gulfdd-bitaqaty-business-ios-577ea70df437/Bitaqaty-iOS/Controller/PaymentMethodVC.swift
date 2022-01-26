//
//  PaymentMethodVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/8/21.
//

import UIKit

class PaymentMethodVC: UIViewController {
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var instructionView: InstructionsView!
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var viewUnderLine: UIView!

    @IBOutlet weak var lblRechargeAmount: UILabel!
    @IBOutlet weak var lblAfter: UILabel!
    @IBOutlet weak var lblAgreeOn: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblErrorAmount: UILabel!
    @IBOutlet weak var lblErrorTerms: UILabel!

    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtAfter: UITextField!
    
    @IBOutlet weak var imgTerms: UIImageView!
    
    @IBOutlet weak var viewTerms: UIView!
    @IBOutlet weak var viewTransfer: UIView!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnRecharge: UIButton!
    var arr: [String] = []
    
    var type: Int = -1
    var rechargeMethod: RechargeMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleHeader()
        instructionView.setData(type)
        self.instructionView.tableView.delegate = self
        setupTableView()
        loadSettings()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
        self.instructionView.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.instructionView.tableHeightConst.constant = newSize.height
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.setStatusBar(color: .white)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setStatusBar(color: .bgColor)
    }
    func loadSettings(){
        if SETTINGS.count == 0{
            GeneralAPIs.getSettings {
                self.setupUI()
            } _: { (err) in
                if err.errorCode == "\(ErrorType.Auth.rawValue)"{
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }
        }
    }
    func handleHeader(){
        var title = ""
        switch type {
        case RechargeTypes.Mada.rawValue:
            title = strings.mada.localizedValue
            arr = [RechargeStrings.mada_instructions1.localizedValue, RechargeStrings.mada_instructions2.localizedValue, RechargeStrings.mada_instructions3.localizedValue, RechargeStrings.mada_instructions4.localizedValue, RechargeStrings.mada_instructions5.localizedValue, RechargeStrings.mada_instructions6.localizedValue]
        case RechargeTypes.Amex.rawValue:
            title = strings.amex.localizedValue
            arr = [RechargeStrings.amex_instructions1.localizedValue, RechargeStrings.amex_instructions2.localizedValue, RechargeStrings.amex_instructions3.localizedValue, RechargeStrings.amex_instructions4.localizedValue, RechargeStrings.amex_instructions5.localizedValue, RechargeStrings.amex_instructions6.localizedValue]
        case RechargeTypes.Credit.rawValue:
            title = strings.credit.localizedValue
            arr = [RechargeStrings.mada_instructions1.localizedValue, RechargeStrings.mada_instructions2.localizedValue, RechargeStrings.mada_instructions3.localizedValue, RechargeStrings.mada_instructions4.localizedValue, RechargeStrings.mada_instructions5.localizedValue, RechargeStrings.mada_instructions6.localizedValue]
        default:
            title = ""
        }
        self.instructionView.tableView.reloadData()
        self.viewHeader.showX(title){
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setupUI(){
        txtAmount.delegate = self
        txtAmount.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        self.btnTerms.contentHorizontalAlignment = lang == "en" ? .left : .right
        self.instructionView.lblTitle.textAlignment = lang == "en" ? .left : .right
        self.lblErrorAmount.textAlignment = lang == "en" ? .left : .right
        self.lblErrorTerms.textAlignment = lang == "en" ? .left : .right
        self.txtAfter.textAlignment = lang == "en" ? .left : .right
        self.txtAmount.textAlignment = lang == "en" ? .left : .right
        
        viewTerms.tag = 0
        var min = ""
        var max = ""
        if SETTINGS.count > 0{
            if type == RechargeTypes.Mada.rawValue{
                let minV = SETTINGS.first{$0.propertyKey == SETTING_KEYS.MADA_MINIMUM_AMOUNT_PER_REQUEST.rawValue}
                if minV != nil{
                    min = minV!.PropertyValue
                }
                
                let maxV = SETTINGS.first{$0.propertyKey == SETTING_KEYS.MADA_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}
                if maxV != nil{
                    max = maxV!.PropertyValue
                }
            }else if type == RechargeTypes.Credit.rawValue{
                let minV = SETTINGS.first{$0.propertyKey == SETTING_KEYS.CREDIT_CARD_MINIMUM_AMOUNT_PER_REQUEST.rawValue}
                if minV != nil{
                    min = minV!.PropertyValue
                }
                let maxV = SETTINGS.first{$0.propertyKey == SETTING_KEYS.CREDIT_CARD_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}
                if maxV != nil{
                    max = maxV!.PropertyValue
                }
            }else if type == RechargeTypes.Amex.rawValue{
                let minV = SETTINGS.first{$0.propertyKey == SETTING_KEYS.AMEX_MINIMUM_AMOUNT_PER_REQUEST.rawValue}
                if minV != nil{
                    min = minV!.PropertyValue
                }
                let maxV = SETTINGS.first{$0.propertyKey == SETTING_KEYS.AMEX_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}
                if maxV != nil{
                    max = maxV!.PropertyValue
                }
            }
        }
        self.viewTransfer.setupShadowsWithRound(5)
        self.lblRechargeAmount.text = RechargeStrings.rechargeAmount.localizedValue
        if let user = DataService.getUserData(), user.reseller != nil{
            if user.reseller!.CurrencyEN.uppercased() == "SAR" || user.reseller!.CurrencyEN.uppercased() == "USD"{
                self.lblAfter.text = RechargeStrings.madaAmountAfter.localizedValue
            }else{
                self.lblAfter.text = type == RechargeTypes.Mada.rawValue ? RechargeStrings.madaAmountAfter.localizedValue : RechargeStrings.amountAfterFees.localizedValue
            }
            
            txtAmount.placeholder = RechargeStrings.rechargeAmountHint.localizedValue.replacingOccurrences(of: "[CURRENCY]", with: user.reseller!.Currency)
        }
        self.lblErrorAmount.text = RechargeStrings.errEnterAmount.localizedValue
        self.lblErrorTerms.text = RechargeStrings.errEnterAmount.localizedValue

        txtAfter.placeholder = RechargeStrings.AmountAfterFeesHint.localizedValue
        self.lblAgreeOn.text = RechargeStrings.agreeOn.localizedValue
        
        self.btnTerms.setTitle(RechargeStrings.termsAndConditions.localizedValue, for: .normal)
        self.btnTerms.underline()
        if(lang == "ar"){
            self.viewUnderLine.isHidden = false
        }
        self.lblMax.text = RechargeStrings.maxAmount.localizedValue.replacingOccurrences(of: "[X]", with: max)
        self.lblMin.text = RechargeStrings.minAmount.localizedValue.replacingOccurrences(of: "[X]", with: min)
        self.btnRecharge.setTitle(strings.Recharge.localizedValue, for: .normal)
        
        btnRecharge.round(to: 5)
        txtAfter.round(to: 5)
        txtAmount.round(to: 5)
        txtAfter.isEnabled = false
        txtAmount.textAlignment = lang == "en" ? .left : .right
        txtAfter.textAlignment = lang == "en" ? .left : .right
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        self.lblErrorAmount.isHidden = true
        if let text = sender.text, text.isEmpty{
            let _ = print("NouraNOOOOO11111 =\(sender.text)")
            self.txtAfter.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.txtAfter.text = ""
            }
        }else{
            setAmountData()
        }
    }

    @IBAction func btnRechargeClicked(_ sender: Any) {
        if (validateRecharge()){
            getCheckoutId()
        }
    }
    @IBAction func btnViewTerms(_ sender: Any) {
        let vc = TermsAndConditionsVC(nibName: "TermsAndConditionsVC", bundle: nil)
        vc.type = type
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func btnTermsClicked(_ sender: Any) {
        lblErrorTerms.isHidden = true
        if viewTerms.tag == 0{
            viewTerms.tag = 1
            imgTerms.image = UIImage(named: "ic_checkbox_checked")
        }else{
            viewTerms.tag = 0
            imgTerms.image = UIImage(named: "ic_checkbox_unchecked")
        }
    }
    func validateRecharge() -> Bool{
        var isValid = false
        self.lblErrorAmount.isHidden = true
        self.lblErrorTerms.isHidden = true

        if self.txtAmount.text != nil && !self.txtAmount.text!.isEmpty{
            isValid = true
        }else{
            self.lblErrorAmount.isHidden = false
            isValid = false
        }
        if viewTerms.tag == 0{
            isValid = false
            self.lblErrorTerms.isHidden = false
        }else{
            isValid = true
        }
        return isValid
    }
    
    func getCheckoutId(){
        if rechargeMethod != nil{
            loaderView.startLoading()
            let text = self.txtAmount.text
            let amount = text!.replacedArigitsWithEn
            let value = Double(amount) ?? 0.0
            RechargeAPIs.getCheckOutId(rechargeMethod: rechargeMethod!, amount: value) { (result) in
                print(result)
                self.loaderView.stopLoading()
                let vc = CustomHyperPayVC(nibName: "CustomHyperPayVC", bundle: nil)
                vc.type = self.type
                vc.amount = amount
                vc.rechargeMethod = self.rechargeMethod!
                vc.checkoutId = result.CheckoutId
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true, completion: nil)
            } _: { [self] (err) in
                print(err)
                self.loaderView.stopLoading()
                if err.errorCode == "\(ErrorType.Auth.rawValue)"{
                    DataService.ds.showAlert(self, err.errorMessage) {
                        DataService.deleteUserData()
                        DataService.loadHome()
                    }
                }else{
                    self.setError(err)
                }
            }
        }
    }
    func setError(_ err: ErrorMessage){
        if err.errorCode == ERROR_CODES.MIN_AMOUNT_PER_REQUESTS.rawValue {
            var value = ""
            if type == RechargeTypes.Credit.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.CREDIT_CARD_MINIMUM_AMOUNT_PER_REQUEST.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Mada.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.MADA_MINIMUM_AMOUNT_PER_REQUEST.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Amex.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.AMEX_MINIMUM_AMOUNT_PER_REQUEST.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }
            DataService.ds.showAlert(self, RechargeStrings.minAmountMessage.localizedValue.replacingOccurrences(of: "[X]", with: value))
        }else if err.errorCode == ERROR_CODES.MAX_AMOUNT_PER_REQUESTS.rawValue {
            var value = ""
            if type == RechargeTypes.Credit.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.CREDIT_CARD_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Mada.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.MADA_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Amex.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.AMEX_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }
            DataService.ds.showAlert(self, RechargeStrings.maxAmountMessage.localizedValue.replacingOccurrences(of: "[X]", with: value))
            
            
        }else if err.errorCode == ERROR_CODES.TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue {
            var value = ""
            if type == RechargeTypes.Credit.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.CREDIT_CARD_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Mada.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.MADA_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Amex.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.AMEX_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }
            DataService.ds.showAlert(self, err.errorMessage.replacingOccurrences(of: "[X]", with: value))
        }else if err.errorCode == ERROR_CODES.MAX_REQUEST_PER_DAY.rawValue || err.errorCode == ERROR_CODES.NUMBER_OF_REQUESTS_PER_DAY.rawValue{
            var value = ""
            if type == RechargeTypes.Credit.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.CREDIT_CARD_NUMBER_OF_REQUESTS_PER_DAY.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Mada.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.MADA_NUMBER_OF_REQUESTS_PER_DAY.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }else if type == RechargeTypes.Amex.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.AMEX_NUMBER_OF_REQUESTS_PER_DAY.rawValue}
                if data != nil{
                    value = data!.PropertyValue
                }
            }
            DataService.ds.showAlert(self, err.errorMessage.replacingOccurrences(of: "[X]", with: value))
        }else{
            DataService.ds.showAlert(self, err.errorMessage)
        }
    }
}
extension PaymentMethodVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        let allowedCharacters = CharacterSet(charactersIn:"0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        let dots = text.filter { $0 == "." }
        let _ = print("Noura==== \(allowedCharacters.isSuperset(of: characterSet)) \(dots.count == 0 || string != ".")")
        return allowedCharacters.isSuperset(of: characterSet) && (dots.count == 0 || string != ".")
//
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        let value = allowedCharacters.isSuperset(of: characterSet)
//        //        if(value){
//        //            setAmountData()
//        //        }
//        return value
    }
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        setAmountData()
    //    }
//        func textFieldDidEndEditing(_ textField: UITextField) {
//            let _ = print("NouraHRERERE")
//        }
    func setAmountData(){
        if let text = txtAmount.text, !text.isEmpty{
            let amount = text.replacedArigitsWithEn
            let value = Double(amount) ?? 0.0
            if value == 0.0{
                self.txtAfter.text = ""
                return
            }
            if rechargeMethod != nil{
                RechargeAPIs.getAmountAfter(rechargeMethod: rechargeMethod!, amount: value) { (result) in
                    let res = result.AmountAfter
//                    if lang == "ar"{
//                        res = res.replacedEnglishDigitsWithArabic
//                    }
                    self.txtAfter.text = "\(res) \(strings.sar.localizedValue)"
                } _: { (err) in
                    print(err)
                    if err.errorCode == "\(ErrorType.Auth.rawValue)"{
                        DataService.ds.showAlert(self, err.errorMessage) {
                            DataService.deleteUserData()
                            DataService.loadHome()
                        }
                    }else{
                        DataService.ds.showAlert(self, err.errorMessage){
                            self.txtAfter.text = ""
                        }
                    }
                }
            }
        }else{
            txtAfter.text = ""
        }
    }
}
extension PaymentMethodVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        instructionView.tableView.registerCellNib(cellClass: InstructionCell.self);
        instructionView.tableView.delegate = self
        instructionView.tableView.dataSource = self
        instructionView.tableView.tableFooterView = UIView();
        instructionView.tableView.estimatedRowHeight = 120;
        instructionView.tableView.rowHeight = UITableView.automaticDimension;
        instructionView.tableView.backgroundColor = UIColor.clear;
        instructionView.tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        instructionView.tableView.allowsSelection = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as? InstructionCell{
            cell.lbl.text = arr[indexPath.row]
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

}
