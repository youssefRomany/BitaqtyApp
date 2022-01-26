//
//  LanguageVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/13/21.
//

import UIKit

class LanguageVC: UIViewController {

    @IBOutlet weak var lblTitle: LblMediumBoldFont!
    @IBOutlet weak var tableView: UITableView!
    
    var arr = [accountStrings.arabic.localizedValue,accountStrings.english.localizedValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = strings.choose_language.localizedValue
        setUpTableView()
    }
    
    func setUpTableView(){
        tableView.registerCellNib(cellClass: LanguageCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LanguageVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as? LanguageCell{
            let row = indexPath.row
            cell.lblTitle.text = arr[row]
            if ((row == 1 && lang == "en") || (row == 0 && lang != "en")){
                cell.selectCell()
            }else{
                cell.unselectCell()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if ((index == 1 && lang != "en") || (index == 0 && lang == "en")){
            if (lang == "en"){
                lang = "ar"
            }else{
                lang = "en"
            }
            Bundle.set(lang)
        }
    }
}
