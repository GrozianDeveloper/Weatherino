//
//  CitiesResponse.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 05.03.2023.
//

import Foundation.NSDecimalNumber

final class CitiesResponse: Decodable {
    private(set) var cities: [City] = []
    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Main.self)
        let responceContainer = try container.nestedContainer(keyedBy: Main.Responce.self, forKey: .response)
        let collectionContainer = try responceContainer.nestedContainer(keyedBy: Main.Responce.GeoObjectCollectionKey.self, forKey: .GeoObjectCollection)
        var featuresContainer = try collectionContainer.nestedUnkeyedContainer(forKey: .featureMember)

        while !featuresContainer.isAtEnd {
            let featureContainer = try featuresContainer.nestedContainer(keyedBy: FeatureMember.self)
            let objectContainer = try featureContainer.nestedContainer(keyedBy: FeatureMember.GeoObject.self, forKey: .geoObject)

            let name = try objectContainer.decode(String.self, forKey: .name)
            
            let posContainer = try objectContainer.nestedContainer(keyedBy: FeatureMember.GeoObject.Point.self, forKey: .coodinates)
            let posString = try posContainer.decode(String.self, forKey: .pos).components(separatedBy: " ")
            let long = Double(truncating: NSDecimalNumber(string: posString[0]))
            let lat = Double(truncating: NSDecimalNumber(string: posString[1]))

            cities.append(City(name: name, lat: lat, lon: long))
        }
    }
    
    private enum Main: CodingKey {
        case response

        enum Responce: CodingKey {
            case GeoObjectCollection

            enum GeoObjectCollectionKey: CodingKey {
                case featureMember
            }
        }
    }
    

    private enum FeatureMember: String, CodingKey {
        case geoObject = "GeoObject"

        enum GeoObject: String, CodingKey {
            case name
            case coodinates = "Point"

            case metaDataProperty
            
            enum MetaData: String, CodingKey {
                case metaData = "GeocoderMetaData"

                enum GeocoderMetaData: CodingKey {
                    case kind
                }
            }

            enum Point: CodingKey {
                case pos
            }
        }
    }
    
}

