//
//  MapListMapListInteractor.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import Foundation.NSObject

final class MapListInteractor: NSObject {

    //MARK: - Variables
    
    weak var presenter: MapListInteractorDelegate?

    private lazy var weatherService: WeatherManager = AppDelegate.shared().getManager(WeatherManager.self, caller: self)
    
    func willDeinit() {
        AppDelegate.shared().unsbubscribeFromAllManagers(caller: self)
    }
}


//MARK: - MapListInteractorInterface

extension MapListInteractor: MapListInteractorInterface {
    
    func getHourlyWeatherData(lat: Double, lon: Double, completion: @escaping (Result<HourlyWeatherDataResponse, ErrorModel>) -> ()) {
        weatherService.getHourlyWeatherData(lat: lat, lon: lon, completion: completion)
    }
    
    
}
