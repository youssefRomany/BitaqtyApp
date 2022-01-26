//
//  VerificationVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
import Lottie
class VerificationVC: UIViewController {
    
    @IBOutlet weak var stackTrials: UIStackView!
    @IBOutlet weak var loaderView: ErrorView!
    @IBOutlet weak var header: SignHeaderView!
    @IBOutlet weak var txtCodeView: TextFieldView!
    @IBOutlet weak var lblResend: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblTrial: UILabel!
    @IBOutlet weak var stackCounter: UIStackView!
    @IBOutlet weak var lblWait: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var timerView: AnimationView!
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var lblCopyRight: UILabel!
    var trial = 0
    var remainingTrials: RemainingTrials? = nil
    var showTime = false
    
    override func viewDidLoad() {
        setupUI()
        txtCodeView.txt.delegate = self
        loadData()
    }
    
    
    @IBAction func verify(_ sender: UIButton) {
        view.endEditing(true)
        loaderView.startLoading(accountStrings.verification_verifying.localizedValue)
        AccountServices.validateAndVerify(code: txtCodeView.txt.text!, self)
    }
    @IBAction func resendCode(_ sender: Any) {
        view.endEditing(true)
        loaderView.startLoading(strings.loading.localizedValue)
        AccountServices.authenticatedLogin(self)
    }
}

extension VerificationVC{
    
