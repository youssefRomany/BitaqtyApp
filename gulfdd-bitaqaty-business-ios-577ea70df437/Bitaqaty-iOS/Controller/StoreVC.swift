//
//  StoreVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/4/21.
//

import UIKit

import XLPagerTabStrip

class StoreVC: UIViewController {
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: LblMediumBoldFont!
    
    var stores = [Category]()
    
    var itemInfo: IndicatorInfo = "View";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        errorView.delegate = self
        lblTitle.text = purchaseStrings.shopping_categories.localizedValue
        loadData()
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "")
            refreshControl.addTarget(self,
                                     action: #selector(refreshOptions(sender:)),
                                     for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }
    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        self.loadData()
        sender.endRefreshing()
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: StoreCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
    }
    
    func loadData(){
        errorView.startLoading()
        PurchaseAPIs.loadStores(self)
    }
    
}
extension StoreVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension StoreVC: OnFinishDelegate{
    func onSuccess(_ categories: [Category]) {
        self.errorView.stopLoading()
        self.stores = categories
        self.tableView.reloadData()
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

extension StoreVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as? StoreCell{
            cell.lblTitle.text = stores[indexPath.row].name
            return cell
        }
        return StoreCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MerchantsVC(nibName: "MerchantsVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.category = stores[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}
extension StoreVC: ReloadDataDelegate{
    func reloadData(){
        loadData()
    }
}
