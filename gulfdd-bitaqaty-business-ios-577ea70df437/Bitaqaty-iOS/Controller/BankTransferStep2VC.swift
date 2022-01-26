//
//  BankTransferStep2VC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit
import XLPagerTabStrip

class BankTransferStep2VC: UIViewController {
    @IBOutlet weak var indicator: UIPageControl!
    @IBOutlet weak var stackSavedAccount: UIStackView!
    @IBOutlet weak var btnNewAccount: UIButton!
    @IBOutlet weak var lblSavedAccounts: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBankCountry: DropDownView!
    @IBOutlet weak var viewBankName: DropDownView!
    @IBOutlet weak var stackOther: UIStackView!
    @IBOutlet weak var imgSort: UIImageView!
    @IBOutlet weak var txtOther: UITextField!
    @IBOutlet weak var lblOtherError: UILabel!
    @IBOutlet weak var viewAccountNo: RoundedTextField!
    @IBOutlet weak var viewSenderName: RoundedTextField!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnSaveaccount: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    var itemInfo: IndicatorInfo = "View";
    weak var delegate: BankTransferDelegate!
    
    var delfaultCountryId : Int? = nil
    var savedAccounts: [SavedAccount] = []
    var countries: [Country] = []
    var accounts: [Country] = []
    
    var selectedSavedAccount: SavedAccount? = nil
    var selecetedCountry: Country? = nil
    var selectedBankAccount: Country? = nil
    
