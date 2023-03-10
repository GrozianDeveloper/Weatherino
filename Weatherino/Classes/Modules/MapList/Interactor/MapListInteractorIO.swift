//
//  MapListMapListInteractorIO.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import Foundation

protocol MapListInteractorInterface: AnyObject {
    
    func getHourlyWeatherData(lat: Double, lon: Double, completion: @escaping (Result<HourlyWeatherDataResponse, ErrorModel>) -> ())
    
    func willDeinit()
    
}

protocol MapListInteractorDelegate: AnyObject {
    
}
