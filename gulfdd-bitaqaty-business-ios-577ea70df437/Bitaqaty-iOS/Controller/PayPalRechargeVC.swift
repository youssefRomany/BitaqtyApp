//
//  PayPalRechargeVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 9/2/21.
//

import UIKit

class PayPalRechargeVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!    
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var instructionView: InstructionsView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewUnderLine: UIView!

    @IBOutlet weak var lblAgreeOn: UILabel!
    @IBOutlet weak var lblConfirm1: UILabel!
    @IBOutlet weak var lblConfirm2: UILabel!

    @IBOutlet weak var imgTerms: UIImageView!
    @IBOutlet weak var imgType: UIImageView!

    @IBOutlet weak var viewTerms: UIView!
    @IBOutlet weak var viewConfirmations: UIView!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblErrorTerms: UILabel!

    var type: Int = -1
    var rechargeMethod: RechargeMethod?
    var payPalList = [PayPalDenomination]()
    var amount: Double = 0.0
    var payPalDemoniation: PayPalDenomination?
    var width: CGFloat = 0.0
    var lastSelected = -1
    
    var arr = [RechargeStrings.payPalInstructions1.localizedValue, RechargeStrings.payPalInstructions2.localizedValue, RechargeStrings.payPalInstructions3.localizedValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.instructionView.tableView.delegate = self
        self.setupTableView()
        setupCollectionView()
        loadData()
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
    func setupUI(){
        viewTerms.tag = 0
        self.viewHeader.showX(strings.paypal.localizedValue){
            self.dismiss(animated: true, completion: nil)
        }
        instructionView.lblTitle.textAlignment = lang == "en" ? .left : .right
        instructionView.setData(type)
        loaderView.delegate = self
        btnTerms.contentHorizontalAlignment = lang == "en" ? .left : .right
        self.lblAgreeOn.text = RechargeStrings.agreeOn.localizedValue
        
        self.btnTerms.setTitle(RechargeStrings.termsAndConditions.localizedValue, for: .normal)
        self.btnTerms.underline()
        self.btnConfirm.setTitle(msgs.confirm.localizedValue, for: .normal)
        viewConfirmations.round(to: 5)
        btnConfirm.round(to: 5)
        self.lblErrorTerms.textAlignment = lang == "en" ? .left : .right
        self.lblErrorTerms.text = RechargeStrings.errEnterAmount.localizedValue
        if(lang == "ar"){
            self.viewUnderLine.isHidden = false
        }
    }
    
    func loadData(){
        self.loaderView.startLoading()
        RechargeAPIs.getPayPalDenominations({ [self] (result) in
            self.loaderView.stopLoading()
            self.payPalList = result
//            self.payPalList.append(contentsOf: result)
//            self.payPalList.append(contentsOf: result)
            self.collectionView.reloadData()
            var val = self.payPalList.count / 2
            val = Int(val)
            if self.payPalList.count % 2 != 0{
                val = val + 1
            }
            let height = CGFloat(val) * CGFloat(self.width + 30)
            let _ = print("Noura  self.collectionView.contentSize.height =\(height)  \(self.collectionView.contentSize.height)")
           self.heightConstraint.constant = CGFloat(height)

        },{  (err) in
            self.loaderView.stopLoading()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                self.loaderView.showException(error: err)
            }
        })
    }
    @IBAction func btnConfirmClicked(_ sender: Any) {
        if viewTerms.tag == 1{
           getCheckoutId()
        }else{
            self.lblErrorTerms.isHidden = false
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
    func getAmount(_ amount: Double){
        loaderView.startLoading()
        RechargeAPIs.getPayPalAmountAfter(rechargeMethod: rechargeMethod!, amount: amount, payPalDenomination: payPalDemoniation!) { (result) in
            self.loaderView.stopLoading()
            if let user = DataService.getUserData(), let reseller = user.reseller{
                self.lblConfirm1.text = RechargeStrings.paypal_confirmation.localizedValue.replacingOccurrences(of: "[X]", with: "\(result.Amount) \(reseller.Currency)")
            }
            self.viewConfirmations.isHidden = false
        } _: { (err) in
            print(err)
            self.loaderView.stopLoading()
            if err.errorCode == "\(ErrorType.Auth.rawValue)"{
                DataService.ds.showAlert(self, err.errorMessage) {
                    DataService.deleteUserData()
                    DataService.loadHome()
                }
            }else{
                DataService.ds.showAlert(self, err.errorMessage)
            }
        }
    }
    func getCheckoutId(){
        self.loaderView.startLoading()
        if rechargeMethod != nil{
            RechargeAPIs.getCheckOutId(rechargeMethod: rechargeMethod!, amount: self.amount, payPalDenomination: self.payPalDemoniation!) { (result) in
                print(result)
                self.loaderView.stopLoading()
                let vc = PayPalCustomPayVC(nibName: "PayPalCustomPayVC", bundle: nil)
                vc.type = self.type
                vc.amount = self.amount
                vc.rechargeMethod = self.rechargeMethod!
                vc.checkoutId = result.CheckoutId
                vc.payPalDemoniation = self.payPalDemoniation
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
        if err.errorCode == ERROR_CODES.TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue || err.errorCode == ERROR_CODES.MAX_REQUEST_PER_DAY.rawValue{
            var value = ""
            let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.PAYPAL_TOTAL_AMOUNT_OF_REQUESTS_PER_DAY.rawValue}
            if data != nil{
                value = data!.PropertyValue
            }
            DataService.ds.showAlert(self, RechargeStrings.errAmoutPerDayPayPal.localizedValue.replacingOccurrences(of: "[X]", with: value))
        }else if err.errorCode == ERROR_CODES.MAX_REQUEST_PER_DAY.rawValue {
            var value = ""
            if type == RechargeTypes.PayPal.rawValue{
                let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.PAYPAL_NUMBER_OF_REQUESTS_PER_DAY.rawValue}
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
extension PayPalRechargeVC: ReloadDataDelegate{
    func reloadData() {
        self.loadData()
    }
}
extension PayPalRechargeVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "PayPalCell", bundle: nil), forCellWithReuseIdentifier: "PayPalCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let noOfCellsInRow = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3;
        let width = (UIScreen.main.bounds.size.width - 60) / CGFloat(noOfCellsInRow);
        self.width = width
        layout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(width + 20));
        layout.scrollDirection = .vertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 20;
        collectionView!.collectionViewLayout = layout
       // collectionView.register(PayPalFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "PayPalFooterView")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)->Int {
        return self.payPalList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)->UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PayPalCell", for: indexPath) as? PayPalCell{
            cell.setData(item: payPalList[indexPath.row])
            cell.btnRecharge.tag = indexPath.row
            cell.btnRecharge.addTarget(self, action: #selector(btnRechargeTapped), for: .touchUpInside)
            return cell;
        }
        return UICollectionViewCell();
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ = print("Noura SELECTED \(indexPath.row)")
        if let cell = collectionView.cellForItem(at: indexPath) as? PayPalCell{
            cell.viewContainer.drawBorder(.accentColor, 2, 2)
            self.lastSelected = indexPath.row
            //cell.btnRecharge.tag = indexPath.row
            //cell.btnRecharge.addTarget(self, action: #selector(btnRechargeTapped), for: .touchUpInside)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PayPalCell{
            cell.viewContainer.drawBorder(UIColor.clear, 5, 0)
        }
    }
    @objc func btnRechargeTapped(sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        DispatchQueue.main.async { [self] in
            if self.lastSelected != -1{
                let indexPathLast = IndexPath(row: lastSelected, section: 0)
                self.collectionView.deselectItem(at: indexPathLast, animated: false)
                self.collectionView(self.collectionView, didDeselectItemAt: indexPathLast)
            }
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            self.collectionView(self.collectionView, didSelectItemAt: indexPath)
        }
        let item = payPalList[sender.tag]
        self.lblConfirm2.text = RechargeStrings.paypal_confirmation2.localizedValue.replacingOccurrences(of: "[Y]", with: "\(item.ResellerPrice)")
        if !item.Logo.isEmpty{
            self.imgType.url(item.Logo, imageD: UIImage(named: "nerd")!)
        }
        self.payPalDemoniation = item
        self.amount = item.ResellerPrice
        self.getAmount(item.ResellerPrice)
    }
//    private func collectionView(collectionView: UICollectionView,   viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PayPalFooterView", for: indexPath as IndexPath) as! PayPalFooterView
//            return footer
//    }
//    func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          referenceSizeForFooterInSection section: Int) -> CGSize{
//        return CGSize(width: 200, height: 200)
//    }
}
extension PayPalRechargeVC: UITableViewDelegate,UITableViewDataSource{
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