    var steupSavedAccount = true
    var viewModel: BankTransferViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedAccounts()
    }
    
    @IBAction func createNewAccount(_ sender: UIButton) {
        btnCheckBox.tag = 0
        btnCheckBox.setBackgroundImage(UIImage(named: "ic_checkbox_unchecked"), for: .normal)
        btnCheckBox.tintColor = .borderColor
        self.clearSavedAccountData()
    }
    
    fileprivate func checkSaved() {
        btnCheckBox.tag = 1
        btnCheckBox.setBackgroundImage(UIImage(named: "ic_checkbox_checked"), for: .normal)
        btnCheckBox.tintColor = .accentColor
    }
    
    @IBAction func toggleCheckBox(_ sender: UIButton) {
        if (btnCheckBox.tag == 0){
            var changesMade = false
            let alreadySaved = checkIfAlreadySaved()
            if let account = selectedSavedAccount{
                changesMade = checkIfChangesMade(account: account)
            }
            if (changesMade || !alreadySaved) {
                checkSaved()
            }else{
                DataService.ds.showAlert(self, errorMsgs.account_no_saved_before.localizedValue)
            }
        }else{
            btnCheckBox.tag = 0
            btnCheckBox.setBackgroundImage(UIImage(named: "ic_checkbox_unchecked"), for: .normal)
            btnCheckBox.tintColor = .borderColor
        }
    }
    
    @IBAction func previous(_ sender: UIButton) {
        resetAccountData()
        delegate.previous()
    }
    
    @IBAction func next(_ sender: UIButton) {
        if (selectedSavedAccount == nil && checkIfAlreadySaved()) {
            DataService.ds.showAlert(self, errorMsgs.account_no_saved_before.localizedValue)
        } else {
            var valid = true
            if (selectedBankAccount == nil && txtOther.text!.isEmptyOrContainsOnlySpaces()){
                valid = false
                lblOtherError.text = errorMsgs.field_required.localizedValue
                lblOtherError.isHidden = false
            }
            if (viewAccountNo.txt.text!.isEmptyOrContainsOnlySpaces()){
                valid = false
                viewAccountNo.lblError.text = errorMsgs.field_required.localizedValue
                viewAccountNo.lblError.isHidden = false
            }
            if (viewSenderName.txt.text!.isEmptyOrContainsOnlySpaces()){
                valid = false
                viewSenderName.lblError.text = errorMsgs.field_required.localizedValue
                viewSenderName.lblError.isHidden = false
            }
            if (valid){
                var account = SavedAccount()
                account.fromCountryId = "\(self.selecetedCountry?.id ?? 0)"
                if let id = selectedBankAccount?.id{
                    account.fromBankId = "\(id)"
                    account.resellerBankName = selectedBankAccount?.nameEn ?? ""
                    account.resellerBankNameAr = selectedBankAccount?.nameAr ?? ""
                }else{
                    account.resellerBankName = txtOther.text!.trimmingCharacters(in: .whitespaces)
                }
                account.bankAccountNumber = viewAccountNo.txt.text!.trimmingCharacters(in: .whitespaces)
                account.setSenderName(value: viewSenderName.txt.text!.trimmingCharacters(in: .whitespaces))
                account.resellerBankCountryEn = selecetedCountry?.nameEn
                account.resellerBankCountryAr = selecetedCountry?.nameAr
                account.selected = selectedSavedAccount != nil
                viewModel?.senderAccount = account
                viewModel?.saveAccount = btnCheckBox.tag == 1
                delegate.next()
            }
        }
    }
}
extension BankTransferStep2VC{
    func setupUI(){
        if (lang != "en"){
            imgSort.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        collectionView.semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
        btnNewAccount.setTitle(btrrStrings.btrr_add_account.localizedValue, for: .normal)
        lblSavedAccounts.text = btrrStrings.btrr_saved_accounts.localizedValue
        viewBankCountry.setup(btrrStrings.btrr_sender_country.localizedValue, "") {
            self.selectCountry()
        }
        
        viewBankName.setup(btrrStrings.btrr_sender_bank_name.localizedValue, btrrStrings.btrr_select_bank.localizedValue) {
            self.selectBankAccount()
        }
        lblSavedAccounts.textAlignment = lang == "en" ? .left : .right
        lblNote.textAlignment = lang == "en" ? .left : .right
        txtOther.textAlignment = lang == "en" ? .left : .right
        txtOther.placeholder = btrrStrings.btrr_add_bank_name.localizedValue
        viewAccountNo.setData(btrrStrings.btrr_sender_bank_no.localizedValue, "", 0, .default,.next)
        viewAccountNo.txt.delegate = self
        viewSenderName.setData(btrrStrings.btrr_sender_name.localizedValue, "", 1, .default,.done)
        viewSenderName.txt.delegate = self
        txtOther.tag = 2
        txtOther.delegate = self
        lblNote.text = btrrStrings.btrr_warning.localizedValue
        btnSaveaccount.setTitle(btrrStrings.btrr_save_sender_bank.localizedValue, for: .normal)
        btnPrevious.setTitle(msgs.back.localizedValue, for: .normal)
        btnNext.setTitle(msgs.next.localizedValue, for: .normal)
        
        btnNewAccount.layer.cornerRadius = 4
        btnNewAccount.clipsToBounds = true
        
        btnNext.layer.cornerRadius = 4
        btnNext.clipsToBounds = true
        
        btnPrevious.layer.cornerRadius = 4
        btnPrevious.layer.borderColor = UIColor.accentColor.cgColor
        btnPrevious.layer.borderWidth = 1
        setupCollectionView()
        if let user = DataService.getUserData() , let userinfo = user.reseller{
            viewSenderName.txt.text = userinfo.FullName
        }
    }
    
    func openDropDownList(type: Int){
        var arr = type == 0 ? countries.map{$0.getCurrentName()} : accounts.map{$0.getCurrentName()}
        if (type != 0){
            arr.append(btrrStrings.btrr_other.localizedValue)
        }
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        let sourceView = type == 0 ? viewBankCountry.lbl! : viewBankName.lbl!
        popOver.arr = arr
        popOver.preferredContentSize = CGSize(width: sourceView.bounds.width, height: height * CGFloat(arr.count))
        popOver.type = type;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = sourceView
        popoverMenuViewController?.sourceRect = CGRect(x: sourceView.bounds.width / 2,y:  sourceView.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    
    func setupSelectedCountry() {
        viewBankCountry.lbl.text = selecetedCountry?.getCurrentName() ?? ""
        selectedBankAccount = nil
        txtOther.text = ""
        stackOther.isHidden = true
        viewBankName.lbl.text = btrrStrings.btrr_select_sender_bank.localizedValue
    }
    
    func selectCountry(){
        if (countries.isNotEmpty){
            openDropDownList(type: 0)
        }else{
            loadCountries()
        }
    }
    
    func selectBankAccount(){
        if (accounts.isNotEmpty){
            openDropDownList(type: 1)
        }else{
            loadBankAccounts()
        }
    }
    
    func clearSavedAccountData(){
        steupSavedAccount = true
        self.selectedSavedAccount = nil
        viewAccountNo.txt.text = ""
        stackSavedAccount.isHidden = true
        viewSenderName.txt.text = "\(DataService.getUserData()?.reseller?.FullName ?? "")"
        self.selecetedCountry = self.countries.first{$0.id == delfaultCountryId}
        setupSelectedCountry()
        loadBankAccounts()
    }
    
    func setupSelectedSavedAccount(){
        steupSavedAccount = true
        if let account = selectedSavedAccount{
            if (selecetedCountry?.id != account.getIntCountryId()){
                self.selecetedCountry = self.countries.first{ $0.id == account.getIntCountryId()}
                setupSelectedCountry()
                loadBankAccounts()
            }else{
                setupSelectedBankAccount(account)
                steupSavedAccount = false
            }
            viewAccountNo.txt.text = account.bankAccountNumber
            viewSenderName.txt.text = account.getSenderName()
        }else{
            setupSelectedBankAccount(selectedSavedAccount)
            viewAccountNo.txt.text = ""
            viewSenderName.txt.text = "\(DataService.getUserData()?.reseller?.FullName ?? "")"
            steupSavedAccount = false
        }
    }
    
    func setupSelectedBankAccount(_ savedAccount: SavedAccount?){
        if let account = savedAccount{
            if let id = account.getIntBankId(){
                if selectedBankAccount?.id != id {
                    self.selectedBankAccount = self.accounts.first{$0.id == id}
                    viewBankName.isHidden = false
                    viewBankName.lbl.text = self.selectedBankAccount?.getCurrentName() ?? ""
                    stackOther.isHidden = true
                    txtOther.text = ""
                }
            }else{
                txtOther.text = account.getBankName()
                if (accounts.count > 0){
                    viewBankName.isHidden = false
                    viewBankName.lbl.text = btrrStrings.btrr_other.localizedValue
                }else{
                    viewBankName.isHidden = true
                    viewBankName.lbl.text = btrrStrings.btrr_select_sender_bank.localizedValue
                }
                self.selectedBankAccount = nil
                stackOther.isHidden = false
            }
        }else{
            viewBankName.lbl.text = btrrStrings.btrr_select_sender_bank.localizedValue
            self.selectedBankAccount = nil
            if (accounts.count > 0){
                viewBankName.isHidden = false
                stackOther.isHidden = true
            }else{
                viewBankName.isHidden = true
                stackOther.isHidden = false
            }
        }
    }
    
    func resetAccountData(){
        if savedAccounts.isNotEmpty {
            selectedSavedAccount = savedAccounts.first(where: {$0.isSelected()})
            self.collectionView.reloadData()
            stackSavedAccount.isHidden = false
            lblOtherError.isHidden = true
            viewAccountNo.lblError.isHidden = true
            viewSenderName.lblError.isHidden = true
            setupSelectedSavedAccount()
        }
    }
    
    
    private func checkIfChangesMade(account: SavedAccount)-> Bool {
        if (account.getIntCountryId() != selecetedCountry?.id) {
            return true
        }
        if (selectedBankAccount != nil && selectedBankAccount?.id != account.getIntBankId()) {
            return true
        }
        if (selectedBankAccount == nil && account.resellerBankName != txtOther.text) {
            return true
        }
        if (account.bankAccountNumber != viewAccountNo.txt.text) {
            return true
        }
        if (account.getSenderName() != viewSenderName.txt.text) {
            return true
        }
        return false
    }
    
    private func checkIfAlreadySaved()-> Bool {
        for account in savedAccounts {
            if (account.bankAccountNumber == viewAccountNo.txt.text){
                if (selectedBankAccount != nil && selectedBankAccount?.id == account.getIntBankId()) {
                    return true
                }else if (selectedBankAccount == nil && account.fromBankId == txtOther.text){
                    return true
                }
            }
        }
        return false
    }
}

extension BankTransferStep2VC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "SavedAccountsCell", bundle: nil), forCellWithReuseIdentifier: "SavedAccountsCell")
        centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.normal
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: (collectionView.frame.width * 2) / 3, height: 180)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView!.collectionViewLayout = centeredCollectionViewFlowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)->Int {
        return savedAccounts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)->UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedAccountsCell", for: indexPath) as? SavedAccountsCell{
            cell.setupData(savedAccounts[indexPath.row])
            cell.delegate = self
            cell.btnDelete.tag = indexPath.row
            return cell;
        }
        return UICollectionViewCell();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkSaved()
        selectedSavedAccount = savedAccounts[indexPath.row]
        self.savedAccounts.indices.forEach{self.savedAccounts[$0].selected = $0 == indexPath.row}
        self.collectionView.reloadData()
        lblOtherError.isHidden = true
        viewAccountNo.lblError.isHidden = true
        viewSenderName.lblError.isHidden = true
        setupSelectedSavedAccount()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        indicator.currentPage = centeredCollectionViewFlowLayout.currentCenteredPage ?? 0
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        indicator.currentPage = centeredCollectionViewFlowLayout.currentCenteredPage ?? 0
    }
}

