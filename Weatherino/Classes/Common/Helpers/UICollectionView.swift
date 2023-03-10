//
//  UICollectionView.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 01.03.2023.
//

import UIKit.UICollectionView

extension UICollectionView {
    
    func register(_ cell: Nibable.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.identifier)
    }
    
}
