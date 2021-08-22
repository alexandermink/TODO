//
//  TableRowsAnimation.swift
//  TODO
//
//  Created by Vit K on 14.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TableRowsAnimation {
    static func animateTable(table: UITableView) {
        table.reloadData()
        let cells = table.visibleCells
        
        let tableHeight: CGFloat = table.bounds.size.height
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 330, y: tableHeight)
        }
        var index = 0
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            cell.alpha = 0
            UIView.animate(withDuration: 2, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
            
            index += 1
        }
    }
}
