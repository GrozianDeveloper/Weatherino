//
//  Theme.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 28.02.2023.
//

import UIKit.UIInterface

//MARK: - Main

final class ThemeManager {

    
    //MARK: - Signleton
    
    static let shared = ThemeManager()
    private init() {
        activeTheme = Theme(rawValue: Int8(UserDefaults.standard.integer(forKey: "appTheme"))) ?? .device
    }

    fileprivate let themeWindow = ThemeManager.ThemeWindow()

    var activeTheme: Theme {
        didSet {
            updateInterfaceStyle()
        }
    }

    weak var deviceThemeDelegate: DeviceThemeHandler? = nil
}


//MARK: - Public Methods

extension ThemeManager {
    
    /// - Returns: isLight
    func currentDeviceTheme() -> Bool {
        themeWindow.traitCollection.userInterfaceStyle == .light
    }

    func weatherIconFor(name: String) -> UIImage {
        var _name: String = name
        if name.count == 3 {
            _name.removeLast()
        }

        let style = activeTheme.userInterfaceStyle == .light ? "d" : "n"
        func image(name: String) -> UIImage? { UIImage(named: name + style) }
        return image(name: _name) ?? image(name: "unknown")!
    }

    func save() {
        UserDefaults.standard.set(Int8(activeTheme.rawValue), forKey: "appTheme")
    }

}


//MARK: - Fileprivate

fileprivate extension ThemeManager {
    
    func updateInterfaceStyle() {
        let windows = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where:  { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .filter { !($0 is ThemeWindow) }

        UIView.animate(withDuration: 0.2) {
            windows?.forEach {
                $0.overrideUserInterfaceStyle = self.activeTheme.userInterfaceStyle
            }
        }
    }
    
}


//MARK: - Theme

extension ThemeManager {
    enum Theme: Int8 {
        case device
        case light
        case dark
        
        var userInterfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .device:
                return ThemeManager.shared.themeWindow.traitCollection.userInterfaceStyle
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }
}


// MARK: - ThemeWindow

fileprivate extension ThemeManager {
    
    final class ThemeWindow: UIWindow {
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            guard self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            let manager = ThemeManager.shared
            manager.deviceThemeDelegate?.deviceThemeDidChange(isLight: traitCollection.userInterfaceStyle == .light)
            guard manager.activeTheme == .device else { return }
            manager.updateInterfaceStyle()
        }
    }
    
}

protocol DeviceThemeHandler: NSObject {
    func deviceThemeDidChange(isLight: Bool)
}