    fileprivate func setupUI(){
        header.setData(accountStrings.sign_welcome.localizedValue,accountStrings.verification_enter_code.localizedValue , accountStrings.verification_instruction.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        txtCodeView.setData(accountStrings.verification_code.localizedValue, accountStrings.code.localizedValue, 0, .numberPad, .done)
        let attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.semiBoldSmall,
            NSAttributedString.Key.foregroundColor: UIColor.accentColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(
            string: accountStrings.verification_resend.localizedValue,
            attributes: attrs)
        lblResend.text = accountStrings.verification_resend_message.localizedValue
        btnResend.setAttributedTitle(attributeString, for: .normal)
        lblTrial.isHidden = true
        lblWait.text = accountStrings.verification_wait.localizedValue
        lblUnit.text = strings.secs.localizedValue
        stackCounter.isHidden = true
        btnSign.setTitle(accountStrings.sign_in.localizedValue, for: .normal)
        lblCopyRight.text = strings.CRText.localizedValue
        setAnimationView()
    }
    
    fileprivate func setAnimationView(){
        timerView.contentMode = .scaleAspectFit
        timerView.loopMode = .playOnce
        if (lang != "en"){
            timerView.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
        let keypath = AnimationKeypath(keys: ["**", "Stroke 1", "**", "Color"])
        let colorProvider = ColorValueProvider(UIColor.accentColor.lottieColorValue)
        timerView.setValueProvider(colorProvider, keypath: keypath)
    }
    
    
    fileprivate func setupCounter(){
        if let trials = remainingTrials{
            trial = trials.ResendSmsTrials - trials.RemainingResendSmsTrials
            stackCounter.isHidden = false
            if (!showTime){
                showTime = true
                self.stackCounter.isHidden = true
                self.timerView.isHidden = true
                self.btnResend.isEnabled = true
                self.btnResend.alpha = 1
            }else{
                if (trial < trials.ResendSmsTrials){
                    btnResend.isEnabled = false
                    btnResend.alpha = 0.4
                    if (trial <= 0){
                        lblTrial.isHidden = true
                    }else{
                        lblTrial.isHidden = false
                    }
                    lblTrial.text = "\(trial)/\(trials.ResendSmsTrials) \(accountStrings.verification_trial.localizedValue)"
                    lblUnit.text = strings.secs.localizedValue
                    var remainingTime = trials.WaitingSecondsToResendSms
                    timerView.animationSpeed = 1 / CGFloat(trials.WaitingSecondsToResendSms + 10)
                    timerView.play()
                    self.lblCounter.text = "\(remainingTime)"
                    Timer.scheduledTimer(withTimeInterval: 1,repeats: true){(Timer) in
                        if (remainingTime > 0){
                            remainingTime -= 1
                            self.lblCounter.text = "\(remainingTime)"
                        }else{
                            self.stackCounter.isHidden = true
                            self.timerView.isHidden = true
                            self.btnResend.isEnabled = true
                            self.btnResend.alpha = 1
                            Timer.invalidate()
                        }
                    }
                }else{
                    stackCounter.isHidden = true
                    lblTrial.isHidden = true
                    timerView.isHidden = true
                    btnResend.isEnabled = false
                    btnResend.alpha = 0.4
                    stackTrials.isHidden = true
                    stackCounter.isHidden = false
                    var remainingTime = trials.ShowResendSmsLinkMinutes * 60
                    var time = self.getRemainingTime(sec: remainingTime)
                    lblCounter.text = "\(Int(time.0))"
                    lblUnit.text = time.1
                    Timer.scheduledTimer(withTimeInterval: 1,repeats: true){(Timer) in
                        remainingTime -= 1
                        time = self.getRemainingTime(sec: remainingTime)
                        if (time.0 >= 1){
                            self.lblCounter.text = "\(Int(time.0))"
                            self.lblUnit.text = time.1
                        }else{
                            self.stackCounter.isHidden = true
                            self.stackTrials.isHidden = false
                            self.btnResend.isEnabled = true
                            self.btnResend.alpha = 1
                            Timer.invalidate()
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func getRemainingTime(sec: Double) -> (Double , String){
        var min = sec / 60
        if (min > 1) {
            if (min != floor(min)){
                min += 1
            }
            return (min,strings.mins.localizedValue)
        }else {
            return (sec,strings.secs.localizedValue)
        }
    }
    
    fileprivate func loadData(){
        loaderView.startLoading(strings.loading.localizedValue)
        AccountServices.getRemeaniningTrials(false, self)
    }
    
    fileprivate func handleErrorCode(_ error: ErrorMessage){
        switch error.errorCode {
        case API_ERRORS.InvalidLoginProcessToken.rawValue:
            DataService.ds.showAlert(self, errorMsgs.unauthorized.localizedValue){
                DataService.loadHome()
            }
        case API_ERRORS.SmsAuthSent.rawValue,API_ERRORS.IpLocationSMSAuthSent.rawValue:
            loadData()
        case API_ERRORS.ExceededMaxAllowedSms.rawValue:
            DataService.ds.showAlert(self, errorMsgs.sms_exceeded.localizedValue){
                DataService.loadHome()
            }
        case API_ERRORS.ExceededMaxAllowedResendSmsLimit.rawValue:
            DataService.ds.showAlert(self, errorMsgs.sms_resend_exceeded.localizedValue)
        case API_ERRORS.InvalidSmsVerificationCode.rawValue:
            DataService.ds.showAlert(self, errorMsgs.invalid_verification_code.localizedValue)
        case API_ERRORS.ExceededMaxAllowedSms.rawValue:
            DataService.ds.showAlert(self, errorMsgs.sms_exceeded.localizedValue)
        case API_ERRORS.SmsVerificationExpired.rawValue:
            DataService.ds.showAlert(self, errorMsgs.verification_code_expired.localizedValue)
        default:
            DataService.ds.showAlert(self, error.errorMessage)
        }
    }
}

extension VerificationVC: OnFinishDelegate{
    func onSuccess() {
        loaderView.stopLoading()
        DataService.loadHome()
    }
    
    func onFailed(err: ServiceError) {
        loaderView.stopLoading()
        switch err {
        case .custom(let error):
            handleErrorCode(error)
        default:
            DataService.ds.showAlert(self, err.errorDescription)
        }
    }
    
    func onSuccess(_ model: RemainingTrials) {
        loaderView.stopLoading()
        remainingTrials = model
        setupCounter()
    }
    
    func onBadRequest(_ err: String, _ tag: Int) {
        loaderView.stopLoading()
        txtCodeView.lblError.text = err
        txtCodeView.lblError.isHidden = false
    }
}

extension VerificationVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtCodeView.lblError.isHidden = true
        let invalidCharacters = CharacterSet(charactersIn: "0123456789٠١٢٣٤٥٦٧٨٩").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        verify(btnSign)
        return true
    }
}
