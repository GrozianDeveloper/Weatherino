//
//  WeatherStorageManager.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 03.03.2023.
//

import RealmSwift

final class WeatherStorageManager {

    static let shared = WeatherStorageManager()
    private init() {
        if realm.isEmpty {
            removeAllData()
        }
    }

    private let realm = try! Realm()

    private(set) var centerLon: Double!
    private(set) var centerLat: Double!

    func setUserSelectedCenter(lat: Double, lon: Double) {
        self.centerLat = lat
        self.centerLon = lon
    }
}


//MARK: - Add

extension WeatherStorageManager {
    func addCityData(_ city: City) {
        if let first = first(lat: city.lat, lon: city.lon) {
            try! realm.write({
                first.setCity(city)
            })
        } else {
            let model = WeatherData(city)
            save(objects: model)
        }
    }
    
    func addCities(_ data: CitiesResponse) {
        data.cities.forEach { city in
            addCityData(city)
        }
    }
    
    func addCurrentData(_ data: CurrentWeatherData, lat: Double, lon: Double) {
        if let first = first(lat: lat, lon: lon) {
            try! realm.write {
                first.current = data
            }
        } else {
            let model = WeatherData(data, lat: lat, lon: lon)
            save(objects: model)
        }
    }
    
    func addHourlyData(_ data: HourlyWeatherDataResponse, lat: Double, lon: Double) {
        if let first = first(lat: lat, lon: lon) {
            try! realm.write {
                first.setHourly(data.list)
            }
        }
    }
    
    func save<T: Object> (objects: T, update: Bool = false) {
        do {
            try realm.write {
                if update {
                    realm.add(objects, update: .modified)
                } else {
                    realm.add(objects)
                }
            }
        } catch {
            print("Error occured on Save: ", error)
        }
    }
}

//MARK: - Remove

extension WeatherStorageManager {
    func removeAllData() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}


//MARK: - Copy

extension WeatherStorageManager {
    func copyStorage(using sorter: (WeatherData, WeatherData) -> Bool) -> [WeatherData] {
        let weatherData = Set(realm.objects(WeatherData.self))
        let notCorrectData = weatherData.filter { $0.name == "" }
        var isUpdateAreNeeded = false
        notCorrectData.forEach { model in
            if let first = weatherData.first(where: {
                $0.lat == model.lat && $0.lon == model.lon
            }) {
                if first.current == nil, model.current != nil {
                    first.setCurrent(model.current!)
                }
                if !first.hourly.isEmpty {
                    first.setHourly(model.hourly)
                }
            }
            try! realm.write {
                isUpdateAreNeeded = true
                realm.delete(model)
            }
        }
        return isUpdateAreNeeded ? realm.objects(WeatherData.self).sorted(by: sorter) : weatherData.sorted(by: sorter)
    }
}

//MARK: - Private Methods

private extension WeatherStorageManager {
    func first(lat: Double, lon: Double) -> WeatherData? {
        return realm.object(ofType: WeatherData.self, forPrimaryKey: "\(lat)")
    }
}
