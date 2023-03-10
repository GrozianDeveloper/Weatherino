//
//  WeatherHeader.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 04.03.2023.
//

import UIKit.UITableViewHeaderFooterView

final class WeatherHeader: UITableViewHeaderFooterView, Nibable {

    
    //MARK: - IBOutlet

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var averageStackView: UIStackView!
    @IBOutlet private weak var avgHighest: UILabel!
    @IBOutlet private weak var avgCurrent: UILabel!
    @IBOutlet private weak var avgMin: UILabel!

    @IBOutlet private weak var locationStackView: UIStackView!
    @IBOutlet private weak var latLabel: UILabel!
    @IBOutlet private weak var lonLabel: UILabel!
    @IBOutlet private weak var locationHighest: UILabel!
    @IBOutlet private weak var locationCurrent: UILabel!
    @IBOutlet private weak var locationMin: UILabel!

    
    //MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        locationStackView.layer.cornerRadius = 10
        averageStackView.layer.cornerRadius = 10
        nameLabel.layer.cornerRadius = 5
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setBackground()
        }
    }
}


//MARK: - Public Methods

extension WeatherHeader {
    
    func configure(_ data: MapListPresenter.UserCreatedPinData) {
        setBackground()

        nameLabel.text = data.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        func string(_ double: Double) -> String {
            formatter.string(from: NSNumber(value: double))! + "°"
        }

        self.avgHighest.text = string(data.avgHighest)
        self.avgCurrent.text = string(data.avgCurrent)
        self.avgMin.text = string(data.avgMin)

        formatter.maximumFractionDigits = 4
        self.latLabel.text = string(data.lat)
        self.lonLabel.text = string(data.lon)

        formatter.maximumFractionDigits = 2
        self.locationHighest.text = string(data.maxTemp)
        self.locationCurrent.text = string(data.currentTemp)
        self.locationMin.text = string(data.minTemp)
    }
    
}


//MARK: - Private Methods

extension WeatherHeader {
    
    private func setBackground() {
        let backgroundColor: UIColor = traitCollection.userInterfaceStyle == .light ? .systemBackground : .secondarySystemBackground
        locationStackView.backgroundColor = backgroundColor
        averageStackView.backgroundColor = backgroundColor
        nameLabel.backgroundColor = backgroundColor
    }
    
}
