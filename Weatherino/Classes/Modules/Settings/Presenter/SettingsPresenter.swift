//
//  SettingsSettingsPresenter.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import Foundation

final class SettingsPresenter: NSObject {


    //MARK: - Variables
    
    var interactor: SettingsInteractorInterface?
    weak var root: SettingsDelegate?
    weak var controller: SettingsControllerInterface?

}


//MARK: - SettingsInterface

extension SettingsPresenter: SettingsInterface {

}


//MARK: - SettingsControllerDelegate

extension SettingsPresenter: SettingsControllerDelegate {
    
}


//MARK: - SettingsInteractorDelegate

extension SettingsPresenter: SettingsInteractorDelegate {

}
