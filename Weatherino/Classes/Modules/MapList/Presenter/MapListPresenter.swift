//
//  MapListMapListPresenter.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import CoreLocation.CLLocation
import UIKit.UIViewController

final class MapListPresenter: NSObject {


    //MARK: - Variables
    
    var interactor: MapListInteractorInterface?
    weak var root: MapListDelegate?
    weak var controller: MapListControllerInterface?

    private let storage = WeatherStorageManager.shared

    private var weatherData: [WeatherData] = []

    private var avgHighest: Double = 0
    private var avgCurrent: Double = 0
    private var avgMin: Double = 0

    //MARK: - Init

    override init() {
        super.init()
        
        let center = CLLocation(latitude: storage.centerLat,
                                longitude: storage.centerLon)
        func closest(lhs: WeatherData, rhs: WeatherData) -> Bool {
            let lhsC = CLLocation(latitude: lhs.lat,
                                  longitude: lhs.lon)
            let rhsC = CLLocation(latitude: rhs.lat,
                                  longitude: rhs.lon)
            return center.distance(from: lhsC) < center.distance(from: rhsC)
        }
        weatherData = storage.copyStorage(using: closest)
        
        guard !weatherData.isEmpty else { return }
        weatherData.forEach { data in
            avgHighest += data.current?.maxTemp ?? 0
            avgCurrent += data.current?.currentTemp ?? 0
            avgMin += data.current?.minTemp ?? 0
        }
        avgHighest /= Double(weatherData.count)
        avgCurrent /= Double(weatherData.count)
        avgMin /= Double(weatherData.count)

        controller?.reloadCurrentList()
    }
}


//MARK: - MapListInterface

extension MapListPresenter: MapListInterface {
    
    
}


//MARK: - MapListControllerDelegate

extension MapListPresenter: MapListControllerDelegate {
    
    /// - Returns: Name, CurrentData, Max, Current, Min
    func getUserSelectedData() -> MapListPresenter.UserCreatedPinData? {
        return MapListPresenter.UserCreatedPinData(
            name: weatherData.first?.name ?? "Red Pin",
            lat: weatherData.first?.lat ?? 256,
            lon: weatherData.first?.lon ?? 256,
            currentTemp: weatherData.first?.current?.currentTemp ?? -0,
            minTemp: weatherData.first?.current?.minTemp ?? -0,
            maxTemp: weatherData.first?.current?.maxTemp ?? -0,
            avgHighest: avgHighest,
            avgCurrent: avgCurrent,
            avgMin: avgMin)
    }

    func showMarkerOnMap(at index: Int) {
        guard let vc = controller as? UIViewController else { return }
        // Get hourly data
        let data = weatherData[index + 1]
        root?.showMark(from: vc, lat: data.lat, lon: data.lon)
    }

    func citiesCount() -> Int {
        weatherData.count - 1
    }
    
    func getCurrentData(at index: Int) -> (String, CurrentWeatherData?) {
        let data = weatherData[index + 1]
        return (data.name, data.current)
    }
    
    func hourlyCount(at index: Int) -> Int? {
        return weatherData[index + 1].hourly.count
    }
    
    func getHourlyWeatherData(at index: Int, completion: @escaping (() -> ())) {
        let data = weatherData[index + 1]
        interactor?.getHourlyWeatherData(lat: data.lat, lon: data.lon, completion: { _ in
            completion()
        })
    }

    func getHourlyWeatherData(at index: Int, row: Int) -> HourWeatherData? {
        weatherData[index + 1].hourly[row]
    }
    
}


//MARK: - MapListInteractorDelegate

extension MapListPresenter: MapListInteractorDelegate {

}
