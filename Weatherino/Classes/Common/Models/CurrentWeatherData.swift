
//  CurrentWeather.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 27.02.2023.
//

import RealmSwift

// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
final class CurrentWeatherData: Object, Decodable {

    @Persisted var icon: String = "unknown"
    @Persisted var currentTemp: Double = 0
    @Persisted var minTemp: Double = 0
    @Persisted var maxTemp: Double = 0
    
    override init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let mainContainer = try? container.nestedContainer(keyedBy: CodingKeys.MainKey.self, forKey: .main)
        currentTemp = (try? mainContainer?.decode(Double.self, forKey: .temp)) ?? -0
        minTemp = (try? mainContainer?.decode(Double.self, forKey: .temp_min)) ?? -0
        maxTemp = (try? mainContainer?.decode(Double.self, forKey: .temp_max)) ?? -0

        var weatherContainer = try? container.nestedUnkeyedContainer(forKey: .weather)
        let first = try? weatherContainer?.nestedContainer(keyedBy: CodingKeys.WeatherKey.self)
        icon = (try? first?.decode(String.self, forKey: .icon)) ?? "unknown"
    }

    init(icon: String, currentTemp: Double, minTemp: Double, maxTemp: Double) {
        self.icon = icon
        self.currentTemp = currentTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }


    //MARK: - Private

    private enum CodingKeys: CodingKey {
        case weather
        case main

        enum WeatherKey: CodingKey {
            case icon
        }
        
        enum MainKey: CodingKey {
            case temp
            case temp_min
            case temp_max
        }
    }
    
}
