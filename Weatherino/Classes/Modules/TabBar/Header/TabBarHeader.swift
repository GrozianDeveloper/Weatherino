//
//  TabBarTabBarHeader.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

final class TabBarHeader: NSObject {


    //MARK: - Controller
    
    weak var controller: TabBarViewController!


    //MARK: - Init
    
    init(root: TabBarDelegate) {
        super.init()

        let presenter = TabBarPresenter()
        let interactor = TabBarInteractor()
        controller = moduleController()

        presenter.root = root
        presenter.controller = controller
        presenter.interactor = interactor

        controller.presenter = presenter
        interactor.presenter = presenter
    }
}


//MARK: - Public methods

extension TabBarHeader {

    func currentController() -> UIViewController {
        return controller
    }
}


//MARK: - Private methods

private extension TabBarHeader {
    
    func moduleController() -> TabBarViewController {
        return moduleStoryboard().instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
    }

    func moduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "TabBar", bundle: nil)
    }
}


//MARK: - TabBarInterface

extension TabBarHeader: TabBarInterface {

}
