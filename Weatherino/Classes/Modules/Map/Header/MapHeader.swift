//
//  MapMapHeader.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

final class MapHeader: NSObject {


    //MARK: - Controller
    
    weak var controller: MapViewController!


    //MARK: - Init
    
    init(root: MapDelegate) {
        super.init()

        let presenter = MapPresenter()
        let interactor = MapInteractor()
        controller = moduleController()

        presenter.root = root
        presenter.controller = controller
        presenter.interactor = interactor

        controller.presenter = presenter
        interactor.presenter = presenter
    }
}


//MARK: - Public methods

extension MapHeader {

    func currentController() -> UIViewController {
        return controller
    }
}


//MARK: - Private methods

private extension MapHeader {
    
    func moduleController() -> MapViewController {
        return moduleStoryboard().instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
    }

    func moduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Map", bundle: nil)
    }
}


//MARK: - MapInterface

extension MapHeader: MapInterface {

}
