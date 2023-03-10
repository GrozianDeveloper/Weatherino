//
//  MapListMapListControllerIO.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

protocol MapListControllerInterface: AnyObject {
    
    func reloadCurrentList()
    
}

protocol MapListControllerDelegate: AnyObject {

    // TableView Delegate
    func showMarkerOnMap(at index: Int)
    /// For Header
    /// - Returns: Name, CurrentData, Max, Current, Min
    func getUserSelectedData() -> MapListPresenter.UserCreatedPinData?
    
    // TableView Data Source
    func citiesCount() -> Int
    func getCurrentData(at index: Int) -> (String, CurrentWeatherData?)

    // CollectionView Data Source
    func hourlyCount(at index: Int) -> Int?
    func getHourlyWeatherData(at index: Int, completion: @escaping (() -> ()))
    func getHourlyWeatherData(at index: Int, row: Int) -> HourWeatherData?
    
}
