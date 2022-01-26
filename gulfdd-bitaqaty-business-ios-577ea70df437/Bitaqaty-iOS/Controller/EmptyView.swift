//
//  EmptyView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 6/23/21.
//

import Foundation
import XLPagerTabStrip

class EmptyView: UIViewController {
    var itemInfo: IndicatorInfo = "View";
    @IBOutlet weak var lblTextError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTextError.text = strings.noPermission.localizedValue
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.parent?.title = strings.Home.localizedValue;
    }
}
extension EmptyView: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
