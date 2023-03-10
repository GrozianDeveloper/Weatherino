//
//  MapListMapListHeader.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

final class MapListHeader: NSObject {


    //MARK: - Controller
    
    weak var controller: MapListViewController!


    //MARK: - Init
    
    init(root: MapListDelegate) {
        super.init()

        let presenter = MapListPresenter()
        let interactor = MapListInteractor()
        controller = moduleController()

        presenter.root = root
        presenter.controller = controller
        presenter.interactor = interactor

        controller.presenter = presenter
        interactor.presenter = presenter
    }
}


//MARK: - Public methods

extension MapListHeader {

    func currentController() -> UIViewController {
        return controller
    }
}


//MARK: - Private methods

private extension MapListHeader {
    
    func moduleController() -> MapListViewController {
        return moduleStoryboard().instantiateViewController(withIdentifier: "MapListViewController") as! MapListViewController
    }

    func moduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "MapList", bundle: nil)
    }
}


//MARK: - MapListInterface

extension MapListHeader: MapListInterface {

}
