//
//  MainCootrinator+MapListDelegate.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 01.03.2023.
//

import UIKit.UIViewController

extension MainCoordinator: MapListDelegate {
    
    func showMark(from vc: UIViewController, lat: Double, lon: Double) {
        guard let tabBar = currentVC as? TabBarViewController, let map = tabBar.pageViewController.viewControllers?.first as? MapViewController else {
            return
        }
        dismiss(viewController: vc)
        map.selectMarker(lat: lat, lon: lon)
    }
    
}
