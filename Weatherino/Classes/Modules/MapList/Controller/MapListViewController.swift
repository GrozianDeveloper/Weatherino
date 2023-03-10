//
//  MapListMapListViewController.swift
//  Weatherino
//
//  Created by Weatherino on 01/03/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit

final class MapListViewController: UIViewController {

    
    //MARK: - Presenter

    var presenter: MapListControllerDelegate?
    

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Private Propertys
    
    private let dateFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    private var dissmisButton: UIButton? = nil
    

    //MARK: - Overrides methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WeatherTableCell.self)
        tableView.register(WeatherHeader.self)
        dateFormatter.dateFormat = "hh"

        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        updateDissmisButtion()
        updateBackgroundColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBackgroundColor()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateDissmisButtion()
    }
    
}


//MARK: - Public methods

extension MapListViewController {

}


//MARK: - Private methods

private extension MapListViewController {
    
    func updateBackgroundColor() {
        tableView.backgroundColor = traitCollection.userInterfaceStyle == .light ? .secondarySystemBackground : .systemBackground
        view.backgroundColor = tableView.backgroundColor
    }

    func updateDissmisButtion() {
        if UIDevice.current.orientation.isLandscape {
            dissmisButton = UIButton(type: .roundedRect)
            dissmisButton?.clipsToBounds = true
            dissmisButton?.layer.cornerRadius = 4
            dissmisButton?.backgroundColor = .systemGray2
            dissmisButton?.addTarget(self, action: #selector(dissmisButtonDidTap), for: .touchUpInside)
            view.addSubview(dissmisButton!)
            dissmisButton?.translatesAutoresizingMaskIntoConstraints = false
            dissmisButton?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09160305344).isActive = true
            dissmisButton?.heightAnchor.constraint(equalTo: dissmisButton!.widthAnchor, multiplier: 0.1388888889).isActive = true
            dissmisButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
            dissmisButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            dissmisButton?.removeFromSuperview()
        }
    }

    @objc func dissmisButtonDidTap() {
        let coordinator = MainCoordinator.shared
        coordinator.dismiss(viewController: self)
    }
    
}


//MARK: - MapListControllerInterface

extension MapListViewController: MapListControllerInterface {
    
    func reloadCurrentList() {
        garanteeMainThread { [self] in
            self.tableView?.reloadData()
        }
    }
    
}


// MARK: - UITableViewDelegate

extension MapListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presenter?.showMarkerOnMap(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherTableCell else {
            return
        }
        func animate(_ block: @escaping (() -> ()), completion: @escaping ((Bool) -> ()) = { _ in }) {
            tableView.performBatchUpdates {
                UIView.animate(withDuration: 0.6, animations: block, completion: completion)
            }
        }
        func hide() {
            animate {
                cell.indicatorHeight.constant = 0
                cell.indicator.alpha = 0
                cell.setCollectionViewHeight(0)
                tableView.layoutIfNeeded()
            } completion: { _ in
                cell.indicator.isHidden = true
                cell.collectionView.isHidden = true
            }
        }
        func show() {
            cell.collectionView.isHidden = false
            animate {
                cell.collectionView.reloadData()
                cell.indicatorHeight.constant = 0
                cell.indicator.alpha = 0
                cell.setCollectionViewHeight(100)
                tableView.layoutIfNeeded()
            } completion: { _ in
                cell.indicator.isHidden = true
            }
        }

        guard cell.collectionView.isHidden else {
            hide()
            return
        }

        guard presenter?.hourlyCount(at: indexPath.row) == 0 else {
            show()
            return
        }
        cell.indicator.startAnimating()
        animate {
            cell.indicator.isHidden = false
        }
        presenter?.getHourlyWeatherData(at: indexPath.row, completion: show)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let data = presenter?.getUserSelectedData() else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherHeader.identifier) as! WeatherHeader
        header.configure(data)
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let count = presenter?.citiesCount() else { return nil }
        let label = UILabel()
        label.text = "Total: \(count)"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }
    
}


// MARK: - UITableViewDataSource

extension MapListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.citiesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableCell.identifier, for: indexPath) as! WeatherTableCell
        if let data = presenter?.getCurrentData(at: indexPath.row) {
            cell.configure(name: data.0, data: data.1, dataSource: self)
        }
        cell.setupCollectionView(tag: indexPath.row, dataSource: self, delegate: self, cellType: HourCell.self)
        cell.collectionView.isHidden = true
        cell.indicator.isHidden = true
        return cell
    }

}


//MARK: - CollectionViewDelegate

extension MapListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 100)
    }
    
}


//MARK: - UICollectionViewDataSource

extension MapListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.hourlyCount(at: collectionView.tag) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourCell.identifier, for: indexPath) as! HourCell
        if let data = presenter?.getHourlyWeatherData(at: indexPath.section, row: indexPath.row) {
            let date = Date(timeIntervalSince1970: TimeInterval(data.dt))
            let time = dateFormatter.string(from: date)
            let temp = numberFormatter.string(from: NSNumber(value: data.temp))! + "°"
            cell.configure(time: time, icon: data.icon, temp: temp)
        }
        return cell
    }
    
}
