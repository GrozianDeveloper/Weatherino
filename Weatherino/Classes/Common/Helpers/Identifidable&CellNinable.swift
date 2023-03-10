//
//  Nibable.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 01.03.2023.
//

import UIKit.UINib


//MARK: - CellIdentifidable

protocol TypeIdentifidable {
    static var identifier: String { get }
}

extension TypeIdentifidable {
    static var identifier: String {
        var identifier = String(reflecting: Self.self)
        while identifier.contains(".") {
            identifier.removeFirst()
        }
        return identifier
    }
}


//MARK: - CellNibable

protocol Nibable: TypeIdentifidable {
    static var nib: UINib { get }
}

extension Nibable {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
}

