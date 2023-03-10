//
//  WeatherTableViewCell.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 01.03.2023.
//

import UIKit.UITableViewCell

final class WeatherTableCell: UITableViewCell, Nibable {

    
    //MARK: - IBOutlet

    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherView: WeatherView!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
}


//MARK: - Public Methods

extension WeatherTableCell {
    
    func setCollectionViewHeight(_ height: CGFloat) {
        collectionViewHeight.constant = height
        layoutIfNeeded()
    }

    func setIndicatorHeight(_ height: CGFloat) {
        indicatorHeight.constant = height
        layoutIfNeeded()
    }

    func configure(name: String, data: CurrentWeatherData?, dataSource: UICollectionViewDataSource) {
        cityNameLabel.text = name
        weatherView.configure(with: data)
    }

    func setupCollectionView(tag: Int, dataSource: UICollectionViewDataSource?, delegate: UICollectionViewDelegate?, cellType: Nibable.Type) {
        collectionView.tag = tag
        collectionView.register(cellType)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }

}
