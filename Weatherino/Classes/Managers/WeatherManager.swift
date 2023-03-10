//
//  WeatherService.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 09.03.2023.
//

final class WeatherManager: Manager {
    
    private var currentDataRequestsInFlight: Set<Double> = []

    private lazy var networkManager: NetworkManager = AppDelegate.shared().getManager(NetworkManager.self, caller: self)

    required init(referenceTo object: AnyObject) {
        super.init(referenceTo: object)
        addAsSupportManager(networkManager)
    }
}


//MARK: - Current

extension WeatherManager {
    
    func current(lat: Double, lon: Double, completion: @escaping ((Result<CurrentWeatherData, ErrorModel>) -> ())) {
        networkManager.request(for: CurrentWeatherData.self, endpoint: .current(lat: lat, lon: lon)) { [weak self] result in
            guard let self = self else { return }
            self.currentDataRequestsInFlight.remove(lat)
            switch result {
            case .success(let response):
                WeatherStorageManager.shared.addCurrentData(response, lat: lat, lon: lon)
            case .failure(let error):
                print("GetWeatherData", error)
            }
            completion(result)
        }
    }
    
}


//MARK: - Hourly

extension WeatherManager {
    
    func getHourlyWeatherData(lat: Double, lon: Double, completion: @escaping (Result<HourlyWeatherDataResponse, ErrorModel>) -> ()) {
        networkManager.request(for: HourlyWeatherDataResponse.self, endpoint: .hourly(lat: lat, lon: lon)) { result in
            switch result {
            case .success(let response):
                WeatherStorageManager.shared.addHourlyData(response, lat: lat, lon: lon)
            case .failure(let error):
                print("GetHourlyWeatherData", error)
            }
            completion(result)
        }
    }
    
}
