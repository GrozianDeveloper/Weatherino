//
//  UITableView.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 01.03.2023.
//

import UIKit.UITableView

extension UITableView {
    
    func register(_ nibable: Nibable.Type) {
        if nibable is UITableViewCell.Type {
            register(nibable.nib, forCellReuseIdentifier: nibable.identifier)
        } else {
            register(nibable.nib, forHeaderFooterViewReuseIdentifier: nibable.identifier)
        }
    }
    
}
