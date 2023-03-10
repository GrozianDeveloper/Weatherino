//
//  HourCell.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 06.03.2023.
//

import UIKit

final class HourCell: UICollectionViewCell, Nibable {

    
    //MARK: - IBOutlets

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!

    
    //MARK: - Private Propertys
    private var icon: String = "unknown"
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        iconView.image = ThemeManager.shared.weatherIconFor(name: icon)
    }
}


//MARK: - Public Methods

extension HourCell {
    
    func configure(time: String, icon: String, temp: String) {
        self.icon = icon
        timeLabel.text = time
        iconView.image = ThemeManager.shared.weatherIconFor(name: icon)
        tempLabel.text = temp
    }
    
}