extension BankTransferStep2VC: SavedAccountsCellDelegate{
    func onDeleteClicked(index: Int) {
        DataService.ds.showDetailedAlert(self, btrrStrings.btrr_confirm_delete.localizedValue, btn1Txt: msgs.confirm.localizedValue, btn2Txt: msgs.cancel.localizedValue, type: .warning) {
            self.delegate.startLoading(msg: msgs.deleting.localizedValue)
            BankTransferAPIs.deleteSavedAccount(savedAccount: self.savedAccounts[index],index, self)
        } btn2Handler: {
            
        }
    }
}

extension BankTransferStep2VC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (txtOther.tag == textField.tag){
            viewAccountNo.txt.becomeFirstResponder()
        }else if (viewAccountNo.txt.tag == textField.tag){
            viewSenderName.txt.becomeFirstResponder()
        }else{
            view.resignFirstResponder()
            view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        if (textField.tag == viewAccountNo.txt.tag){
            viewAccountNo.lblError.isHidden = true
        }else if (textField.tag == viewSenderName.txt.tag){
            viewSenderName.lblError.isHidden = true
        }else if (textField.tag == txtOther.tag){
            lblOtherError.isHidden = true
        }
        return count <= 250
    }
}

extension BankTransferStep2VC: OnFinishDelegate{
    func loadSavedAccounts(){
        delegate.startLoading()
        BankTransferAPIs.getSavedAccount(self)
    }
    
