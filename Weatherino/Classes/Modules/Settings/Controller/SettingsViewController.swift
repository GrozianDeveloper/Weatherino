//
//  SettingsSettingsViewController.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    
    //MARK: - Presenter

    var presenter: SettingsControllerDelegate?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var themeButtonsView: UIStackView!
    @IBOutlet weak var changeRootControllerButton: UIButton!
    
    
    //MARK: - Overrides Propertys
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    //MARK: - Overrides methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        setupThemeSetting()
        setupGestures()

        if MainCoordinator.shared.window.rootViewController is SettingsViewController {
            changeRootControllerButton.setTitle("Set Map Controllers", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Acitve Managers\n", AppDelegate.shared().activeManagersIdentifiers())
    }
    
    
    //MARK: - Actions
    
    @IBAction func changeThemeButtonDidTap(_ sender: UIButton) {
        if themeButtonsView.arrangedSubviews.contains(where: { $0.isHidden }) {
            // Show Button
            UIView.animate(withDuration: 0.6) {
                self.themeButtonsView.arrangedSubviews.forEach {
                    $0.isHidden = false
                    $0.alpha = 1
                }
            }
        } else {
            // Select
            let theme: ThemeManager.Theme
            switch sender.tag {
            case 0:
                theme = .light
            case 1:
                theme = .dark
            default:
                theme = .device
            }
            selectTheme(theme, tellToManager: true)
        }
    }

    @IBAction private func changeRootControllerButtonTaped(_ sender: Any) {
        if MainCoordinator.shared.window.rootViewController is SettingsViewController {
            MainCoordinator.shared.window.rootViewController = TabBarHeader(root: MainCoordinator.shared).currentController()
        } else {
            MainCoordinator.shared.window.rootViewController = SettingsHeader(root: MainCoordinator.shared).currentController()
            MainCoordinator.shared.dismiss(viewController: MainCoordinator.shared.currentVC)
        }
    }
    
    @objc private func tapGestureFired(_ gesture: UITapGestureRecognizer) {
        if !themeButtonsView.frame.contains(gesture.location(in: view)) {
            selectTheme(ThemeManager.shared.activeTheme, tellToManager: false)
        }
    }
}


//MARK: - Public methods

extension SettingsViewController {

}


//MARK: - Private methods

private extension SettingsViewController {

    func selectTheme(_ theme: ThemeManager.Theme, tellToManager: Bool) {
        UIView.animate(withDuration: 0.6) {
            let buttons = self.themeButtonsView.arrangedSubviews
            buttons.forEach {
                $0.isHidden = true
                $0.alpha = 0
            }
            let button: UIView
            switch theme {
            case .light:
                button = buttons[0]
            case .dark:
                button = buttons[1]
            case .device:
                button = buttons[2]
            }
            button.isHidden = false
            button.alpha = 1
        } completion: { _ in
            guard tellToManager else { return }
            let manager = ThemeManager.shared
            manager.activeTheme = theme
            manager.save()
        }
    }
    
    func setupThemeSetting() {
        ThemeManager.shared.deviceThemeDelegate = self
        deviceThemeDidChange(isLight: ThemeManager.shared.currentDeviceTheme())
        selectTheme(ThemeManager.shared.activeTheme, tellToManager: false)
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureFired))
        view.addGestureRecognizer(tap)
    }
    
}


//MARK: - SettingsControllerInterface

extension SettingsViewController: SettingsControllerInterface {

}


//MARK: - DeviceThemeHandler

extension SettingsViewController: DeviceThemeHandler {
    
    func deviceThemeDidChange(isLight: Bool) {
        themeButtonsView.arrangedSubviews[2].tintColor = isLight ? .white : .black
    }
    
}

