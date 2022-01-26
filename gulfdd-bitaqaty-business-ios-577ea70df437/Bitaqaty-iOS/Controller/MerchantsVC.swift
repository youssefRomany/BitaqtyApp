//
//  MerchantsVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class MerchantsVC: UIViewController {
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var viewHeader: PurchaseHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    var category: Category? = nil
    var isTopMerchant = false
    var merchants = [Merchant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    func setupUI(){
        errorView.delegate = self
        setupCollectionView()
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "")
            refreshControl.addTarget(self,
                                     action: #selector(refreshOptions(sender:)),
                                     for: .valueChanged)
            scv.refreshControl = refreshControl
        }
        if let desc = category?.description{
            lblDescription.textAlignment = lang == "en" ? .left : .right
            if desc.count > 250 {
                lblDescription.numberOfLines = 4
                btnSeeMore.isHidden = false
            }else{
                lblDescription.numberOfLines = 0
                btnSeeMore.isHidden = true
            }
            lblDescription.attributedText = desc.htmlToAttributedString
        }else{
            lblDescription.isHidden = true
            btnSeeMore.isHidden = true
        }
        btnSeeMore.setTitle(purchaseStrings.seeMore.localizedValue, for: .normal)
        viewHeader.setup(category?.name ?? "", category?.LogoPath) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupCollectionView(){
        collectionView.register(UINib(nibName: "MerchantCell", bundle: nil), forCellWithReuseIdentifier: "MerchantCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let noOfCellsInRow = UIDevice.isPad ? 4 : 3;
        let width = (UIScreen.main.bounds.size.width * 0.9) / CGFloat(noOfCellsInRow);
        let height: CGFloat = UIDevice.isPad ? 150 : 120
        layout.itemSize = CGSize(width: CGFloat(width - 5), height: height);
        layout.scrollDirection = .vertical;
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 10;
        collectionView!.collectionViewLayout = layout
        
    }
    
    func loadData(){
        errorView.startLoading()
        if (isTopMerchant){
            SubResellerHomeAPIs.loadMerchants(categoryId: category?.id ?? 0, self)
        }else{
            PurchaseAPIs.loadMerchants(categoryId: category?.id ?? 0, self)
        }
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        self.loadData()
        sender.endRefreshing()
    }
    
    @IBAction func seeMore(_ sender: UIButton) {
        lblDescription.numberOfLines = 0
        btnSeeMore.isHidden = true
    }
    
}

extension MerchantsVC: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantCell", for: indexPath) as? MerchantCell{
            cell.lblTitle.text = merchants[indexPath.row].name
            if let logo = merchants[indexPath.row].logoPath{
                DataService.ds.downloadImageWithoutExtension(urlStr: logo, imageView: cell.img)
            }else{
                cell.img.image = UIImage(named: "nerd")
            }
            return cell
        }
        return MerchantCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = ProductsVC(nibName: "ProductsVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.categoryId = category?.id
        vc.merchant = merchants[index]
        present(vc, animated: true, completion: nil)
    }
}
extension MerchantsVC: OnFinishDelegate{
    func onSuccess(_ merchants: [Merchant]) {
        self.errorView.stopLoading()
        self.merchants = merchants
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.heightConst.constant = self.collectionView.contentSize.height
    }
    
    func onFailed(err: ServiceError) {
        self.errorView.stopLoading()
        switch err {
        case .noInternetConnection:
            errorView.showInternetOff()
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        default:
            errorView.showException(error: ErrorMessage(errorMsgs.server.localizedValue))
        }
    }
}
extension MerchantsVC: ReloadDataDelegate{
    func reloadData(){
        loadData()
    }
}

