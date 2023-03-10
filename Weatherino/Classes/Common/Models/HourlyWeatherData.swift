//
//  HourlyWeatherData.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 01.03.2023.
//

import RealmSwift

final class HourWeatherData: Object, Decodable {
    
    @Persisted var icon: String = "unknown"
    @Persisted var dt: Int = 0
    @Persisted var temp: Double = 0

    override init() { }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HourWeatherData.CodingKeys> = try decoder.container(keyedBy: HourWeatherData.CodingKeys.self)

        self.dt = try container.decode(Int.self, forKey: .dt)

        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.MainKey.self, forKey: .main)
        temp = try mainContainer.decode(Double.self, forKey: .temp)

        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let firstWeather = try? weatherContainer.nestedContainer(keyedBy: CodingKeys.WeatherKey.self)
        icon = (try? firstWeather?.decode(String.self, forKey: .icon)) ?? "unknown"
    }
    
    private enum CodingKeys: CodingKey {
        case dt
        case weather
        case main
        
        enum MainKey: CodingKey {
            case temp
        }

        enum WeatherKey: CodingKey {
            case icon
        }
    }

}

