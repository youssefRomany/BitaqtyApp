//
//  SupportCenterVC.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/25/21.
//

import Foundation
import XLPagerTabStrip
import UIKit

class SupportCenterVC: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    var isMenu = false;
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewHeader: CloseHeaderView!
    @IBOutlet weak var scv: UIScrollView!
    @IBOutlet weak var viewError: ErrorView!
    @IBOutlet weak var viewWhats: UIView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var viewHowToMakeTicket: UIView!
    @IBOutlet weak var viewHowToMakeTicketHeader: UIView!
    @IBOutlet weak var stackHowToMakeTicketBody: UIStackView!
    @IBOutlet weak var lblHowToMakeTicket: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var icHowTo1: UIView!
    @IBOutlet weak var lblHowTo1: UILabel!
    @IBOutlet weak var icHowTo2: UIView!
    @IBOutlet weak var lblHowTo2: UILabel!
    @IBOutlet weak var icHowTo3: UIView!
    @IBOutlet weak var lblHowTo3: UILabel!
    @IBOutlet weak var icHowTo4: UIView!
    @IBOutlet weak var lblHowTo4: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblWhatsNo: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblTalkTo: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var txtDetails: UITextView!
    @IBOutlet weak var lblDetailsError: LblSmallRegularFont!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblWhatsApp: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var constTableHeight: NSLayoutConstraint!
    
    var tickets = [Ticket]()
    var cellHeight: CGFloat = UIDevice.isPad ? 50 : 40
    var selectedIndex = 0
    
    var transactionLog: TransactionLog!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!isMenu){
            viewStatus.isHidden = true
            viewHeader.isHidden = true
        }else{
            viewHeader.showX(accountStrings.more_resellers_support_center.localizedValue) { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        setupUI()
        loadData()
        
        if(transactionLog != nil){
            var text = DateUtils.getLogDate(transactionLog.TransactionDate) + "\n"
            text = text + transactionLog.TransactionId + "\n"
            text = text + "\(transactionLog.Total) \(DataService.getCurrentCurency())"
            
            self.txtDetails.text = text
        }
    }
    
    @IBAction func expandCollaps(_ sender: Any) {
        animateDetails(viewHowToMakeTicketHeader.tag == 1)
        if (viewHowToMakeTicketHeader.tag == 0){
            viewHowToMakeTicketHeader.tag = 1
            stackHowToMakeTicketBody.isHidden = false
        }else{
            viewHowToMakeTicketHeader.tag = 0
            stackHowToMakeTicketBody.isHidden = true
        }
    }
    
    @IBAction func goToWhatsApp(_ sender: Any) {
        let phoneNumber =  supportStrings.whats_no.rawValue // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
    
    @IBAction func goToChat(_ sender: Any) {
        if (viewChat.tag == 0){
            viewChat.tag = 1
            UIView.animate(withDuration: 0.3,delay: 0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 1,options: [],animations:{
                self.viewWhats.isHidden = false
                self.viewClose.isHidden = false
            },completion: nil)
        }else{
            let vc = LiveChatVC(nibName: "LiveChatVC", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        viewChat.tag = 0;
        viewWhats.isHidden = true
        viewClose.isHidden = true
    }
    @IBAction func send(_ sender: Any) {
        lblEmailError.isHidden = true
        lblDetailsError.isHidden = true
        var valid = true
        if (txtEmail.text!.isEmpty){
            valid = false
            lblEmailError.text = errorMsgs.field_required.localizedValue
            lblEmailError.isHidden = false
        }else if (!txtEmail.text!.isEmail()){
            valid = false
            lblEmailError.text = errorMsgs.invalid_email.localizedValue
            lblEmailError.isHidden = false
        }
        let details = txtDetails.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (details.isEmpty){
            valid = false
            lblDetailsError.text = errorMsgs.field_required.localizedValue
            lblDetailsError.isHidden = false
        }else if (details.count > 1500){
            valid = false
            lblDetailsError.text = errorMsgs.invalid_ticket_details.localizedValue
            lblDetailsError.isHidden = false
        }
        if (valid){
            let request = TicketRequestBody(name: txtFullname.text!, mobileNumber: txtMobile.text!, email: txtEmail.text!, ticketTypeDTO: tickets[selectedIndex], details: details)
            viewError.startLoading()
            SupportAPIs.addTicket(request, self)
        }
    }
    
}

extension SupportCenterVC{
    
    func setupUI(){
        txtEmail.delegate = self
        txtDetails.delegate = self
        self.tableView.isHidden = true
        txtDetails.drawBorder(.lightBorderColor, UIDevice.isPad ? 4 : 2, 1)
        viewWhats.setupShadowsWithRound(UIDevice.isPad ? 70 / 2 : 60 / 2)
        viewClose.setupShadowsWithRound(UIDevice.isPad ? 70 / 2 : 60 / 2)
        viewHowToMakeTicket.setupShadowsWithRound(UIDevice.isPad ? 8 : 4)
        txtEmail.drawBorder(.lightBorderColor, UIDevice.isPad ? 4 : 2, 1)
        viewChat.setupShadowsWithRound(UIDevice.isPad ? 70 / 2 : 60 / 2)
        viewHowToMakeTicketHeader.round(to: UIDevice.isPad ? 8 : 4)
        icHowTo1.round(to: UIDevice.isPad ? 30 / 2 : 25 / 2)
        icHowTo2.round(to: UIDevice.isPad ? 30 / 2 : 25 / 2)
        icHowTo3.round(to: UIDevice.isPad ? 30 / 2 : 25 / 2)
        icHowTo4.round(to: UIDevice.isPad ? 30 / 2 : 25 / 2)
        lbl1.round(to: UIDevice.isPad ? 35 / 2 : 25 / 2)
        lbl2.round(to: UIDevice.isPad ? 35 / 2 : 25 / 2)
        lbl3.round(to: UIDevice.isPad ? 35 / 2 : 25 / 2)
        lbl4.round(to: UIDevice.isPad ? 35 / 2 : 25 / 2)
        lbl5.round(to: UIDevice.isPad ? 35 / 2 : 25 / 2)
        txtFullname.round(to: UIDevice.isPad ? 4 : 2)
        txtMobile.round(to: UIDevice.isPad ? 4 : 2)
        btnSend.round(to: UIDevice.isPad ? 4 : 2)
        
        lblTalkTo.text = supportStrings.talk_with_support_team.localizedValue
        lblType.text = supportStrings.choose_ticket_type.localizedValue
        lblHowToMakeTicket.text = supportStrings.how_to.localizedValue
        lblDetails.text = supportStrings.ticket_details.localizedValue
        lblEmail.text = supportStrings.email_address.localizedValue
        lblWhatsApp.text = supportStrings.whats_app.localizedValue
        lblEmailAddress.text = supportStrings.email.localizedValue
        lblFullname.text = supportStrings.full_name.localizedValue
        lblWhatsNo.text = supportStrings.whats_no.localizedValue
        lblMobile.text = supportStrings.mobile_no.localizedValue
        lblHowTo1.text = supportStrings.how_to_1.localizedValue
        lblHowTo2.text = supportStrings.how_to_2.localizedValue
        lblHowTo3.text = supportStrings.how_to_3.localizedValue
        lblHowTo4.text = supportStrings.how_to_4.localizedValue
        lblChat.text = supportStrings.chat.localizedValue
        lblOr.text = supportStrings.or.localizedValue
        btnSend.setTitle(accountStrings.send.localizedValue, for: .normal)
        
        txtFullname.isEnabled = false
        txtMobile.isEnabled = false
        viewError.delegate = self
        
        
        lblWhatsNo.textAlignment = lang == "en" ? .left : .right
        lblEmailAddress.textAlignment = lang == "en" ? .left : .right
        setupInfo()
        
        setupTableView()
    }
    
    func setupInfo(){
        if let user = DataService.getUserData(), let info = user.reseller{
            txtFullname.text = info.fullName
            txtEmail.text = user.accountType == Roles.MASTER_ACCOUNT.rawValue ? info.email : info.parentResellerEmail ?? info.email
            txtMobile.text = info.mobileNumber
        }
    }
    
    func loadData(){
        viewError.startLoading()
        SupportAPIs.getTicketTypes(self)
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: TicketTypeCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = cellHeight;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.clear;
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func animateDetails(_ hide: Bool){
        UIView.animate(withDuration: 0.3,delay: 0.0,usingSpringWithDamping: 0.9,initialSpringVelocity: 1,options: [],animations:{
            self.imgArrow.transform = CGAffineTransform(rotationAngle: hide ? 0 : (lang == "en" ? CGFloat.pi : -CGFloat.pi))
        },completion: nil)
    }
}
extension SupportCenterVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
extension SupportCenterVC: OnFinishDelegate{
    func onFailed(err: ServiceError, _ tag: Int) {
        self.viewError.stopLoading()
        switch err{
        case .unauthorized:
            DataService.deleteUserData()
            DataService.loadHome(sessionEnded: true)
        case .other:
            if (tag == 0){
                viewError.showException(error: ErrorMessage(err.errorDescription))
            }else{
                DataService.ds.showAlert(self, err.errorDescription)
            }
        case .noInternetConnection:
            if (tag == 0){
                viewError.showInternetOff()
            }else{
                DataService.ds.showAlert(self, errorMsgs.internet.localizedValue)
            }
        case .custom(let error):
            if (tag == 0){
                viewError.showException(error: error)
            }else{
                DataService.ds.showAlert(self, error.errorMessage)
            }
        }
    }
    
    func onSuccess(_ tickets: [Ticket]) {
        self.viewError.stopLoading()
        self.tableView.isHidden = false
        self.tickets = tickets
        selectedIndex = tickets.firstIndex(where: {$0.nameEn.lowercased() == "suggestion"}) ?? -1
        if transactionLog != nil{
            if tickets.count > 0{
                var index = 0
                for ticket in tickets{
                    let _ = print("Noura ==== \(ticket.nameEn.lowercased())")
                    if ticket.nameEn.lowercased() == "complaint"{
                        selectedIndex = index
                        break
                    }
                    index += 1
                }
            }
        }
        tableView.reloadData()
        constTableHeight.constant  = CGFloat(tickets.count) * cellHeight
        
    }
    func onSuccess() {
        self.viewError.stopLoading()
        DataService.ds.showAlert(self, supportStrings.successful_message.localizedValue, type: .success) {
            DataService.loadHome()
        }
    }
}
extension SupportCenterVC: ReloadDataDelegate{
    func reloadData() {
        loadData()
    }
}
extension SupportCenterVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTypeCell", for: indexPath) as? TicketTypeCell{
            cell.lbl.text = tickets[indexPath.row].getName()
            if (selectedIndex == indexPath.row){
                cell.checked()
            }else{
                cell.unchecked()
            }
            return cell
        }
        return TicketTypeCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
extension SupportCenterVC: UITextViewDelegate, UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        lblEmailError.isHidden = true
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        lblDetailsError.isHidden = true
        return true
    }
}
