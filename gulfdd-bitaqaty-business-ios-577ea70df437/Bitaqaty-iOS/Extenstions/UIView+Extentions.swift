//
//  UIView+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func round(to radius: CGFloat) {
        layer.cornerRadius = radius;
        clipsToBounds = true;
    }
    
    func basicBoarderWithRound(to radius: CGFloat) {
        layer.cornerRadius = radius;
        clipsToBounds = true;
        layer.borderColor = UIColor.lightGray.cgColor;
        layer.borderWidth = 1;
    }
    
    func primaryBoarderWithRound(to radius: CGFloat) {
        layer.cornerRadius = radius;
        clipsToBounds = true;
        layer.borderColor = UIColor.primary.cgColor;
        layer.borderWidth = 1;
    }
    
    func accentBoarderWithRound(to radius: CGFloat) {
        layer.cornerRadius = radius;
        clipsToBounds = true;
        layer.borderColor = UIColor.accentColor.cgColor;
        layer.borderWidth = 1;
    }
    

    
    func customBoarderWithRound(to radius: CGFloat,with color: UIColor) {
        layer.cornerRadius = radius;
        clipsToBounds = true;
        layer.borderColor = color.cgColor;
        layer.borderWidth = 1;
    }
    
    func setupShadows(){
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOpacity = 1.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2.5
    }
    
    func setupShadowsWithRound(_ radius: CGFloat){
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        layer.cornerRadius = radius;
    }
    func setupShadowsWithRoundGray(_ radius: CGFloat){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 4
        layer.cornerRadius = radius;
    }
    func setupWithRoundNoShadow(_ radius: CGFloat){
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2.5
        layer.cornerRadius = radius;
    }
    
    func roundedTop(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners =  [.layerMaxXMinYCorner, .layerMinXMinYCorner];
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
            
            self.layer.mask = rectShape
        }
    }
    
    func roundedBttom(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners =  [.layerMaxXMaxYCorner, .layerMinXMaxYCorner];
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
            
            self.layer.mask = rectShape
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func toImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            print("boundsss \(bounds.size.width)")
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
    
    
    func viewWithColors(color1: UIColor, color2: UIColor){
        let gradient = CAGradientLayer()
        gradient.colors = [
            color1.cgColor,
            color2.cgColor
        ]
        gradient.locations = [0, 0.8, 1]
        gradient.frame = frame;
        layer.insertSublayer(gradient, at: 1)
    }
//    func addGradientForView() {
//        let gradient = CAGradientLayer()
//        let color1 = UIColor.primary
//        let color2 = UIColor.primaryDark
//        gradient.colors = [
//            color1.cgColor,
//            color2.cgColor
//        ]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//        var frame = bounds
//        frame.size.height += UIApplication.shared.statusBarFrame.size.height
//        frame.origin.y -= UIApplication.shared.statusBarFrame.size.height
//        gradient.frame = frame
//        layer.insertSublayer(gradient, at: 1)
//    }
//
    func reverse(){
        transform = CGAffineTransform(scaleX: -1, y: 1);
    }
    func drawBorder(_ color: UIColor,_ round: CGFloat,_ borderWidth: CGFloat?){
        layer.cornerRadius = round;
        layer.borderColor = color.cgColor;
        layer.borderWidth = borderWidth ?? 1;
        clipsToBounds = true;
    }
    
    func removeBoarder(){
        layer.borderWidth = 0;
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .gray, opacity: Float = 0.4, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }

    @discardableResult
       public func addBlur(style: UIBlurEffect.Style = .extraLight) -> UIVisualEffectView {
           let blurEffect = UIBlurEffect(style: style)
           let blurBackground = UIVisualEffectView(effect: blurEffect)
           addSubview(blurBackground)
           blurBackground.translatesAutoresizingMaskIntoConstraints = false
           blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
           blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
           blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
           blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
           return blurBackground
       }
    
     func addBlurEffect(){
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            //self.addSubview(blurEffectView)
            self.insertSubview(blurEffectView, at: 0)
            //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = .bgColor
        }
    }
    func createDottedLine(width: CGFloat, color: CGColor) {
       let caShapeLayer = CAShapeLayer()
       caShapeLayer.strokeColor = color
       caShapeLayer.lineWidth = width
       caShapeLayer.lineDashPattern = [2,3]
       let cgPath = CGMutablePath()
       let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
       cgPath.addLines(between: cgPoint)
       caShapeLayer.path = cgPath
       layer.addSublayer(caShapeLayer)
    }
    
    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
    }
//    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//         let mask = CAShapeLayer()
//         mask.path = path.cgPath
//         self.layer.mask = mask
//    }
}

