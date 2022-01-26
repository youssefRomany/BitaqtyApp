//
//  ErrorView.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/12/21.
//

import Foundation
import UIKit
import Lottie

class ErrorView: UIView {
    @IBOutlet weak var parentLoaderView: UIView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var viewNoData: UIView!

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var lblLoadingMsg: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var lblNoData: UILabel!

    weak var delegate: ReloadDataDelegate? = nil
    var isErrorView = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    // MARK: setup view
    
    private func loadViewFromNib() -> UIView {
        let viewBundle = Bundle(for: type(of: self))
        let view = viewBundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]
        self.tag = 0;
        return view as! UIView
    }
    
    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
        lblLoadingMsg.textAlignment = lang == "en" ? .left : .right
        setupUI()
    }
    
    
    
    func setupUI(){
        parentLoaderView.isHidden = true
        loaderView.layer.cornerRadius = 2
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        let keypath = AnimationKeypath(keys: ["**", "Stroke 1", "**", "Color"])
        let colorProvider = ColorValueProvider(UIColor.accentColor.lottieColorValue)
        animationView.setValueProvider(colorProvider, keypath: keypath)
        btnRetry.setTitle(msgs.retry.localizedValue, for: .normal)
        btnRetry.round(to: 5)
    }
    
    
    func startLoading(_ msg: String = strings.loading.localizedValue) {
        self.viewError.isHidden = true
        lblLoadingMsg.text = msg
        self.isHidden = false
        parentLoaderView.isHidden = false
        loaderView.isHidden = false
        animationView.play()
    }
    
    func stopLoading() {
        parentLoaderView.isHidden = true
        animationView.stop()
        self.isHidden = true
    }
    func showException(error: ErrorMessage){
        self.isHidden = false
        parentLoaderView.isHidden = false
        loaderView.isHidden = true
        viewNoData.isHidden = true
        viewError.isHidden = true
        lblErrorMsg.text = error.errorMessage
        let _ = print("Noura \(error.errorCode)  \(error.errorMessage)")
        btnRetry.isHidden = false
        if error.errorCode == "\(ErrorType.Empty.rawValue)" || error.errorMessage == errorMsgs.no_data.localizedValue{
            viewNoData.isHidden = false
            viewError.isHidden = true
            lblNoData.text = errorMsgs.no_data.localizedValue
        }else{
            viewError.isHidden = false
            imgError.image = UIImage(named: "ic_server_error")
            btnRetry.isHidden = false
            imgError.isHidden = false
        }
    }
    
    func showNoData(){
        self.isHidden = false
        parentLoaderView.isHidden = false
        lblNoData.text = errorMsgs.no_data.localizedValue
        loaderView.isHidden = true
        viewNoData.isHidden = false
        viewError.isHidden = true
    }
    
    func showInternetOff(){
        viewNoData.isHidden = true
        self.isHidden = false
        parentLoaderView.isHidden = false
        viewError.isHidden = false
        loaderView.isHidden = true
        lblErrorMsg.text = errorMsgs.internet.localizedValue
        btnRetry.isHidden = false
        imgError.isHidden = false
    }
    
    @IBAction func retryClicked(_ sender: Any) {
        if delegate != nil{
            self.isHidden = true
            delegate!.reloadData()
        }
    }
}
