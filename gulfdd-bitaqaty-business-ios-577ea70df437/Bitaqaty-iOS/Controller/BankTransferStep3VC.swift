//
//  BankTransferStep3VC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit
import XLPagerTabStrip

class BankTransferStep3VC: UIViewController {
    @IBOutlet weak var viewRequestInfo: UIView!
    @IBOutlet weak var lblSenderBankHeader: UILabel!
    @IBOutlet weak var lblSenderBank: UILabel!
    @IBOutlet weak var lblOneCardBankHeader: UILabel!
    @IBOutlet weak var lblOneCardBank: UILabel!
    @IBOutlet weak var viewTransferAmount: RoundedTextField!
    @IBOutlet weak var stackRechargeAmount: UIStackView!
    @IBOutlet weak var lblRechargeAmount: UILabel!
    @IBOutlet weak var lblRechargeAmountValue: UILabel!
    @IBOutlet weak var lblMinAmount: UILabel!
    @IBOutlet weak var lblMaxAmount: UILabel!
    @IBOutlet weak var viewTransferDate: DropDownView!
    @IBOutlet weak var viewRefNo: RoundedTextField!
    @IBOutlet weak var btnPrevious: BtnMediumRegularFont!
    @IBOutlet weak var btnNext: UIButton!
    
    var itemInfo: IndicatorInfo = "View";
    var viewModel: BankTransferViewModel?
    weak var delegate: BankTransferDelegate!
    var timer: Timer? = nil
    var showRef = false
    
