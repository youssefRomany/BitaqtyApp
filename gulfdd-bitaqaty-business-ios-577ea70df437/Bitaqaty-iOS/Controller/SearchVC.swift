//
//  SearchVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/5/21.
//

import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var loaderView: ErrorView!
    
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSearchResult: UILabel!
    @IBOutlet weak var lblSearchText: UILabel!
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var arrProduct = [Product]()
    private var searchText = ""
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
    var searchStart = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .bgColor
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.bgColor
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.setStatusBar(color: .white)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
    }
    func setupSearchBar(){
        if SETTINGS.count > 0{
            let data = SETTINGS.first{$0.propertyKey == SETTING_KEYS.SEARCH_SUBACCOUNT_KEYWORD_MIN_LENGTH.rawValue}
            if data != nil{
                let value = data!.PropertyValue
                searchStart = Int(value) ?? 3
            }
        }
        
        navigationItem.titleView = searchBar
        self.searchBar.setImage(UIImage(), for: .search, state: .normal)
        let font = UIFont(name: FONT_ICON, size: FONT_SMALLER)

        let attributedPlaceholder = NSAttributedString(string: productListStrings.productSearchHint.localizedValue,
                                                       attributes: [NSAttributedString.Key.font: UIFont.regularSmall, NSAttributedString.Key.foregroundColor : UIColor.shadow])
       
        
        let iconFont = NSAttributedString(string: " \u{f002} " ,
                                          attributes: [NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor : UIColor.shadow])

        let combination = NSMutableAttributedString()
        if lang == "ar"{
            combination.append(iconFont)
            combination.append(attributedPlaceholder)
        }else{
            combination.append(attributedPlaceholder)
            combination.append(iconFont)
        }

        if #available(iOS 13.0, *) {
              searchBar.searchTextField.attributedPlaceholder = combination
          } else {
              let searchField = searchBar.value(forKey: "searchField") as! UITextField
              searchField.attributedPlaceholder = combination
          }
        //searchBar.setFont()
        searchBar.delegate = self
        searchBar.searchTextField.layer.cornerRadius = 0
        searchBar.searchTextField.layer.masksToBounds = false
        searchBar.searchTextField.borderStyle = .line
        searchBar.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.backgroundColor = .white
        searchBar.setCenteredPlaceHolder()
        if let clearButton = searchBar.searchTextField.value(forKey: "clearButton") as? UIButton {
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .lightGray
        }
        
        
    }
    func setupUI(){
        setupTableView()
        self.lblFirst.text = productListStrings.search_desc.localizedValue
        if lang == "en"{
            lblFirst.text = "Enter a few words to search on \(WhiteLabelLocal.shared.getLocalWhiteLabelList()?.nameEn ?? "")"
        }else{
            lblFirst.text = "ادخل بعض الكلمات للبحث في \(WhiteLabelLocal.shared.getLocalWhiteLabelList()?.nameAr ?? "")"

        }
        self.lblSearchResult.text = productListStrings.search_results_for.localizedValue
        self.viewFirst.isHidden = false
        self.viewResult.isHidden = true
        lblSearchResult.textAlignment = lang == "en" ? .left : .right
        lblSearchText.textAlignment = lang == "en" ? .left : .right
        
    }
}
extension SearchVC:  UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //textFieldInsideSearchBar?.textAlignment = lang == "en" ? .left : .right
        search(searchBar);
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true);
        search(searchBar);
    }
    
    fileprivate func clearSearchResult(_ searchBar: UISearchBar?) {
        self.view.endEditing(true);
        searchBar?.setCenteredPlaceHolder()
        self.searchText = ""
        self.arrProduct = []
        self.tableView.reloadData()
        self.viewFirst.isHidden = false
        self.viewResult.isHidden = true
    }
    
    func search(_ searchBar: UISearchBar){
        if(searchBar.text == nil || (searchBar.text?.isEmpty)!){
            clearSearchResult(searchBar)
        }else{
            let searchedText = searchBar.text?.lowercased();
            if(!(searchedText?.isEmpty)! && searchedText!.count >= searchStart){
                self.searchText = searchedText!
                self.getProductList()
            }
        }
    }
    func getProductList(){
        // self.loaderView.startLoading()
        self.lblSearchText.text = "(\(self.searchText))"
        ProductListAPIs.getProductList(pageNumber: -1, categoryId: -1, merchantId: -1, searchCriteria: self.searchText) { [weak self]  (result) in
            self?.loaderView.stopLoading()
            self?.lblSearchResult.text = productListStrings.search_results_for.localizedValue
            self?.arrProduct = result
            self?.tableView.reloadData()
            self?.viewResult.isHidden = false
            self?.viewFirst.isHidden = true
            if(self?.searchBar.text == nil || (self?.searchBar.text?.isEmpty)!){
                self?.clearSearchResult(self?.searchBar)
            }
        } _: { [weak self]  (err) in
            self?.loaderView.stopLoading()
            self?.arrProduct = []
            self?.tableView.reloadData()
            if err.errorCode == String(ErrorType.Auth.rawValue){
                if self != nil{
                    DataService.ds.showAlert(self!, err.errorMessage) {
                        DataService.deleteUserData()
                        DataService.loadHome()
                    }
                }
            }else{
                if err.errorCode == "\(ErrorType.Empty.rawValue)"{
                    self?.lblSearchResult.text = productListStrings.no_results_found.localizedValue
                    self?.viewResult.isHidden = false
                    self?.viewFirst.isHidden = true
                    if(self?.searchBar.text == nil || (self?.searchBar.text?.isEmpty)!){
                        self?.clearSearchResult(self?.searchBar)
                    }
                }else{
                    self?.loaderView.showException(error: err)
                }
            }
        }
    }
}
extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        tableView.registerCellNib(cellClass: ProductSearchCell.self);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 120;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrProduct.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchCell", for: indexPath) as? ProductSearchCell{
            let row = indexPath.row
            cell.delegate = self
            cell.setData(product: arrProduct[row])
            cell.tag = row
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrProduct[indexPath.row].isInStock {
            let vc = PurchaseVC(nibName: "PurchaseVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            vc.product = arrProduct[indexPath.row]
            present(vc, animated: true, completion: nil)
        }
    }
}
extension SearchVC: OnBuyDelegate{
    func onBuy(Index: Int){
        let vc = PurchaseVC(nibName: "PurchaseVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.product = arrProduct[Index]
        present(vc, animated: true, completion: nil)
    }
}
