//
//  DurationPopupVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 8/2/21.
//

import UIKit

class DurationPopupVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: DurationPopDelegate!
    
    var items: [String] = [SUB_DURATION_TYPE.DAILY.title, SUB_DURATION_TYPE.WEEKLY.title, SUB_DURATION_TYPE.MONTHLY.title];

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}
extension DurationPopupVC: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView();
//        tableView.estimatedRowHeight = 60;
//        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.removeSeparatorsOfEmptyCellsAndLastCell();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell"){
            cell.textLabel?.font = .regularSmall
            cell.textLabel?.textColor = .textColor
            cell.textLabel?.textAlignment = lang == "ar" ? .right : .left;
            cell.textLabel?.text = items[indexPath.row]
            cell.selectionStyle = .none
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil{
            delegate.onSelect(index: indexPath.row)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
