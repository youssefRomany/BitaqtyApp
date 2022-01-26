//
//  HomeDailyView.swift
//  Bitaqaty-iOS
//
//  Created by Noura on 11/10/2021.
//

import Foundation
import Charts

class HomeDailyView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblThisMonthTitle: UILabel!
    @IBOutlet weak var lblLastMonthTitle: UILabel!
    @IBOutlet weak var lblThisMonthValue: UILabel!
    @IBOutlet weak var lblLastMonthValue: UILabel!
    @IBOutlet weak var lblChartTitle: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var lineChart: LineChartView!
    
    @IBOutlet weak var viewDataContainer: UIView!
    @IBOutlet weak var viewNoData: UIView!
    
    @IBOutlet weak var btnChargeNo: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    // MARK: setup view
    
    private func loadViewFromNib() -> UIView {
        let viewBundle = Bundle(for: type(of: self))
        let view = viewBundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0]
        self.tag = 0;
        lblNoData.text = errorMsgs.no_data.localizedValue
        btnChargeNo.setTitle(HomeStrings.recharge_now.localizedValue, for: .normal)
        lblThisMonthValue.textAlignment = lang == "en" ? .left : .right
        lblLastMonthValue.textAlignment = lang == "en" ? .left : .right
        lblThisMonthTitle.textAlignment = lang == "en" ? .left : .right
        lblLastMonthTitle.textAlignment = lang == "en" ? .left : .right
        lblTitle.textAlignment = lang == "en" ? .left : .right
        btnChargeNo.round(to: 2)
        return view as! UIView
    }
    
    private func commonSetup() {
        let nibView = loadViewFromNib()
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(nibView)
    }
    @IBAction func onRechargeClicked(_ sender: Any) {
        if let parentVC = self.parentViewController?.parent {
            if let parentVC = parentVC as? MainVC {
                parentVC.showHideRecharge()
            }
        }
    }
    func setupDailySales(){
        lblTitle.text = HomeStrings.daily_sales.localizedValue
        lblChartTitle.text = HomeStrings.daily_sales.localizedValue
        lblThisMonthTitle.text = HomeStrings.average_sales_this_month.localizedValue
        lblLastMonthTitle.text = HomeStrings.average_sales_last_month.localizedValue
        pieChart.isHidden = false
        btnChargeNo.isHidden = true
    }
    
    func setupDailyRecharge(){
        lblTitle.text = HomeStrings.daily_recharge.localizedValue
        lblChartTitle.text = HomeStrings.home_recharge_amount.localizedValue
        lblThisMonthTitle.text = HomeStrings.remaining.localizedValue
        lblLastMonthTitle.text = HomeStrings.averageLast7Days.localizedValue
        pieChart.isHidden = true
        btnChargeNo.isHidden = false
    }
    
    func setupSalesData(data: HomeSales){
        if isSalesCleared(data){
            viewNoData.isHidden = false
            return
        }
        viewDataContainer.setupShadowsWithRound(3)
        
        var currency = ""
        if let user = DataService.getUserData(), user.reseller != nil{
            currency = user.reseller!.Currency
        }
        lblThisMonthValue.text = data.thisMonthAvg != "N/A" ? "\(data.thisMonthAvg!) \(currency)" : data.thisMonthAvg
        lblLastMonthValue.text = data.lastMonthAvg != "N/A" ? "\(data.lastMonthAvg!) \(currency)" : data.lastMonthAvg
        drawPieChart(data.salesIncrease!)
        var arr = data.weeklySalesDTO!
        arr.append(data.todaySales!)
        setupLineChart(arr)
    }
    func isSalesCleared(_ dailySales: HomeSales)-> Bool{
        var isEmpty = false
        var isClear = true
        for item in dailySales.weeklySalesDTO!{
            if (item.amount != "0.00") {
                isClear = false
                break
            }
        }
        if (dailySales.thisMonthAvg == "0.00" && dailySales.lastMonthAvg == "0.00" && dailySales.salesIncrease == "N/A" && dailySales.todaySales?.amount == "0.00" && isClear) {
            isEmpty = true
        }
        return isEmpty
    }
    
    func drawPieChart(_ sales: String){
        var entries = [PieChartDataEntry]()
        let colorRed = UIColor.fromString("#DE350B")
        let colorGreen = UIColor.fromString("#008A63")
        var centerText = sales + " ˅"
        var double = 0.0
        var remaining = 100.0
        var centerColor = colorRed
        var colors: [UIColor] = []
        
        if sales != "N/A"{
            centerText = sales + "% ˅"
            double = Double(sales)!
            if double > 0{
                centerText = sales + "% ^"
                if double > 100{
                    double = 100
                    colors.append(colorGreen)
                }else{
                    remaining = 100 - double
                    colors.append(colorGreen)
                    colors.append(.gray)
                }
                centerColor = colorGreen
            }else{
                if double < -100{
                    colors.append(colorRed)
                }else{
                    double = -double
                    remaining = 100 - double
                    colors.append(colorRed)
                    colors.append(.gray)
                }
            }
        }else{
            colors.append(colorRed)
        }
        let entry = PieChartDataEntry()
        entry.y = double
        
        let entry1 = PieChartDataEntry()
        entry1.y = remaining
        
        entries.append(entry)
        entries.append(entry1)
        let set = PieChartDataSet( entries: entries, label: "")
        set.colors = colors
        set.selectionShift = 0
        
        let data = PieChartData(dataSet: set)
        data.setValueTextColor(.clear)
        pieChart.data = data
        pieChart.noDataText = ""
        // user interaction
        pieChart.isUserInteractionEnabled = false
        pieChart.chartDescription = nil
        pieChart.holeRadiusPercent = 0.8
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.legend.enabled = false
        let attriString = NSAttributedString(string: centerText, attributes:
                                                [NSAttributedString.Key.foregroundColor: centerColor,
                                                 NSAttributedString.Key.font: UIFont.lightSmaller])
        pieChart.centerAttributedText = attriString
        //pieChart.setExtraOffsets(left: -15, top: 0, right: -15, bottom: 0)
        pieChart.highlightPerTapEnabled = false
        pieChart.entryLabelColor = .clear
        
    }
    func setupRechargeData(data: HomeSales){
        if isRechargeCleared(data){
            viewNoData.isHidden = false
            return
        }
        viewDataContainer.setupShadowsWithRound(3)
        
        var currency = ""
        if let user = DataService.getUserData(), user.reseller != nil{
            currency = user.reseller!.Currency
        }
        var remaining = "N/A"
        if data.remainingBalance != "N/A"{
            let double = Double(data.remainingBalance!)
            let intVal = Int(double!)
            if(intVal <= data.remaingBalanceSetting!){
                lblThisMonthValue.textColor = UIColor.fromString("#B6003B")
            }
            remaining = "\(intVal) \(HomeStrings.homeDays.localizedValue)"
        }else{
            lblThisMonthValue.textColor = UIColor.fromString("#B6003B")
        }
        
        var attriString = NSMutableAttributedString(string: data.lastWeekAvg!, attributes:
                                                        [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                         NSAttributedString.Key.font: UIFont.boldSmall])
        if(data.lastWeekAvg != "N/A"){
            attriString = NSMutableAttributedString(string: "\(data.LastWeekAvg)", attributes:
                                                        [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                         NSAttributedString.Key.font: UIFont.boldSmall])
            let attriString2 = NSAttributedString(string: " " + currency, attributes:
                                                    [NSAttributedString.Key.foregroundColor: UIColor.textColor,
                                                     NSAttributedString.Key.font: UIFont.lightSmaller])
            attriString.append(attriString2)
        }
        
        lblThisMonthValue.text = remaining
        
        lblLastMonthValue.attributedText = attriString
        
        var arr = data.weeklyDataDTO!
        arr.append(data.todayRecharge!)
        setupLineChart(arr)
    }
    
    func isRechargeCleared(_ dailySales: HomeSales)-> Bool{
        var isEmpty = false
        var isClear = true
        for item in dailySales.weeklyDataDTO!{
            if (item.amount != "0.00") {
                isClear = false
                break
            }
        }
        if (dailySales.remainingBalance == "N/A" && dailySales.LastWeekAvg == 0.0 && dailySales.todayRecharge?.amount == "0" && isClear) {
            isEmpty = true
        }
        return isEmpty
    }
    func setupLineChart(_ dataSales: [Sales]){
        var index = 0.0
        var entries = [ChartDataEntry]()
        var xLabels = [String]()
        for item in dataSales{
            let entry = ChartDataEntry(x: index, y: item.Amount)
            let day = DateUtils.ds.getChartDay(dateStr: item.date!)
            xLabels.append(day)
            entries.append(entry)
            index = index + 1
        }
        lineChart.setScaleEnabled(false)
        let set1 = LineChartDataSet(entries: entries)
        set1.setColor(UIColor.accentColor)
        set1.lineWidth = 2
        set1.setCircleColor(UIColor.fromString("#E0C641"))
        set1.valueTextColor = UIColor.clear
        //        var color = Color.rgb(224, 198, 65)
        //        var color2 = Color.rgb(218, 224, 239)
        
        // set1.setCircleColor(color)
        set1.circleRadius = 4
        set1.drawCircleHoleEnabled = false
        set1.setDrawHighlightIndicators(false)
        //set1.highlightEnabled = false
        
        let data = LineChartData(dataSet: set1)
        lineChart.data = data
        lineChart.legend.enabled = false
        lineChart.rightAxis.enabled = false
        
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.labelRotationAngle = 45
        xAxis.drawGridLinesEnabled = false
        xAxis.labelFont = .regularSmaller
        xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabels)
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = .regularSmall
        yAxis.axisMinimum = 0
        let max = getMaxValue(dataSales)
        let _ = print("Noura MAX = \(max)")
        yAxis.axisMaximum = max
        yAxis.valueFormatter = CustomFormatter()
        if lang == "en"{
            lineChart.extraRightOffset = 10;
        }else{
            lineChart.extraBottomOffset = 20
            lineChart.extraLeftOffset = 10;
        }
        let marker = RectMarker(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), font: UIFont.boldSmall, insets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 4.0, right: 4.0), daysArr: xLabels)
        marker.days = xLabels
        marker.chartView = lineChart
        marker.minimumSize = CGSize(width: CGFloat(60.0), height: CGFloat(30.0))
        lineChart.marker = marker
        lineChart.notifyDataSetChanged()
        
    }
    func getMaxValue(_ data: [Sales])-> Double{
        var value = 100.0
        for item in data{
            if (item.Amount > value) {
                value = item.Amount
            }
        }
        if (value > 0) {//) && value < 100){
            return roundUpNumberByUsingMultipleValue(value)
        }
        return value
    }
    
    func roundUpNumberByUsingMultipleValue(_ number: Double)-> Double {
        return (ceil(number / 100.0)) * 100
    }
}


class CustomFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var currency = ""
        if let user = DataService.getUserData(), user.reseller != nil{
            currency = user.reseller!.Currency
        }
        
        return "\(Int(value)) \(currency)"
    }
}
