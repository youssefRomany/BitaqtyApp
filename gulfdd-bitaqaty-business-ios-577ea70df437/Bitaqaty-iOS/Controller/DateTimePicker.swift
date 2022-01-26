//
//  DateTimePicker.swift
//  Bitaqaty-iOS
//
//  Created by Alia Ziada on 8/29/21.
//

import UIKit

class DateTimePicker: UIViewController {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: PopOverDelegate?
    var date: String? = nil
    var type = 1
    var isDateOnly = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDone.setTitle(msgs.doneTxt.localizedValue, for: .normal)
        btnCancel.setTitle(msgs.cancel.localizedValue, for: .normal)
        datePicker.maximumDate = Date()
        datePicker.date = DateUtils.ds.getDateFromString(date)
        datePicker.locale = Locale(identifier: lang)
        if isDateOnly {
            datePicker.datePickerMode = .date
        }
    }
    
    
    @IBAction func selectDate(_ sender: UIButton) {
        let selectedDate = datePicker.date
        delegate?.getDate(type,selectedDate)
        dismiss(animated: false, completion: nil);
    }
    

    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func close(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
}
