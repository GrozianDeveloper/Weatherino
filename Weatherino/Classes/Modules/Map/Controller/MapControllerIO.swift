//
//  MapMapControllerIO.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import CoreLocation.CLLocation

protocol MapControllerInterface: AnyObject {
    func currentLocationUpdated(location: CLLocation)

    func didCollectWeatherDataForCities()
}

protocol MapControllerDelegate: AnyObject {
    func didReadyToWork()
    
    func getCurrentData(coordinate: CLLocationCoordinate2D) -> CurrentWeatherData?
    func getCurrentData(for location: CLLocationCoordinate2D, completion: @escaping ((Result<CurrentWeatherData, ErrorModel>) -> ()))
    func getNearbyCities(for location: CLLocationCoordinate2D, completion: @escaping ((CitiesResponse) -> ()))
    func saveUserPinLocation(for location: CLLocationCoordinate2D)
    func removeAllData()
    func setUserSelectedCenter(coordinate: CLLocationCoordinate2D)
}
