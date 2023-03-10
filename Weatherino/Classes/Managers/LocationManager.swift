//
//  LocationManager.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 28.02.2023.
//

import CoreLocation.CLLocationManager

final class LocationManager: Manager {

    class func getGoogleApiKey() -> String {
        return "AIzaSyB3-j6cdWe7BCTw-aebhsMSVCP5tOkMYKI"
    }
    
    
    //MARK: - Private Propertys
    
    private let manager = CLLocationManager()
    private lazy var networkManager: NetworkManager = AppDelegate.shared().getManager(NetworkManager.self, caller: self)

    // Rostov Na Donu
    private let defaultLocation = CLLocation(latitude: 47.233334, longitude: 39.700001)
    private var currentLocationUpdated: ((CLLocation) -> ())?
    
    required init(referenceTo object: AnyObject) {
        super.init(referenceTo: object)
        manager.delegate = self
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        addAsSupportManager(networkManager)
    }
}


//MARK: - Public Methods

extension LocationManager {
    
    func updateCurrentLocation(_ completion: @escaping ((CLLocation) -> ())) {
        currentLocationUpdated = completion
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            completion(defaultLocation)
        }
    }

    func getNearbyCities(for location: CLLocationCoordinate2D, completion: @escaping ((CitiesResponse) -> ())) {
        networkManager.request(for: CitiesResponse.self, endpoint: .geocode(lat: location.latitude, lon: location.longitude, count: 50)) { result in
            switch result {
            case .success(let response):
                completion(response)
                WeatherStorageManager.shared.addCities(response)
            case .failure(let error):
                print("GetNearbyCities", error)
            }
        }
    }
    
    func reverseGeocode(for location: CLLocationCoordinate2D, completion: @escaping (() -> ())) {
        networkManager.request(for: CitiesResponse.self, endpoint: .geocode(lat: location.latitude, lon: location.longitude, count: 1)) { result in
            switch result {
            case .success(let response):
                if let city = response.cities.first {
                    WeatherStorageManager.shared.addCityData(city)
                }
            case .failure(let error):
                print("Reverse Location Error", error)
            }
            completion()
        }
    }
}


//MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            break
        default:
            currentLocationUpdated?(defaultLocation)
            currentLocationUpdated = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationUpdated?(!locations.isEmpty ? locations.last! : defaultLocation)
        currentLocationUpdated = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationUpdated?(defaultLocation)
        currentLocationUpdated = nil
    }
    
}
