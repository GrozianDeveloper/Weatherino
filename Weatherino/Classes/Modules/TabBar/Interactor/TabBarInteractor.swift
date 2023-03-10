//
//  TabBarTabBarInteractor.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import Foundation

final class TabBarInteractor: NSObject {


    //MARK: - Variables
    
    weak var presenter: TabBarInteractorDelegate?

}


//MARK: - TabBarInteractorInterface

extension TabBarInteractor: TabBarInteractorInterface {

}
