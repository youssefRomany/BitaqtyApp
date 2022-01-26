//
//  UISearchBar+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func setFont() {
        let textField =  self.value(forKey: "searchField") as? UITextField
        textField?.font = UIFont.regularMedium;
    }
    func setBackground(){
        self.setBackgroundImage(UIImage(), for: .any, barMetrics: .default);
        let searchTextField =  self.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = UIColor.lightGray
    }
    
    func changeSearchIcon(){
        let searchTextField:UITextField = self.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = lang == "en" ? .left : .right
        let image:UIImage = UIImage(named: "search")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
    }

    var compatibleSearchTextField: UITextField {
          guard #available(iOS 13.0, *) else { return legacySearchField }
          return self.searchTextField
      }

      private var legacySearchField: UITextField {
          if let textField = self.subviews.first?.subviews.last as? UITextField {
              // Xcode 11 previous environment
              return textField
          } else if let textField = self.value(forKey: "searchField") as? UITextField {
              // Xcode 11 run in iOS 13 previous devices
              return textField
          } else {
              // exception condition or error handler in here
              return UITextField()
          }
      }
    func setPlaceHolder(text: String?) {
         self.layoutIfNeeded()
         self.placeholder = text
         var textFieldInsideSearchBar:UITextField?
         if #available(iOS 13.0, *) {
             textFieldInsideSearchBar = self.searchTextField
         } else {
             for view : UIView in (self.subviews[0]).subviews {
                 if let textField = view as? UITextField {
                     textFieldInsideSearchBar = textField
                 }
             }
         }
         
         //get the sizes
         let searchBarWidth = self.frame.width
         let placeholderIconWidth = textFieldInsideSearchBar?.leftView?.frame.width
         let placeHolderWidth = textFieldInsideSearchBar?.attributedPlaceholder?.size().width
         let offsetIconToPlaceholder: CGFloat = 8
         let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
         
         let offset = UIOffset(horizontal: (((searchBarWidth - 40) / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon), vertical: 0)
         self.setPositionAdjustment(offset, for: .search)
     }
    func setCenteredPlaceHolder(){
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        //get the sizes
        let searchBarWidth = self.frame.width
        let placeholderIconWidth = textFieldInsideSearchBar?.leftView?.frame.width
        let placeHolderWidth = textFieldInsideSearchBar?.attributedPlaceholder?.size().width
        let offsetIconToPlaceholder: CGFloat = 8
        let placeHolderWithIcon = placeholderIconWidth! + offsetIconToPlaceholder
        
        let offset = UIOffset(horizontal: (((searchBarWidth - 40) / 2) - (placeHolderWidth! / 2) - placeHolderWithIcon - 30), vertical: 0)
        self.setPositionAdjustment(offset, for: .search)
    }
}


