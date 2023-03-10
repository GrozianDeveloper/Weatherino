//
//  SettingsSettingsHeader.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

final class SettingsHeader: NSObject {


    //MARK: - Controller
    
    weak var controller: SettingsViewController!


    //MARK: - Init
    
    init(root: SettingsDelegate) {
        super.init()

        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor()
        controller = moduleController()

        presenter.root = root
        presenter.controller = controller
        presenter.interactor = interactor

        controller.presenter = presenter
        interactor.presenter = presenter
    }
}


//MARK: - Public methods

extension SettingsHeader {

    func currentController() -> UIViewController {
        return controller
    }
}


//MARK: - Private methods

private extension SettingsHeader {
    
    func moduleController() -> SettingsViewController {
        return moduleStoryboard().instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    }

    func moduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
}


//MARK: - SettingsInterface

extension SettingsHeader: SettingsInterface {

}
