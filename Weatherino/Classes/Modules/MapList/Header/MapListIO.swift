//
//  MapListMapListIO.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit.UIViewController

protocol MapListInterface: AnyObject {
    
}

protocol MapListDelegate: AnyObject {
    
    func showMark(from vc: UIViewController, lat: Double, lon: Double)
    
}
