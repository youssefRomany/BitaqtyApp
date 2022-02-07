//
//  ProductsVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 9/16/21.
//

import UIKit

class ProductsVC: UIViewController {
    
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var viewHeader: PurchaseHeaderView!
    @IBOutlet weak var stackDescription: UIStackView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var viewHowToUse: UIView!
    @IBOutlet weak var lblHowToUse: LblMediumRegularFont!
    @IBOutlet weak var viewHowToUseValue: UIView!
    @IBOutlet weak var lblHowToUseValue: UILabel!
    @IBOutlet weak var imgHowToUseArr: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var constHeight: NSLayoutConstraint!
    
    
    var categoryId: Int? = nil
    var merchant: Merchant? = nil
    var products = [Product]()
    let radius: CGFloat = UIDevice.isPad ? 6 : 4
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    func setupUI(){
        errorView.delegate = self
        setupTableView()
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "")
            refreshControl.addTarget(self,
                                     action: #selector(refreshOptions(sender:)),
                                     for: .valueChanged)
            scv.refreshControl = refreshControl
        }
        viewHowToUse.setupWithRoundNoShadow(radius)
        if let desc = merchant?.description, desc.isNotEmpty{
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
            stackDescription.isHidden = true
        }
        if var htu = merchant?.howToUse, htu.isNotEmpty{
            if (htu.contains("<ul>")){
                htu = htu.replacingOccurrences(of: "\n", with: "")
            }else{
                htu = htu.replacingOccurrences(of: "\n", with: "<br>")
            }
            lblHowToUse.textAlignment = lang == "en" ? .left : .right
            lblHowToUseValue.textAlignment = lang == "en" ? .left : .right
            lblHowToUse.text = purchaseStrings.how_to_use.localizedValue
            lblHowToUseValue.attributedText = htu.htmlToAttributedString
        }else{
            viewHowToUse.isHidden = true
        }
        btnSeeMore.setTitle(purchaseStrings.seeMore.localizedValue, for: .normal)
        viewHeader.setup(merchant?.name ?? "", merchant?.logoPath) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: ProductSearchCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
    }
    
    func loadData(){
        errorView.startLoading()
        PurchaseAPIs.loadProduct(categoryId: categoryId ?? 0, merchantId: merchant?.id ?? 0, self)
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        self.loadData()
        sender.endRefreshing()
    }
    
    @IBAction func seeMore(_ sender: UIButton) {
        lblDescription.numberOfLines = 0
        btnSeeMore.isHidden = true
    }
    
    @IBAction func toggelHowToUse(_ sender: Any) {
        if (viewHowToUseValue.tag == 0){
            viewHowToUseValue.tag = 1
            imgHowToUseArr.transform = CGAffineTransform(scaleX: 1, y: -1)
            viewHowToUseValue.isHidden = false
        }else{
            viewHowToUseValue.tag = 0
            imgHowToUseArr.transform = CGAffineTransform(scaleX: 1, y: 1)
            viewHowToUseValue.isHidden = true
        }
    }
    
}


extension ProductsVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchCell", for: indexPath) as? ProductSearchCell{
            cell.delegate = self
            cell.tag = indexPath.row
            cell.setData(product: products[indexPath.row])
            return cell
        }
        return ProductSearchCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if products[indexPath.row].isInStock {
            let vc = PurchaseVC(nibName: "PurchaseVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.product = products[indexPath.row]
            present(vc, animated: true, completion: nil)
        }
    }
}


extension ProductsVC: OnFinishDelegate{
    func onSuccess(_ products: [Product]) {
        self.errorView.stopLoading()
        self.products = products
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.constHeight.constant = self.tableView.contentSize.height
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
            errorView.showException(error: ErrorMessage(err.errorDescription))
        }
    }
}
extension ProductsVC: OnBuyDelegate{
    func onBuy(Index: Int){
        let vc = PurchaseVC(nibName: "PurchaseVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.product = products[Index]
        present(vc, animated: true, completion: nil)
    }
}

extension ProductsVC: ReloadDataDelegate{
    func reloadData(){
        loadData()
    }
}

