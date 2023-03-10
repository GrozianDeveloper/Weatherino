//
//  LoadableButton.swift
//  Weatherino
//
//  Created by Bogdan Grozian on 05.03.2023.
//

import UIKit.UIButton

final class LoadableButton: UIButton {
    private var indicator: UIActivityIndicatorView! = nil
}


//MARK: - Public Methods

extension LoadableButton {
    
    func startLoading() {
        guard indicator == nil else { return }
        indicator = UIActivityIndicatorView(frame: bounds)
        UIView.transition(with: self, duration: 0.2) {
            self.addSubview(self.indicator)
            self.indicator.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.indicator.startAnimating()
            let isBackCustom = self.backgroundColor != nil && self.backgroundColor != .clear
            self.indicator.backgroundColor = isBackCustom ? self.backgroundColor : .systemBackground
        }
    }

    func stopLoading() {
        UIView.transition(with: self, duration: 0.2) {
            self.indicator.removeFromSuperview()
        } completion: { _ in
            self.indicator = nil
        }
    }

}
