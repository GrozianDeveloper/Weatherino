//
//  Sequence.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 28.02.2023.
//

import Foundation

extension Array where Element: Equatable {
    
    @discardableResult mutating func remove(_ member: Element) -> Element? {
        guard let index = self.enumerated().first(where: { $1 == member }) else {
            return nil
        }
        return remove(at: index.offset)
    }
    
}
