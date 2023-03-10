//
//  MapMapInteractor.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import CoreLocation.CLLocation

final class MapInteractor: NSObject {


    //MARK: - Variables
    
    weak var presenter: MapInteractorDelegate?

    private lazy var locationService: LocationManager = AppDelegate.shared().getManager(LocationManager.self, caller: self)
    private lazy var weatherService: WeatherManager = AppDelegate.shared().getManager(WeatherManager.self, caller: self)
    
    func willDeinit() {
        AppDelegate.shared().unsbubscribeFromAllManagers(caller: self)
    }

}

//MARK: - MapInteractorInterface

extension MapInteractor: MapInteractorInterface {
    
    func updateUserLocation(completion: @escaping ((CLLocation) -> ())) {
        locationService.updateCurrentLocation(completion)
    }
    
    func getNearbyCities(for location: CLLocationCoordinate2D, completion: @escaping ((CitiesResponse) -> ())) {
        locationService.getNearbyCities(for: location, completion: completion)
    }
    
    func savePointLocation(for location: CLLocationCoordinate2D, completion: @escaping (() -> ())) {
        locationService.reverseGeocode(for: location, completion: completion)
    }
    
    func getWeatherData(for location: CLLocationCoordinate2D, completion: @escaping ((Result<CurrentWeatherData, ErrorModel>) -> ())) {
        weatherService.current(lat: location.latitude, lon: location.longitude, completion: completion)
    }
}

