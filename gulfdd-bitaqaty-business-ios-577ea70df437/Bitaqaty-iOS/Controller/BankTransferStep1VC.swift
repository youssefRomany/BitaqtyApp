//
//  BankTransferStep1VC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit
import XLPagerTabStrip

class BankTransferStep1VC: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    weak var delegate: BankTransferDelegate!
    @IBOutlet weak var viewCounrtySelector: UIView!
    @IBOutlet weak var lblCountry: LblSmallRegularFont!
    @IBOutlet weak var btnCountry: BtnSmallerLightFont!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: ErrorView!
    var accounts: [Account] = []
    var countries: [Country] = []
    var selectedCountry: Country? = nil
    var selectedAccount: Account? = nil
    
    var viewModel: BankTransferViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCountries()
        errorView.delegate = self
    }
    
    func loadCountries(){
        delegate.startLoading()
        BankTransferAPIs.getOneCardCountries(self)
    }
    
    
    @IBAction func selectCountry(_ sender: UIButton) {
        if (countries.isEmpty){
            loadCountries()
        }else{
            openCountriesPopOver()
        }
    }
}

extension BankTransferStep1VC{
    func setupUI(){
        viewCounrtySelector.layer.borderWidth = 1
        viewCounrtySelector.layer.borderColor = UIColor.lightBorderColor.cgColor
        viewCounrtySelector.layer.cornerRadius = 4
        viewCounrtySelector.clipsToBounds = true
        
        lblCountry.layer.borderWidth = 1
        lblCountry.layer.borderColor = UIColor.lightBorderColor.cgColor
        lblCountry.text = btrrStrings.btrr_countries.localizedValue
        setupCollectionView()
    }
    
    func openCountriesPopOver(){
        let arr = countries.map{$0.getCurrentName()}
        let popOver  = PopOverVC(nibName: "PopOverVC", bundle: nil);
        let height: CGFloat = UIDevice.isPad ? 50 : 40;
        popOver.arr = arr
        popOver.preferredContentSize = CGSize(width: btnCountry.bounds.width, height: height * CGFloat(arr.count))
        popOver.type = 0;
        popOver.delegate = self;
        popOver.modalPresentationStyle = .popover;
        let popoverMenuViewController = popOver.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .up
        popoverMenuViewController?.delegate = self;
        popoverMenuViewController?.sourceView = btnCountry
        popoverMenuViewController?.sourceRect = CGRect(x: btnCountry.bounds.width / 2,y:  btnCountry.bounds.height,width: 1,height: 1);
        DispatchQueue.main.async {
            self.present(popOver,animated: true,completion: nil);
        }
    }
    
    func setSelectedCountry(){
        btnCountry.setTitle(self.selectedCountry?.getCurrentName(), for: .normal)
        delegate.startLoading()
        BankTransferAPIs.getOneCardAccounts(countryId: self.selectedCountry!.id, self)
    }
}

extension BankTransferStep1VC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "OneCardBankAccountCell", bundle: nil), forCellWithReuseIdentifier: "OneCardBankAccountCell")
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)->Int {
        return accounts.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)->UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCardBankAccountCell", for: indexPath) as? OneCardBankAccountCell{
            cell.setupData(accounts[indexPath.row])
            return cell;
        }
        return UICollectionViewCell();
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.oneCardAccount = accounts[indexPath.row]
        viewModel?.oneCardCountry = selectedCountry
        delegate.next()
    }
}

extension BankTransferStep1VC: OnFinishDelegate{
    func onSuccess(_ countries: Countries) {
        print("\(countries)")
        if let list = countries.lookupList{
            if list.isNotEmpty{
                if selectedCountry == nil, let index = self.countries.firstIndex(where: {$0.id == countries.selectedId}){
                    self.selectedCountry = self.countries[index]
                }
                if (selectedCountry == nil){
                    selectedCountry = list[0]
                }
                setSelectedCountry()
            }else{
                errorView.showNoData()
            }
        }else{
            DataService.ds.showAlert(self, errorMsgs.server.localizedValue)
        }
        
    }
    
    func onSuccess(_ account: OneCardAccount) {
        delegate.stopLoading()
        if let accountList = account.accounts{
            accounts = accountList
            collectionView.reloadData()
        }else{
            DataService.ds.showAlert(self, errorMsgs.server.localizedValue)
        }
    }
    
    func onFailed(err: ServiceError, _ tag: Int) {
        delegate.stopLoading()
        switch (err) {
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        default:
            errorView.showException(error: ErrorMessage(err.errorDescription, err.code))
        }
    }
}

extension BankTransferStep1VC: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension BankTransferStep1VC: PopOverDelegate{
    func getPosition(_ type: Int, _ position: Int, _ popType: Int) {
        if (position != -1 && countries.count > position){
            self.selectedCountry = countries[position]
            setSelectedCountry()
        }
    }
    
    func getDate(_ type: Int,_ date: Date) {
    }
}

extension BankTransferStep1VC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension BankTransferStep1VC: ReloadDataDelegate{
    func reloadData() {
        if (selectedCountry == nil){
            loadCountries()
        }else{
            delegate.startLoading()
            BankTransferAPIs.getOneCardAccounts(countryId: self.selectedCountry!.id, self)
        }
    }
}
