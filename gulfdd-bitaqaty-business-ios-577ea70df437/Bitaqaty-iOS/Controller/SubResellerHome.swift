//
//  SubResellerHome.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 06/10/2021.
//
import Foundation
import XLPagerTabStrip
import UIKit

class SubResellerHome: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    @IBOutlet weak var stackPermission: UIStackView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewTransActionLog: UIView!
    @IBOutlet weak var lblTranactions: LblLargeBoldFont!
    @IBOutlet weak var stackTransaction: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var lblViewAll: LblSmallerLightFont!
    @IBOutlet weak var imgViewAll: UIImageView!
    @IBOutlet weak var viewEmptyTransaction: UIView!
    @IBOutlet weak var lblNoData: LblSmallBoldFont!
    @IBOutlet weak var viewError: ErrorView!
    @IBOutlet weak var collectionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    var topMerchants: [TopMerchant] = []
    var logs: [TransactionLog] = []
    let noOfCellsInRow: CGFloat = UIDevice.isPad ? 4 : 3;
    let collectionCellHeight: CGFloat = UIDevice.isPad ? 150 : 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        print("dwehdjwedhwejdhwjedjewdw")
    }
    
    @IBAction func viewAll(_ sender: Any) {
        let vc = TransactionsLogVC(nibName: "TransactionsLogVC", bundle: nil)
        vc.isMenu = true
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

extension SubResellerHome{
    func setupUI(){
        lblTranactions.textAlignment = lang == "en" ? .left : .right
        lblNoData.text = btrrStrings.btrr_no_data.localizedValue
        viewTransActionLog.round(to: UIDevice.isPad ? 10 : 8)
        viewAll.round(to: UIDevice.isPad ? 4 : 2)
        lblTranactions.text = HomeStrings.tranaction_log.localizedValue
        lblViewAll.text = HomeStrings.view_all.localizedValue
        viewTransActionLog.isHidden = true
        if (lang != "en"){
            imgViewAll.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        setupCollectionView()
        setupTableView()
        if (DataService.cantPurchase()){
            stackPermission.isHidden = true
            scv.isHidden = false
        }else{
            scv.isHidden = true
            stackPermission.isHidden = false
            lblWelcome.text = HomeStrings.welcome.localizedValue
        }
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MerchantCell", bundle: nil), forCellWithReuseIdentifier: "MerchantCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = (UIScreen.main.bounds.size.width * 0.9) / noOfCellsInRow;
        layout.itemSize = CGSize(width: CGFloat(width - 5), height: collectionCellHeight);
        layout.scrollDirection = .vertical;
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 10;
        collectionView!.collectionViewLayout = layout
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: SubSellerTransactionLogCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension SubResellerHome: ReloadDataDelegate{
    func reloadData() {
        loadData()
    }
    
    func loadData(){
        viewError.startLoading()
        SubResellerHomeAPIs.loadTopMerchants(self)
    }
}

extension SubResellerHome: OnFinishDelegate{
    func onSuccess(_ merchants: [TopMerchant]) {
        if (merchants.isNotEmpty){
            topMerchants = merchants
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            let collectionHeight = (CGFloat(topMerchants.count) / noOfCellsInRow) * collectionCellHeight
            if (collectionView.contentSize.height >= collectionHeight){
                collectionViewHeightConst.constant = collectionView.contentSize.height
            }else{
                collectionViewHeightConst.constant = collectionHeight
            }
            if (DataService.showTransactionLog()){
                SubResellerHomeAPIs.getTransactionLog(self)
            }else{
                viewTransActionLog.isHidden = true
                viewError.stopLoading()
            }
        }else{
            viewError.showNoData()
        }
    }
    
    func onSuccess(_ transactionLogs: [TransactionLog]) {
        viewTransActionLog.isHidden = false
        if (transactionLogs.isNotEmpty){
            logs = transactionLogs
            tableView.reloadData()
            tableView.layoutIfNeeded()
            var height: CGFloat = lang == "en" ? 110 : 100
            if (UIDevice.isPad){
                height = lang == "en" ? 120 : 110
            }
            if (DataService.showCost()){
                if (UIDevice.isPad){
                    height += 25
                }else{
                    height += 15
                }
            }
            if (DataService.showSupport()){
                if (UIDevice.isPad){
                    height += lang == "en" ? 55 : 50
                }else{
                    height += 45
                }
            }
            tableViewHeightConst.constant = CGFloat(transactionLogs.count) * height; //tableView.contentSize.height
            stackTransaction.isHidden = false
            viewEmptyTransaction.isHidden = true
        }else{
            stackTransaction.isHidden = true
            viewEmptyTransaction.isHidden = false
        }
        viewError.stopLoading()
    }
    
    func onFailed(err: ServiceError, _ tag: Int) {
        viewError.stopLoading()
        switch err{
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        case .noInternetConnection:
            viewError.showInternetOff()
        default:
            if (tag == 0){
                viewError.showException(error: ErrorMessage(err.errorDescription))
            }
        }
    }
}

extension SubResellerHome: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topMerchants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantCell", for: indexPath) as? MerchantCell{
            cell.lblTitle.text = topMerchants[indexPath.row].getName()
            if let logo = topMerchants[indexPath.row].logoPath{
                DataService.ds.downloadImageWithoutExtension(urlStr: logo, imageView: cell.img)
            }else{
                cell.img.image = UIImage(named: "nerd")
            }
            return cell
        }
        return MerchantCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let merchant = topMerchants[indexPath.row]
        if (merchant.category == true){
            let vc = MerchantsVC(nibName: "MerchantsVC", bundle: nil)
            vc.isTopMerchant = true
            vc.modalPresentationStyle = .fullScreen
            vc.category = Category(merchant)
            present(vc, animated: true, completion: nil)
        }else{
            let vc = ProductsVC(nibName: "ProductsVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.categoryId = merchant.categoryId
            vc.merchant = Merchant(merchant)
            present(vc, animated: true, completion: nil)
        }
    }
}

extension SubResellerHome: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubSellerTransactionLogCell", for: indexPath) as? SubSellerTransactionLogCell{
            cell.setData(logs[indexPath.row])
            cell.openTicket = { [weak self] in
                let vc = SupportCenterVC(nibName: "SupportCenterVC", bundle: nil)
                vc.isMenu = true
                vc.transactionLog = self?.logs[indexPath.row]
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true, completion: nil)
            }
            return cell
        }
        return SubSellerTransactionLogCell()
    }
}
extension SubResellerHome: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