    var min: String = ""
    var max: String = ""
    var maxRequest: String = ""
    var maxAmountPerDay: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lblSenderBank.text = "\(viewModel?.senderAccount?.getBankName() ?? "")\n\(viewModel?.senderAccount?.getCountryName() ?? "")"
        lblOneCardBank.text = "\(viewModel?.oneCardAccount?.getBankName() ?? "")\n\(viewModel?.oneCardCountry?.getCurrentName() ?? "")"
        if viewModel?.oneCardAccount?.refNumberIsMandatory == true{
            viewRefNo.isHidden = false
            showRef = true
        }else{
            showRef = false
            viewRefNo.isHidden = true
        }
        viewTransferAmount.lblTransferCurrency.isHidden = false
        viewTransferAmount.lblTransferCurrency.text = viewModel?.oneCardAccount?.getCurrency() ?? btrrStrings.sar_full.localizedValue
        viewModel?.request.fromBankId = viewModel?.senderAccount?.fromBankId
        viewModel?.request.bankAccountNumber = viewModel?.senderAccount?.bankAccountNumber
        viewModel?.request.fromCountryId = viewModel?.senderAccount?.fromCountryId
        viewModel?.request.senderName = viewModel?.senderAccount?.getSenderName()
        viewModel?.request.oneCardBankAccountId = viewModel?.oneCardAccount?.oneCardBankAccountId
    }
    @IBAction func previous(_ sender: Any) {
        viewModel?.request.transferAmount = nil
        viewTransferAmount.txt.text = ""
        stackRechargeAmount.isHidden = true
        delegate.previous()
    }
    @IBAction func next(_ sender: Any) {
        let ref = viewRefNo.txt.text!.replacedArigitsWithEn.trimmingCharacters(in: .whitespaces)
        var valid = true
        if viewTransferAmount.txt.text.isNilOrEmpty == true{
            valid = false
            viewTransferAmount.lblError.text = errorMsgs.field_required.localizedValue
            viewTransferAmount.lblError.isHidden = false
        }
        if viewModel?.request.transferDate.isNilOrEmpty == true {
            valid = false
            viewTransferDate.lblError.text = errorMsgs.field_required.localizedValue
            viewTransferDate.lblError.isHidden = false
        }
        if ref.isEmpty == true && showRef{
            valid = false
            viewRefNo.lblError.text = errorMsgs.field_required.localizedValue
            viewRefNo.lblError.isHidden = false
        }
        
        if valid{
            viewModel?.request.refNumber = ref
            delegate.startLoading()
            if (viewModel!.saveAccount){
                BankTransferAPIs.saveAccount(request: viewModel!, self)
            }else{
                BankTransferAPIs.placeRequest(viewModel!, self)
            }
        }
    }
}
extension BankTransferStep3VC{
    func setupUI(){
        lblOneCardBank.textAlignment = lang == "en" ? .right : .left
        lblSenderBank.textAlignment = lang == "en" ? .right : .left
        stackRechargeAmount.isHidden = true
        viewRequestInfo.setupWithRoundNoShadow(10)
        lblSenderBankHeader.text = btrrStrings.btrr_transfer_from.localizedValue
        lblOneCardBankHeader.text = btrrStrings.btrr_transfer_to.localizedValue
        viewTransferAmount.setData(btrrStrings.btrr_transfer_amount.localizedValue, btrrStrings.btrr_export_amount.localizedValue, 0, .decimalPad,showRef ? .next : .done)
        viewTransferDate.setup(btrrStrings.btrr_transfer_date.localizedValue, "dd/mm/yy") {
            self.openSelectDate()
        }
        lblRechargeAmount.text = btrrStrings.btrr_recharge_amount.localizedValue
        viewTransferDate.setIcon(named: "ic_calendar")
        viewRefNo.setData(btrrStrings.btrr_reference_no.localizedValue, btrrStrings.btrr_reference_no_hint.localizedValue, 1, .default, .done)
        min = SETTINGS.first{$0.propertyKey == SETTING_KEYS.BANK_TRANSFER_MINIMUM_AMOUNT_PER_REQUEST.rawValue}?.PropertyValue ?? "0"
        max = SETTINGS.first{$0.propertyKey == SETTING_KEYS.BANK_TRANSFER_MAXIMUM_AMOUNT_PER_REQUEST.rawValue}?.PropertyValue ?? "0"
        maxRequest = SETTINGS.first{$0.propertyKey == SETTING_KEYS.BANK_TRANSFER_NUMBER_OF_REQUESTS_PER_DAY.rawValue}?.PropertyValue ?? "0"
        maxAmountPerDay = SETTINGS.first{$0.propertyKey == SETTING_KEYS.BANK_TRANSFER_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue}?.PropertyValue ?? "0"
        
        lblMinAmount.text = "\(btrrStrings.btrr_min_amount_per_request.localizedValue.replacingOccurrences(of: "XSAR", with: min)) \(btrrStrings.sar_full.localizedValue)"
        lblMaxAmount.text = "\(btrrStrings.btrr_max_amount_per_request.localizedValue.replacingOccurrences(of: "XSAR", with: max)) \(btrrStrings.sar_full.localizedValue)"
        
        btnNext.layer.cornerRadius = 4
        btnNext.clipsToBounds = true
        btnNext.setTitle(msgs.next.localizedValue, for: .normal)
        
        btnPrevious.setTitle(msgs.back.localizedValue, for: .normal)
        btnPrevious.layer.cornerRadius = 4
        btnPrevious.layer.borderColor = UIColor.accentColor.cgColor
        btnPrevious.layer.borderWidth = 1
        viewTransferAmount.txt.delegate = self
        viewRefNo.txt.delegate = self
        viewTransferAmount.txt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func openSelectDate(){
        let vc = DateTimePicker(nibName: "DateTimePicker", bundle: nil)
        vc.isDateOnly = true
        vc.date = viewModel?.request.transferDate
        vc.type = 0
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @objc func calculateRechargeAmount(timer: Timer){
        let userInfo = timer.userInfo as! [String: UITextField]
        if let field = userInfo["textField"],let amount = field.text{
            viewModel?.request.transferAmount = amount.getStrEnglishNo()
            BankTransferAPIs.calculateRecharge(request: viewModel!.request, self)
        }
    }
}

extension BankTransferStep3VC: OnFinishDelegate{
    func onSuccess(double: Double) {
        stackRechargeAmount.isHidden = false
        lblRechargeAmountValue.text = "\(double.removeZerosFromEnd()) \(DataService.getUserData()?.reseller?.Currency ?? "")"
    }
    
    func onFailed(err: ServiceError, _ tag: Int) {
        delegate.stopLoading()
        if tag == 0 {
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        }else if tag == 2{
            switch err {
            case .noInternetConnection,.other:
                DataService.ds.showAlert(self, err.errorDescription)
            default:
                var msg = errorMsgs.server.localizedValue
                switch err.code {
                case BankTransferError.CHARGING_BANK_TRANSFER_AMOUNT_LESS_THAN_MIN_AMOUNT.rawValue:
                    msg = errorMsgs.min_amount_per_request.localizedValue.replacingOccurrences(of: "XSAR", with: "\(min) \(btrrStrings.sar_full.localizedValue)")
                    break;
                case BankTransferError.CHARGING_BANK_TRANSFER_AMOUNT_GREATER_THAN_MAX_AMOUNT.rawValue:
                    msg = errorMsgs.max_amount_per_request.localizedValue.replacingOccurrences(of: "XSAR", with: "\(max) \(btrrStrings.sar_full.localizedValue)")
                    
                case BankTransferError.EXCEEDED_MAXIMUM_NUMBER_OF_REQUESTS.rawValue:
                    msg = errorMsgs.max_request_per_day.localizedValue.replacingOccurrences(of: "D/R",with: "\(maxRequest)")
                    
                case BankTransferError.CHARGING_BANK_TRANSFER_AMOUNT_PER_DAY.rawValue:
                    msg = errorMsgs.max_amount_per_day.localizedValue.replacingOccurrences(of: "XSAR",with: "\(maxAmountPerDay) \(btrrStrings.sar_full.localizedValue)")
                    
                case BankTransferError.BANK_ACCOUNT_ALREADY_EXIST.rawValue:
                    msg = errorMsgs.account_no_saved_before.localizedValue
                default:
                    msg = errorMsgs.server.localizedValue
                }
                DataService.ds.showAlert(self, msg)
            }
        }else{
            lblRechargeAmountValue.text = "0.0 \(DataService.getUserData()?.reseller?.Currency ?? "")".replacedEnglishDigitsWithArabic
            viewModel?.request.transferAmount = nil
        }
    }
    
    func onSuccess() {
        delegate.stopLoading()
        let vc = SuccessErrorPaymentVC(nibName: "SuccessErrorPaymentVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.type = RechargeTypes.Bank.rawValue
        vc.isSuccess = true
        present(vc, animated: true, completion: nil)
    }
}

extension BankTransferStep3VC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        
    }
    
    func getDate(_ type: Int,_ date: Date) {
        let strDate = DateUtils.getTransferDate(date)
        let localizedDate = DateUtils.getLocalizeTransferDate(date)
        viewModel?.request.transferDate = strDate
        viewTransferDate.lblError.isHidden = true
        viewTransferDate.lbl.text = localizedDate
    }
}

extension BankTransferStep3VC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == viewTransferAmount.txt.tag && showRef){
            viewRefNo.txt.becomeFirstResponder()
        }else{
            view.resignFirstResponder()
            view.endEditing(true)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        if (textField.tag == viewTransferAmount.txt.tag){
            viewTransferAmount.lblError.isHidden = true
            let invalidCharacters = CharacterSet(charactersIn: "0123456789٠١٢٣٤٥٦٧٨٩.").inverted
            return string.rangeOfCharacter(from: invalidCharacters) == nil;
        }else{
            viewRefNo.lblError.isHidden = true
        }
        return count <= 250
    }
    
    @objc func textFieldDidChange(textField: UITextField) -> Void {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.3,
            target: self,
            selector: #selector(BankTransferStep3VC.calculateRechargeAmount),
            userInfo: ["textField": textField],
            repeats: false)
    }
}
extension BankTransferStep3VC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

