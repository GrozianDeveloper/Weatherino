//
//  Endpoint.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 06.03.2023.
//

import Alamofire

struct EndPoint {
    
    private let host: String
    private let path: String
    private let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    init(host: String, path: String, queryItems: [URLQueryItem]) {
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }

    init(_ host: Host, _ path: Base, queryItems: [URLQueryItem]) {
        self.host = host.rawValue
        self.path = path.rawValue
        self.queryItems = path.sharedQueries + queryItems
    }
    
}


//MARK: - URLConvertible

extension EndPoint: URLConvertible {
    func asURL() throws -> URL {
        if let url = url {
            return url
        } else {
            throw ErrorModel(ErrorKey.parameterEncodingFailed.rawValue)
        }
    }
}


//MARK: - Current

extension EndPoint {
    static func current(lat: Double, lon: Double) -> EndPoint {
        return EndPoint(
            .weather,
            .currentWeather,
            queryItems: weatherCoords(lat: lat, lon: lon)
        )
    }
}


//MARK: - Hourly

extension EndPoint {
    
    static func hourly(lat: Double, lon: Double) -> EndPoint {
        return EndPoint(
            .weather,
            .forecast,
            queryItems: [
                URLQueryItem(name: "cnt", value: "48")
            ] + weatherCoords(lat: lat, lon: lon)
        )
    }
}

// MARK: - Geocode

extension EndPoint {

    static func geocode(lat: Double, lon: Double, count: Int) -> EndPoint {
        return EndPoint(
            .yandexMap,
            .geocode,
            queryItems: [
                URLQueryItem(name: "geocode",
                             value: "\(lon),\(lat)"),
                URLQueryItem(name: "result",
                             value: "\(count)")
            ]
        )
    }
}


//MARK: - Host

extension EndPoint {
    enum Host: String {
        case yandexMap = "geocode-maps.yandex.ru"
        case weather = "api.openweathermap.org"
    }
}


//MARK: - Base

extension EndPoint {
    enum Base: String {
        case geocode = "/1.x/"
        case currentWeather = "/data/2.5/weather"
        case forecast = "/data/2.5/forecast"
        
        var sharedQueries: [URLQueryItem] {
            switch self {
            case .geocode:
                return [
                    URLQueryItem(name: "apikey",
                                 value: "b48c4003-53fc-4019-9d2d-a12d85f4c136"),
                    URLQueryItem(name: "format",
                                 value: "json"),
                    URLQueryItem(name: "lang",
                                 value: "en_US"),
                    URLQueryItem(name: "type",
                                 value: "geo"),
                    URLQueryItem(name: "kind",
                                 value: "locality")
                ]
            case .forecast, .currentWeather:
                return [
                    URLQueryItem(name: "appid",
                                 value: "37510b5b19ba4d93d094cb3bd0a2cfd8"),
                    URLQueryItem(name: "units",
                                 value: "metric")
                ]
            }
        }
    }
}


//MARK: - Private Methods

private extension EndPoint {
    static func weatherCoords(lat: Double, lon: Double) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "lat",
                         value: "\(lat)"),
            URLQueryItem(name: "lon",
                         value: "\(lon)")
        ]
    }
}
