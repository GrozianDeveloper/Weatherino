//
//  TabBarTabBarViewController.swift
//  Weatherino
//
//  Created by Weatherino on 03/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

extension TabBarViewController {
    private enum Tabs: Int, CaseIterable {
        case map
        case settings

        func image() -> UIImage? {
            switch self {
            case .map:
                return UIImage(named: "map.fill")
            case .settings:
                return UIImage(named: "gearshape.fill")
            }
        }

        func controller(coordinator: MainCoordinator) -> UIViewController {
            switch self {
            case .map:
                return MapHeader(root: coordinator).currentController()
            case .settings:
                return SettingsHeader(root: coordinator).currentController()
            }
        }
    }
}

final class TabBarViewController: UIViewController {

    
    //MARK: - Presenter

    var presenter: TabBarControllerDelegate?

    
    //MARK: - Outlets

    private(set) var pageViewController: UIPageViewController!
    @IBOutlet private weak var tabBar: UITabBar!
    @IBOutlet private weak var tabBarHeight: NSLayoutConstraint!
    @IBOutlet private weak var tabBarCenterX: NSLayoutConstraint!
    
    
    //MARK: - Override Propertys
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //MARK: - Private Propertys

    private var allControllers: [UIViewController] = []
    private var currentIndex: Int = 0
    
    
    //MARK: - Life Cycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? UIPageViewController {
            pageViewController = controller
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.delegate = self
        pageViewController.dataSource = self

        tabBar.delegate = self

        setup()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
}


//MARK: - Public methods

extension TabBarViewController {

}


//MARK: - Private methods

private extension TabBarViewController {

    func setup() {
        let coordinator = MainCoordinator.shared

        tabBar.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 28
        tabBar.tintColor = .label

        var tabs: [UITabBarItem] = []
        Tabs.allCases.forEach { tab in
            let tabItem = UITabBarItem(title: nil, image: tab.image(), tag: tab.rawValue)
            tabs.append(tabItem)
            allControllers.append(tab.controller(coordinator: coordinator))
        }
        tabBar.setItems(tabs, animated: false)
        tabBar.selectedItem = tabBar.items?.first
        pageViewController.setViewControllers([allControllers.first!], direction: .forward, animated: true)
    }
    
}


//MARK: - TabBarControllerInterface

extension TabBarViewController: TabBarControllerInterface {

}


//MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard currentIndex != item.tag else { return }
        
        let direction: UIPageViewController.NavigationDirection = currentIndex < item.tag ? .forward : .reverse
        currentIndex = item.tag
        pageViewController.setViewControllers([allControllers[currentIndex]], direction: direction, animated: true)
    }
}


// MARK: - UIPageViewControllerDelegate

extension TabBarViewController: UIPageViewControllerDelegate {
    
}


// MARK: - UIPageViewControllerDataSource

extension TabBarViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        allControllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard allControllers.indices.contains(currentIndex - 1) else { return nil }
        currentIndex -= 1
        tabBar.selectedItem = tabBar.items?[currentIndex]
        return allControllers[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard allControllers.indices.contains(currentIndex + 1) else { return nil }
        currentIndex += 1
        tabBar.selectedItem = tabBar.items?[currentIndex]
        return allControllers[currentIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let index = allControllers.firstIndex(where: { $0 == pageViewController.viewControllers?.first }), currentIndex != index else {
            return
        }
        currentIndex = index
        tabBar.selectedItem = tabBar.items?[currentIndex]
    }
    
}