    func loadCountries(){
        delegate.startLoading()
        BankTransferAPIs.getSenderCountries(self)
    }
    
    func loadBankAccounts(){
        guard let selecetedCountry = selecetedCountry else {return}
        delegate.startLoading()
        BankTransferAPIs.getSenderAccountsByCountry(countryId: selecetedCountry.id, self)
    }
    
    func onSuccess(_ savedAccount: SavedAccountsList) {
        if let list = savedAccount.savedAccounts{
            savedAccounts = list;
            let index = savedAccounts.firstIndex(where: {$0.isSelected()}) ?? savedAccounts.count - 1
            if (savedAccounts.isNotEmpty){
                indicator.numberOfPages = savedAccounts.count
                stackSavedAccount.isHidden = false
                if (index >= 0){
                    self.savedAccounts[index].selected = true
                }
                collectionView.reloadData();
                if index >= 0 {
                    selectedSavedAccount = savedAccounts[index]
                    self.view.layoutIfNeeded()
                    let rect = self.collectionView.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
                    self.collectionView.scrollRectToVisible(rect!, animated: true)
                    self.indicator.currentPage = index
                }
            }
        }
        loadCountries();
    }
    
    func onSuccess(_ countries: Countries, _ tag: Int) {
        if (tag == 0){
            delfaultCountryId = countries.selectedId
            if let list = countries.lookupList{
                self.countries = list
                if let id = selectedSavedAccount?.getIntCountryId(){
                    self.selecetedCountry = self.countries.first{$0.id == id}
                }else{
                    self.selecetedCountry = self.countries.first{$0.id == countries.selectedId}
                }
            }
            setupSelectedCountry()
            if let _ = self.selecetedCountry?.id{
                loadBankAccounts()
            }else{
                delegate.stopLoading()
            }
        }else{
            delegate.stopLoading()
            if let list = countries.lookupList{
                self.accounts = list
                stackOther.isHidden = true
                viewBankName.isHidden = false
            }else{
                self.accounts = []
                viewBankName.isHidden = true
                stackOther.isHidden = false
            }
            if steupSavedAccount{
                self.setupSelectedSavedAccount()
            }
        }
    }
    
    func onSuccess(tag: Int) {
        delegate.stopLoading()
        let reset = self.savedAccounts[tag].isSelected()
        self.savedAccounts.remove(at: tag)
        if reset {
            if self.savedAccounts.count <= 0 {
                self.stackSavedAccount.isHidden = true
                self.clearSavedAccountData()
            }else{
                selectedSavedAccount = self.savedAccounts.last
                self.savedAccounts[savedAccounts.count - 1].selected = true
                setupSelectedSavedAccount()
            }
        }
        indicator.numberOfPages = savedAccounts.count
        collectionView.reloadData()
    }
    
    func onFailed(err: ServiceError, _ tag: Int) {
        switch (err) {
        case .unauthorized:
            delegate.stopLoading()
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        default:
            DataService.ds.showAlert(self, err.errorDescription)
            if (tag == 0){
                loadCountries();
            }else if (tag == 3){
                var msg = errorMsgs.server.localizedValue
                if (err.code == BankTransferError.BANK_ACCOUNT_NOT_FOUND.rawValue){
                    msg = errorMsgs.bank_account_not_found.localizedValue
                }
                DataService.ds.showAlert(self, msg)
            }else{
                delegate.stopLoading()
            }
        }
    }
}
extension BankTransferStep2VC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension BankTransferStep2VC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1){
            if (type == 0){
                if self.countries.count > position{
                    selecetedCountry = self.countries[position]
                    setupSelectedCountry()
                    loadBankAccounts()
                }
            }else {
                if self.accounts.count > position{
                    lblOtherError.isHidden = true
                    self.selectedBankAccount = self.accounts[position]
                    viewBankName.lbl.text = self.accounts[position].getCurrentName()
                    stackOther.isHidden = true
                    txtOther.text = ""
                }else if self.accounts.count == position{
                    txtOther.text = ""
                    viewBankName.lbl.text = btrrStrings.btrr_other.localizedValue
                    self.selectedBankAccount = nil
                    stackOther.isHidden = false
                }
            }
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
    }
}
extension BankTransferStep2VC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

