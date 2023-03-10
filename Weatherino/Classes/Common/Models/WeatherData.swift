//
//  WeatherData.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 04.03.2023.
//

import RealmSwift

final class WeatherData: Object {

    @Persisted var name: String = ""
    @Persisted var lat: Double = 256
    @Persisted var lon: Double = 256
    
    @Persisted var current: CurrentWeatherData? = nil
    @Persisted var hourly = List<HourWeatherData>()

    @Persisted(primaryKey: true)
    @objc var key: String = ""
    override static func primaryKey() -> String? {
        return "key"
    }
    
    override init() { }

    init(_ city: City) {
        key = "\(city.lat)"
        name = city.name
        lat = city.lat
        lon = city.lon
        super.init()
    }

    init(_ current: CurrentWeatherData, lat: Double, lon: Double) {
        key = "\(lat)"
        self.current = current
        self.lat = lat
        self.lon = lon
        super.init()
    }
    
    func setCity(_ city: City) {
        name = city.name
        lat = city.lat
        lon = city.lon
    }

    func setCurrent(_ current: CurrentWeatherData) {
        self.current = current
    }

    func setHourly(_ hourly: HourlyWeatherDataResponse) {
        hourly.list.forEach {
            self.hourly.append($0)
        }
    }
    func setHourly(_ array: [HourWeatherData]) {
        array.forEach {
            self.hourly.append($0)
        }
    }
    
    func setHourly(_ list: List<HourWeatherData>) {
        self.hourly = list
    }
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        lhs.lat == rhs.lat && lhs.lat == rhs.lat
    }
}
