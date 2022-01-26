//
//  RectMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts

open class RectMarker: MarkerImage
{
    open var color: NSUIColor?
    open var font: NSUIFont?
    open var insets = UIEdgeInsets()
    open var days: [String] = []

    open var miniTime : Double = 0.0
    var interval = 3600.0 * 24.0 // one day
    
    open var minimumSize = CGSize()
    var dateFormatter = DateFormatter()
    
    fileprivate var label: NSMutableAttributedString?
    fileprivate var _labelSize: CGSize = CGSize()
    
    public init(color: NSUIColor, font: NSUIFont, insets: UIEdgeInsets, miniTime: Double = 0.0, interval: Double = 0.0, daysArr: [String])
    {
        super.init()
        
        
        self.days = daysArr
        self.color = color
        self.font = font
        self.insets = insets
        self.miniTime = miniTime
        self.interval = interval
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = CGPoint() //CGPoint(x: 10.0, y:10.0)
        let chart = self.chartView
        var size = self.size
        
        if size.width == 0.0 && image != nil
        {
            size.width = image?.size.width ?? 0.0
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image?.size.height ?? 0.0
        }
        
        let width = size.width
        let height = size.height
        let origin = point
        
        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x
        }
        else if chart != nil && origin.x + width + offset.x > chart!.viewPortHandler.contentRect.maxX
        {
            offset.x =  -width
        }
        
        if origin.y + offset.y < 0
        {
            offset.y = height
        }
        else if chart != nil && origin.y + height + offset.y > chart!.viewPortHandler.contentRect.maxY
        {
            offset.y =  -height
        }
        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        let rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        
        context.saveGState()
        if let color = color
        {
//            context.setFillColor(color.cgColor)
            context.beginPath()
            drawRoundedRect(rect: rect, inContext: context, radius: 10.0, borderColor: UIColor.blue.cgColor, fillColor: color.cgColor)
//            context.addRect(rect)
            context.fillPath()
        }
        label.draw(in: rect)
        context.restoreGState()
    }
    
    func drawRoundedRect(rect: CGRect, inContext context: CGContext?,
                         radius: CGFloat, borderColor: CGColor, fillColor: CGColor) {
        // 1
        let path = CGMutablePath()
        
        // 2
        path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ),
                     tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                     tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.closeSubpath()
        
        // 3
        context?.setLineWidth(1.0)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(UIColor.lightGray.cgColor)
        
//        context?.addPath(CGPath(roundedRect: CGRect(x: 0, y: 0, width: 27, height: 2.5), cornerWidth: 1, cornerHeight: 1, transform: nil))
//                context?.fillPath()
        // 4
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }

    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight){
        let intValue = Int(entry.x)
        let day = days[intValue]
        var val = ""
        if let user = DataService.getUserData(), let reseller = user.reseller{
             val = "\(entry.y) \(reseller.Currency)"
            let _ = print("Noura \(val)")
        }
        
        
        let mutableString = NSMutableAttributedString( string: "\n  " )
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "ic_circle2")
        attachment.bounds = CGRect(x: 0, y: -4, width: 12, height: 12)
        let replacement = NSAttributedString(attachment: attachment)
        mutableString.append(replacement)
        
        let labelAttributes:[NSAttributedString.Key: Any]? = [
            .font : UIFont.boldSmall,
            .foregroundColor : UIColor.secondryColor]
        let addedString = NSAttributedString(string: "  \(day)", attributes: labelAttributes)
        mutableString.append(addedString)
        
        let labelAttributes2 :[NSAttributedString.Key : Any]? = [
            .font : UIFont.boldSmall,
            .foregroundColor : NSUIColor.textColor ]
        
        let addedString2 = NSAttributedString(string: "  \(val)", attributes: labelAttributes2)
        mutableString.append(addedString2)
        setLabel(mutableString)
    }
    
    open func setLabel(_ newlabel: NSMutableAttributedString)
    {
        label = newlabel
        _labelSize = label!.size()
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
}

