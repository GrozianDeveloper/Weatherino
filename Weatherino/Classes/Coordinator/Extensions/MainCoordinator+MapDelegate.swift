//
//  MainCoordinator+MapDelegate.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 27.02.2023.
//

import UIKit.UIViewController

extension MainCoordinator: MapDelegate {
    
    func showMaplist(from vc: UIViewController?) {
        let controller = MapListHeader(root: self).currentController()
        if let presentationController = controller.presentationController as? UISheetPresentationController {
            presentationController.prefersGrabberVisible = true
            presentationController.detents = [.medium(), .large()]
        }

        vc?.present(controller, animated: true)
    }
    
}
