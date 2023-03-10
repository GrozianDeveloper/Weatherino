//
//  WeatherView.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 27.02.2023.
//

import UIKit.UIView

final class WeatherView: UIStackView {


    
    //MARK: - Private Properties

    private let imageView = UIImageView()

    private let maxLabel = UILabel()
    private let currentLabel = UILabel()
    private let minLabel = UILabel()

    private var lightModeColor: UIColor?
    private var darkModeColor: UIColor?

    private var icon: String = "unknown"


    //MARK: - Initializers

    init(frame: CGRect = .zero, data: CurrentWeatherData) {
        super.init(frame: frame)
        setup()
        configure(with: data)
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }


    // MARK: - Override

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        UIView.transition(with: imageView, duration: 0.2, animations: {
            self.imageView.image = ThemeManager.shared.weatherIconFor(name: self.icon)
        })
        if traitCollection.userInterfaceStyle == .light, lightModeColor != nil {
            backgroundColor = lightModeColor
        } else if traitCollection.userInterfaceStyle == .dark, darkModeColor != nil {
            backgroundColor = darkModeColor
        }
    }
    
}


//MARK: - Public Methods

extension WeatherView {
    
    func configure(with data: CurrentWeatherData?) {
        icon = data?.icon ?? "unknown"
        imageView.image = ThemeManager.shared.weatherIconFor(name: icon)
        currentLabel.text = data != nil ? "\(data!.currentTemp)" : "-"

        if data != nil, (data?.currentTemp == data?.maxTemp && data?.currentTemp == data?.minTemp) {
            directionalLayoutMargins = .zero
            distribution = .equalCentering
            maxLabel.isHidden = true
            minLabel.isHidden = true
        } else {
            directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 0, trailing: 4)
            distribution = .fillEqually
            maxLabel.text = data != nil ? "\(data!.maxTemp)" : "-"
            minLabel.text = data != nil ? "\(data!.minTemp)" : "-"
            maxLabel.isHidden = false
            minLabel.isHidden = false
        }
    }
    
    func setStyleColors(light: UIColor, dark: UIColor) {
        lightModeColor = light
        darkModeColor = dark
        backgroundColor = traitCollection.userInterfaceStyle == .light ? light : dark
    }
    
}


//MARK: - Private Methods

private extension WeatherView {
    
    private func setup() {
        axis = .horizontal
        distribution = .equalCentering

        imageView.contentMode = .scaleAspectFit
        distribution = .equalCentering
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(imageView)
        addArrangedSubview(currentLabel)

        let labelViews = UIStackView(arrangedSubviews: [maxLabel, minLabel])
        labelViews.axis = .vertical
        labelViews.distribution = .fillProportionally
        addArrangedSubview(labelViews)

        func setupLabel(_ label: UILabel, color: UIColor, size: CGFloat) {
            label.textAlignment = .center
            label.textColor = color
            label.font = .systemFont(ofSize: size)
        }

        setupLabel(currentLabel, color: .label, size: 16)
        setupLabel(maxLabel, color: .systemYellow, size: 14)
        setupLabel(minLabel, color: .systemBlue, size: 14)
    }
    
}
