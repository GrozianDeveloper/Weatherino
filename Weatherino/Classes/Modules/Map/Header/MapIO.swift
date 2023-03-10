//
//  MapMapIO.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit.UIButton

protocol MapInterface: AnyObject {
}

protocol MapDelegate: AnyObject {
    
    func showMaplist(from vc: UIViewController?)
    
}
