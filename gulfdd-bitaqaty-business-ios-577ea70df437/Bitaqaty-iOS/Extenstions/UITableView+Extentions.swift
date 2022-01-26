//
//  UITableView+Extentions.swift
//  Zillo
//
//  Created by Alia Ziada on 3/5/20.
//  Copyright © 2020 Alia Ziada. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
    
    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }
    
    func dequeueWithIndexPath<Cell: UITableViewCell>(indexPath: IndexPath) -> Cell{
        let identifier = String(describing: Cell.self)
        if let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell{
            return cell
        }else {
            fatalError("Error in cell")
        }
    }
    func removeSeparatorsOfEmptyCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func removeSeparatorsOfEmptyCellsAndLastCell() {
        tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 1)))
    }
}


