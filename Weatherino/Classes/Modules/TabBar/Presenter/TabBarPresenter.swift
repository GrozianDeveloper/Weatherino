//
//  TabBarTabBarPresenter.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import Foundation

final class TabBarPresenter: NSObject {


    //MARK: - Variables
    
    var interactor: TabBarInteractorInterface?
    weak var root: TabBarDelegate?
    weak var controller: TabBarControllerInterface?
}


//MARK: - TabBarInterface

extension TabBarPresenter: TabBarInterface {

}


//MARK: - TabBarControllerDelegate

extension TabBarPresenter: TabBarControllerDelegate {
    
}


//MARK: - TabBarInteractorDelegate

extension TabBarPresenter: TabBarInteractorDelegate {

}
