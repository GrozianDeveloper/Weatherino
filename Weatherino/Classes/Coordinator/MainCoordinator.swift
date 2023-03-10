//
//  MainController.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 22.02.2023.
//

import UIKit

protocol Navigable: AnyObject {
    func dismiss(viewController: UIViewController?, animated: Bool)
    func pop(viewController: UIViewController?)
    func present(presentingViewController: UIViewController?, _ viewControllerToPresent: UIViewController?, animated: Bool)
}

final class MainCoordinator {

    static let shared = MainCoordinator()
    private init() { }
    
    private let themeManager = ThemeManager.shared
    private(set) var window: UIWindow!
    private(set) weak var currentVC: UIViewController!

    func startWithWindow(_ window: UIWindow) {
        self.window = window
        self.window.overrideUserInterfaceStyle = themeManager.activeTheme.userInterfaceStyle
        self.window.rootViewController = TabBarHeader(root: self).currentController()
        currentVC = self.window.rootViewController
    }

    func pop(viewController: UIViewController?) {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func dismiss(viewController: UIViewController?, animated: Bool = true) {
        viewController?.dismiss(animated: animated)
    }
    
    func present(presentingViewController: UIViewController?, _ viewControllerToPresent: UIViewController?, animated: Bool = true) {
        guard let viewControllerToPresent else { return }
        presentingViewController?.present(viewControllerToPresent, animated: animated)
    }
}
