//
//  AppDelegate.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 22.02.2023.
//

import UIKit
import GoogleMaps.GMSServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var activeManagers: [Manager] = []
    
}


//MARK: - UIApplicationDelegate
extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(LocationManager.getGoogleApiKey())
        GMSServices.setMetalRendererEnabled(true)

        let window = createWindow()
        let coordinator = MainCoordinator.shared
        coordinator.startWithWindow(window)

        return true
    }
    
}


//MARK: - Manager Methods

extension AppDelegate {
    
    func activeManagersIdentifiers() -> [String] {
        activeManagers.map(\.identifier)
    }

    func getManager<T: Manager>(_ manager: T.Type, caller: AnyObject) -> T {
        guard Thread.isMainThread else {
            fatalError("Must be called on main thread")
        }
        print("Same", activeManagers.filter { $0.identifier == manager.identifier }.count)
        if let manager = activeManagers.first(where: { $0.identifier == manager.identifier }) {
            manager.subscribe(caller)
            print(" ")
            print("Existed Instance", manager.identifier)
            print(manager.identifier)
            let same = activeManagers.filter { $0.identifier == manager.identifier }
            same.forEach {
                print($0.identifier)
            }
            print("Total:", "\n", activeManagersIdentifiers(), "\n", activeManagers.count)
            return manager as! T
        } else {
            let instance = manager.init(referenceTo: caller)
            activeManagers.append(instance)
            print(" ")
            print("New Instance", instance.identifier)
            print(manager.identifier)
            let same = activeManagers.filter { $0.identifier == manager.identifier }
            same.forEach {
                print($0.identifier)
            }
            print("Total:", "\n", activeManagersIdentifiers(), "\n", activeManagers.count)
            return instance
        }
    }

    
    func removeManager(_ manager: Manager, caller: AnyObject) {
        guard Thread.isMainThread else {
            fatalError("Must be called on main thread")
        }
        guard let manager = activeManagers.enumerated().first(where: { $0.element === manager }) else {
            return
        }
        if manager.element.subscribersCount == 0 {
            activeManagers.remove(at: manager.offset)
            manager.element.willDeinit()
            print("Manager removed", manager.element.identifier)
        } else {
            manager.element.unsubscribe(caller)
        }
    }
    
    func unsbubscribeFromAllManagers(caller: AnyObject) {
        activeManagers.forEach { $0.unsubscribe(caller) }
    }

}


//MARK: - Static Methods

extension AppDelegate {
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}

//MARK: - Private methods

private extension AppDelegate {
    
    func createWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.black
        window.makeKeyAndVisible()
        return window
    }
    
}
