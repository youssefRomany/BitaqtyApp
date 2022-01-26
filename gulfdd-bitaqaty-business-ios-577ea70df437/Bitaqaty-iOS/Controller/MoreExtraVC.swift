//
//  MoreExtraVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 7/7/21.
//

import Foundation
import UIKit

class MoreExtraVC: UIViewController {
    var type: Int = 1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: MoreExtraHeaderView!
    var titleArr: [(String,Bool)] = []
    var bodyArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI(){
        headerView.setData(type) {
            self.dismiss(animated: true, completion: nil)
        }
        setupData()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: MoreExtraOverViewCell.self);
        tableView.registerCellNib(cellClass: MoreExtraCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MoreExtraVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type == 1 ? titleArr.count : titleArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && type != 1{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MoreExtraOverViewCell", for: indexPath) as? MoreExtraOverViewCell{
                cell.lbl.text = type == 2 ? accountStrings.more_terms_of_use_overview.localizedValue : accountStrings.more_privacy_policy_overview.localizedValue
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MoreExtraCell", for: indexPath) as? MoreExtraCell{
                var row  = indexPath.row - 1
                if (type == 1){
                    row = indexPath.row
                }
                cell.lblTitle.text = titleArr[row].0
                cell.lblBody.text = bodyArr[row]
                cell.backgroundColor = .bgColor
                if titleArr[row ].1{
                    cell.lblArrow.text = icons.ic_arrow_down.localizedValue
                    cell.viewBody.isHidden = false
                }else{
                    cell.lblArrow.text = icons.ic_arrow_r.localizedValue
                    cell.viewBody.isHidden = true
                }
                return cell
            }
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
        var row  = indexPath.row - 1
        if (type == 1){
            row = indexPath.row
        }
        if let cell = tableView.cellForRow(at: indexPath) as? MoreExtraCell{
            tableView.beginUpdates()
            titleArr[row ].1 = !titleArr[row ].1
            if titleArr[row ].1{
                cell.lblArrow.text = icons.ic_arrow_down.localizedValue
                cell.viewBody.isHidden = false
            }else{
                cell.lblArrow.text = icons.ic_arrow_r.localizedValue
                cell.viewBody.isHidden = true
            }
            tableView.endUpdates()
        }
    }
}
extension MoreExtraVC{
    func setupData(){
        if type == 1 {
            titleArr = [
                (more_extra_msgs.faq_header_1.localizedValue,false),
                (more_extra_msgs.faq_header_2.localizedValue,false),
                (more_extra_msgs.faq_header_3.localizedValue,false),
                (more_extra_msgs.faq_header_4.localizedValue,false),
                (more_extra_msgs.faq_header_5.localizedValue,false),
                (more_extra_msgs.faq_header_6.localizedValue,false),
                (more_extra_msgs.faq_header_7.localizedValue,false),
                (more_extra_msgs.faq_header_8.localizedValue,false),
                (more_extra_msgs.faq_header_9.localizedValue,false),
                (more_extra_msgs.faq_header_10.localizedValue,false),
                (more_extra_msgs.faq_header_11.localizedValue,false),
                (more_extra_msgs.faq_header_12.localizedValue,false)
            ]
            bodyArr = [
                more_extra_msgs.faq_body_1.localizedValue,
                more_extra_msgs.faq_body_2.localizedValue,
                more_extra_msgs.faq_body_3.localizedValue,
                more_extra_msgs.faq_body_4.localizedValue,
                more_extra_msgs.faq_body_5.localizedValue,
                more_extra_msgs.faq_body_6.localizedValue,
                more_extra_msgs.faq_body_7.localizedValue,
                more_extra_msgs.faq_body_8.localizedValue,
                more_extra_msgs.faq_body_9.localizedValue,
                more_extra_msgs.faq_body_10.localizedValue,
                more_extra_msgs.faq_body_11.localizedValue,
                more_extra_msgs.faq_body_12.localizedValue
            ]
        }else if (type == 2){
            titleArr = [
                (more_extra_msgs.term_header_1.localizedValue,false),
                (more_extra_msgs.term_header_2.localizedValue,false),
                (more_extra_msgs.term_header_3.localizedValue,false),
                (more_extra_msgs.term_header_4.localizedValue,false),
                (more_extra_msgs.term_header_5.localizedValue,false),
                (more_extra_msgs.term_header_6.localizedValue,false)
            ]
            bodyArr = [
                more_extra_msgs.term_body_1.localizedValue,
                more_extra_msgs.term_body_2.localizedValue,
                more_extra_msgs.term_body_3.localizedValue,
                more_extra_msgs.term_body_4.localizedValue,
                more_extra_msgs.term_body_5.localizedValue,
                more_extra_msgs.term_body_6.localizedValue
            ]
        }else if (type == 3){
            titleArr = [
                (more_extra_msgs.policy_header_1.localizedValue,false),
                (more_extra_msgs.policy_header_2.localizedValue,false),
                (more_extra_msgs.policy_header_3.localizedValue,false)
            ]
            bodyArr = [
                more_extra_msgs.policy_body_1.localizedValue,
                more_extra_msgs.policy_body_2.localizedValue,
                more_extra_msgs.policy_body_3.localizedValue
            ]
        }
    }
}
