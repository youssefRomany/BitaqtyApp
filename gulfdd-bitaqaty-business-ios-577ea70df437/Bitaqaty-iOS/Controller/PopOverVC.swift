//
//  PopOverVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/29/21.
//

import UIKit

class PopOverVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arr = [String]();
    var arrMtehods = [RechargeMethod]();
    var arrCategories = [Category]();
    var arrServices = [Merchant]();
    var arrUsers = [TransactionUser]();
    
    weak var delegate: PopOverDelegate!;
    var type: Int = 0
    var popupType = POPUP_TYPE.RECHARGE_METHODS.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView();
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        if (delegate != nil){
            delegate.getPosition(type, -1, popupType)
        }
    }
    
    
    func setTableView(){
        tableView.registerCellNib(cellClass: SingleLblCell.self);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 50;
        tableView.rowHeight = 50;
        tableView.tableFooterView = UIView();
    }
    
}
extension PopOverVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLblCell") as? SingleLblCell{
            let row = indexPath.row
            if arr.count > 0{
                cell.lbl.text = arr[row];
            }else{
                if row == 0{
                    cell.lbl.text = btrrStrings.btrr_status_all.localizedValue
//                    if popupType == POPUP_TYPE.USERS.rawValue {
////                        if let user = DataService.getUserData(), user.accountType == Roles.SUB_ACCOUNT.rawValue{
////                            cell.lbl.text = arrUsers[row].UserName
////                        }else{
////                        }
//                    }else{
//                        cell.lbl.text = btrrStrings.btrr_status_all.localizedValue
//                    }
                }else{
                    if popupType == POPUP_TYPE.RECHARGE_METHODS.rawValue{
                        cell.lbl.text = arrMtehods[row - 1].Name
                    }else if popupType == POPUP_TYPE.CATEGORIES.rawValue{
                        cell.lbl.text = arrCategories[row - 1].name
                    }else if popupType == POPUP_TYPE.SERVICES.rawValue{
                        cell.lbl.text = arrServices[row - 1].name
                    }else if popupType == POPUP_TYPE.USERS.rawValue{
                        cell.lbl.text = arrUsers[row - 1].UserName
//
//                        if let user = DataService.getUserData(), user.accountType == Roles.SUB_ACCOUNT.rawValue{
//                            cell.lbl.text = arrUsers[row].UserName
//                        }else{
//                            cell.lbl.text = arrUsers[row - 1].UserName
//                        }
                    }
                }
            }
            return cell;
        }
        return SingleLblCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr.count > 0{
            return arr.count
        }else{
            if popupType == POPUP_TYPE.RECHARGE_METHODS.rawValue{
                return arrMtehods.count + 1
            }else if popupType == POPUP_TYPE.CATEGORIES.rawValue{
                return arrCategories.count + 1
            }else if popupType == POPUP_TYPE.SERVICES.rawValue{
                return arrServices.count + 1
            }else if popupType == POPUP_TYPE.USERS.rawValue{
                return arrUsers.count + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arr.count > 0 ? UITableView.automaticDimension : UIDevice.isPad ? 50 : 40;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (delegate != nil){
            delegate.getPosition(type, indexPath.row, popupType);
            dismiss(animated: true, completion: nil);
        }
    }
}
