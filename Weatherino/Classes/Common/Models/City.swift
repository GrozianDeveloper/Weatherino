//
//  Location.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 02.03.2023.
//

import Foundation.NSDecimalNumber

struct City: Hashable {
    
    let name: String
    let lat: Double
    let lon: Double
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    
}
