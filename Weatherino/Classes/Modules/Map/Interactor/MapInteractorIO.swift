//
//  MapMapInteractorIO.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import CoreLocation.CLLocation

protocol MapInteractorInterface: AnyObject {
    
    func updateUserLocation(completion: @escaping ((CLLocation) -> ()))
    func getNearbyCities(for location: CLLocationCoordinate2D, completion: @escaping ((CitiesResponse) -> ()))
    func savePointLocation(for location: CLLocationCoordinate2D, completion: @escaping (() -> ()))

    func getWeatherData(for location: CLLocationCoordinate2D, completion: @escaping ((Result<CurrentWeatherData, ErrorModel>) -> ()))
    
    func willDeinit()
}

protocol MapInteractorDelegate: AnyObject {
    
}
