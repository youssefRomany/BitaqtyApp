//
//  BankTransferVC.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/23/21.
//

import UIKit
import XLPagerTabStrip

class BankTransferVC: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var viewInstruction: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var tableHeightConst: NSLayoutConstraint!
    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var imgStep1: UIImageView!
    @IBOutlet weak var lblStep1: LblSmallerLightFont!
    @IBOutlet weak var viewStep2: UIView!
    @IBOutlet weak var imgStep2: UIImageView!
    @IBOutlet weak var lblStep2: LblSmallerLightFont!
    @IBOutlet weak var viewStep3: UIView!
    @IBOutlet weak var imgStep3: UIImageView!
    @IBOutlet weak var lblStep3: LblSmallerLightFont!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var loader: ErrorView!
    @IBOutlet weak var headerView: CloseHeaderView!
    
    var viewModel = BankTransferViewModel()
    
    var arr: [String] = [btrrStrings.btrr_instruction_1.localizedValue,
                         btrrStrings.btrr_instruction_2.localizedValue,
                         btrrStrings.btrr_instruction_3.localizedValue,
                         btrrStrings.btrr_instruction_4.localizedValue,
                         btrrStrings.btrr_instruction_5.localizedValue,
                         btrrStrings.btrr_instruction_6.localizedValue,
                         btrrStrings.btrr_instruction_7.localizedValue,
                         btrrStrings.btrr_instruction_8.localizedValue,
                         btrrStrings.btrr_instruction_9.localizedValue,
                         btrrStrings.btrr_instruction_10.localizedValue,
                         btrrStrings.btrr_instruction_11.localizedValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPagerOrientation()
        setupUI()
        setupTableView()
    }
    
    func setPagerOrientation(){
        buttonBarView.isHidden = true
        containerView.isScrollEnabled = false
        if lang == "ar" {
            containerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            for controller in viewControllers{
                controller.view.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            }
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = BankTransferStep1VC(nibName: "BankTransferStep1VC", bundle: nil)
        let child_2 = BankTransferStep2VC(nibName: "BankTransferStep2VC", bundle: nil)
        let child_3 = BankTransferStep3VC(nibName: "BankTransferStep3VC", bundle: nil)
        child_1.delegate = self
        child_2.delegate = self
        child_3.delegate = self
        
        child_1.viewModel = viewModel
        child_2.viewModel = viewModel
        child_3.viewModel = viewModel
        
        child_1.itemInfo.title = btrrStrings.btrr_select_bank.localizedValue
        child_2.itemInfo.title = btrrStrings.btrr_sender_details.localizedValue
        child_3.itemInfo.title = btrrStrings.btrr_transfer_details.localizedValue
        
        return [child_1, child_2,child_3]
    }
    
    
    @IBAction func toggleInstruction(_ sender: Any) {
        if tableView.tag == 0 {
            tableView.tag = 1
            tableView.isHidden = false
        }else{
            tableView.tag = 0
            tableView.isHidden = true
        }
    }
    
}

extension BankTransferVC: BankTransferDelegate{
    func previous() {
        if (currentIndex > 0){
            self.moveToViewController(at: currentIndex - 1, animated: true)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
                self.setupPagerIndicator()
            }
        }
    }
    
    func startLoading() {
        self.loader.startLoading(strings.loading.localizedValue)
    }
    
    func startLoading(msg: String) {
        self.loader.startLoading(msg)
    }
    
    func stopLoading() {
        self.loader.stopLoading()
    }
    
    func next(){
        if currentIndex < 2{
            self.moveToViewController(at: currentIndex + 1, animated: true)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
                self.setupPagerIndicator()
            }
        }
    }
}
extension BankTransferVC{
    
    func setupUI(){
        lblInstruction.textAlignment = lang == "en" ? .left : .right
        headerView.showX(btrrStrings.btrr_bank_transfer.localizedValue) {
            self.dismiss(animated: true, completion: nil)
        }
        lblInstruction.text = btrrStrings.btrr_instruction.localizedValue
        viewInstruction.layer.cornerRadius = 4
        viewInstruction.setupWithRoundNoShadow(4)
        lblStep1.text = btrrStrings.btrr_select_bank.localizedValue
        lblStep2.text = btrrStrings.btrr_sender_details.localizedValue
        lblStep3.text = btrrStrings.btrr_transfer_details.localizedValue
        selected(viewStep1)
        unselected(viewStep2)
        unselected(viewStep3)
    }
    
    func setupTableView(){
        tableView.registerCellNib(cellClass: InstructionCell.self);
        tableView.tableFooterView = UIView();
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.backgroundColor = UIColor.white;
    }
    
    func unselected(_ view: UIView){
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.fromString("#D3D3D3").cgColor
        if (view.tag == 1){
            imgStep2.image = UIImage(named: "ic_sender_details")
            line1.backgroundColor = .bgColor
        }else if (view.tag == 2){
            imgStep3.image = UIImage(named: "ic_transfer_details")
            line2.backgroundColor = .bgColor
        }else{
            imgStep1.image = UIImage(named: "is_select_bank")
        }
    }
    
    func selected(_ view: UIView){
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = UIColor.darkYellowColor
        view.layer.borderWidth = 0
        if (view.tag == 1){
            imgStep2.image = UIImage(named: "ic_sender_details_selected")
            line1.backgroundColor = .darkYellowColor
        }else if (view.tag == 2){
            imgStep3.image = UIImage(named: "ic_transfer_details_selected")
            line2.backgroundColor = .darkYellowColor
        }else{
            imgStep1.image = UIImage(named: "is_select_bank")
        }
    }
    
    func setupPagerIndicator(){
        switch (currentIndex){
        case 1:
            selected(viewStep1)
            selected(viewStep2)
            unselected(viewStep3)
        case 2:
            selected(viewStep1)
            selected(viewStep2)
            selected(viewStep3)
        default:
            selected(viewStep1)
            unselected(viewStep2)
            unselected(viewStep3)
        }
    }
}
extension BankTransferVC: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as? InstructionCell{
            cell.lbl.text = arr[indexPath.row]
            tableHeightConst.constant = tableView.contentSize.height
            return cell
        }
        print("\(indexPath.row)")
        return InstructionCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
