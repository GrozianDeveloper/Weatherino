//
//  Manager.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 08.03.2023.
//

import Foundation.NSObject

class Manager: NSObject, TypeIdentifidable {


    var identifier: String {
        var identifier = String(reflecting: Self.self)
        while identifier.contains(".") {
            identifier.removeFirst()
        }
        return identifier
    }


    //MARK: - Life Cycle
    
    private override init() { }
    /// Don't use this, use appDelegate.getManager
    required init(referenceTo object: AnyObject) {
        super.init()
        guard Thread.isMainThread else {
            fatalError("Must be on main thread")
        }
        self.subscribe(object)
        guard AppDelegate.shared().activeManagersIdentifiers().filter({ $0 == identifier }).count == 0 else {
            fatalError("instance all ready exist")
        }
    }
    
    func willDeinit() {
        guard subscribersCount == 0 else { return }
        supportManagers.forEach { $0.unsubscribe(self) }
        supportManagers = []
    }
    
    
    //MARK: - Subscribers

    /// All objects that uses this instance
    private var subscribers: [AnyObject] = []
    var subscribersCount: Int {
        return subscribers.count
    }
    
    func subscribe(_ object: AnyObject) {
        garanteeMainThread { [weak self] in
            guard let self = self else { return }
            guard !self.subscribers.contains(where: { $0 === object }) else {
                return
            }
            self.subscribers.insert(object, at: 0)
        }
    }
    
    func unsubscribe(_ object: AnyObject) {
        garanteeMainThread { [weak self] in
            guard let self = self else { return }
            self.subscribers.removeAll(where: { $0 === object })
            if self.subscribers.count == 0 {
                AppDelegate.shared().removeManager(self, caller: object)
            }
        }
    }
    
    
    //MARK: - SupportManagers

    /// Managers that this instance uses
    private var supportManagers: [Manager] = []
    func addAsSupportManager(_ manager: Manager) {
        supportManagers.insert(manager, at: 0)
    }

}
