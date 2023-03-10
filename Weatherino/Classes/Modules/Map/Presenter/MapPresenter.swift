//
//  MapMapPresenter.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import CoreLocation.CLLocation
import UIKit.UIView

final class MapPresenter: NSObject {


    //MARK: - Variables
    
    var interactor: MapInteractorInterface?
    weak var root: MapDelegate?
    weak var controller: MapControllerInterface?

    private let storage = WeatherStorageManager.shared

    private var weatherData: Set<WeatherData> = []
    private var allWeatherCount = 0
    private var allCitiesCount = 0
    
    deinit {
        interactor?.willDeinit()
    }
}


//MARK: - MapInterface

extension MapPresenter: MapInterface {
    
}


//MARK: - MapControllerDelegate

extension MapPresenter: MapControllerDelegate {

    func didReadyToWork() {
        interactor?.updateUserLocation(completion: { [weak controller] location in
            controller?.currentLocationUpdated(location: location)
        })
    }

    func getCurrentData(coordinate: CLLocationCoordinate2D) -> CurrentWeatherData? {
        return weatherData.first(where: {
            return $0.lat == coordinate.latitude && $0.lon == coordinate.longitude
        })?.current
    }
    
    func getCurrentData(for location: CLLocationCoordinate2D, completion: @escaping ((Result<CurrentWeatherData, ErrorModel>) -> ())) {
        interactor?.getWeatherData(for: location, completion: { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .success(let data):
                if let model = self.weatherData.first(where: { $0.lat == location.latitude && $0.lon == location.longitude }) {
                    model.setCurrent(data)
                } else {
                    let model = WeatherData()
                    model.setCity(.init(name: "\(location.latitude)", lat: location.latitude, lon: location.longitude))
                    self.weatherData.insert(model)
                }
            case .failure:
                break
            }
            completion($0)
        })
    }
    
    func getNearbyCities(for location: CLLocationCoordinate2D, completion: @escaping ((CitiesResponse) -> ())) {
        interactor?.getNearbyCities(for: location, completion: { [self] in
            self.allCitiesCount = $0.cities.count
            $0.cities.forEach { city in
                let model = WeatherData()
                model.setCity(city)
                self.weatherData.insert(model)
                self.getCurrentData(for: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon), completion: { [self] _ in
                    self.allWeatherCount += 1
                    if self.allWeatherCount == self.allCitiesCount {
                        self.controller?.didCollectWeatherDataForCities()
                    }
                })
            }
            completion($0)
        })
    }
    
    func saveUserPinLocation(for location: CLLocationCoordinate2D) {
        interactor?.savePointLocation(for: location, completion: { [self] in
            self.allWeatherCount += 1
        })
    }

    func removeAllData() {
        guard !weatherData.isEmpty else { return }
        weatherData = []
        allWeatherCount = 0
        storage.removeAllData()
    }

    func setUserSelectedCenter(coordinate: CLLocationCoordinate2D) {
        storage.setUserSelectedCenter(lat: coordinate.latitude, lon: coordinate.longitude)
    }
}


//MARK: - MapInteractorDelegate

extension MapPresenter: MapInteractorDelegate {
    
}
