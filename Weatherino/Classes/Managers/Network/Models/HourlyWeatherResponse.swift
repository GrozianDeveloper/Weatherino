//
//  HourlyWeatherResponce.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 05.03.2023.
//

// https://pro.openweathermap.org/data/2.5/forecast/hourly?lat={lat}&lon={lon}&units=standard&appid={API key}
final class HourlyWeatherDataResponse: Decodable {

    private(set) var list: [HourWeatherData] = []
}
