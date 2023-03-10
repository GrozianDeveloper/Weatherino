//
//  MapMapViewController.swift
//  Weatherino
//
//  Created by Weatherino on 27/02/2023.
//  Copyright 2023 Mine. All rights reserved.
//

import UIKit
import GoogleMaps.GMSMapView

final class MapViewController: UIViewController {


    //MARK: - Presenter

    var presenter: MapControllerDelegate?


    //MARK: - Outlets

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var toggleListVisabilityButton: LoadableButton!
    @IBOutlet weak var myLocattionButton: UIButton!

    
    //MARK: - Override Propertys
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    
    //MARK: - Private Propertys
    
    private var markers: [GMSMarker] = []
    private weak var userCreatedMarker: GMSMarker! = nil
    private weak var circle: GMSCircle! = nil
    private weak var markerInfoView: UIView? = nil
    private let userMarkerColor = UIColor.red
    private let secondarySelectedColor = UIColor.yellow
    private let notSelectedColor = UIColor.green
    
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didReadyToWork()
        setupMapView()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapView.selectedMarker != nil, markerInfoView == nil {
            let marker = mapView.selectedMarker
            mapView.selectedMarker = nil
            mapView.selectedMarker = marker
        }
    }
    
    //MARK: - Override Methods


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateMapTheme()
        }
    }

    
    // MARK: - Actions

    @IBAction private func toggleListVisability(_ sender: UIButton) {
        let coordinator = MainCoordinator.shared
        coordinator.showMaplist(from: self)
    }
    
    
    @IBAction private func goToMyLocation(_ sender: Any) {
        guard let coordinates = mapView.myLocation?.coordinate else { return }
        if mapView.selectedMarker?.position.latitude != coordinates.latitude && mapView.selectedMarker?.position.latitude != coordinates.longitude {
            createMarkers(on: coordinates)
        } else {
            animateToCoords(location: coordinates)
        }
    }
    
}


//MARK: - Public methods

extension MapViewController {

    func selectMarker(lat: Double, lon: Double) {
        guard let marker = markers.first(where: { $0.position.latitude == lat && $0.position.longitude == lon }) else {
            return
        }
        if userCreatedMarker != marker {
            marker.tracksViewChanges = true
            marker.icon = GMSMarker.markerImage(with: secondarySelectedColor)
            marker.tracksViewChanges = false
        }
        if userCreatedMarker != mapView.selectedMarker {
            marker.tracksViewChanges = true
            mapView.selectedMarker?.icon = GMSMarker.markerImage(with: notSelectedColor)
            marker.tracksViewChanges = false
        }
        mapView.animate(toLocation: marker.position)
        mapView.selectedMarker = marker
    }
    
}


//MARK: - Private methods

private extension MapViewController {
    
    func setupMapView() {
        mapView.delegate = self
        
        if mapView.subviews.indices.contains(1), let settingsViews = mapView.subviews[1].subviews.first?.subviews, settingsViews.indices.contains(3) {
            // Hide Go To Google Site button
            /// By Terms & Conditions it's not valid, but because it's just test project, why not hide it?
            settingsViews[3].isHidden = true
        }

        updateMapTheme()

        myLocattionButton.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        myLocattionButton.layer.cornerRadius = 28
        toggleListVisabilityButton.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        toggleListVisabilityButton.layer.cornerRadius = 28
    }

    func updateMapTheme() {
        let name = traitCollection.userInterfaceStyle == .dark ? "mapDark" : "mapLight"
        let styleURL = Bundle.main.url(forResource: name, withExtension: "json")!
        do {
            let style = try GMSMapStyle(contentsOfFileURL: styleURL)
            var myLocationButton: UIView?
            if mapView.subviews.indices.contains(1), let settingsViews = mapView.subviews[1].subviews.first?.subviews, settingsViews.indices.contains(2) {
                myLocationButton = settingsViews[2]
            } else {
                myLocationButton = nil
            }
            mapView.selectedMarker?.tracksInfoWindowChanges = true
            UIView.transition(with: mapView, duration: 0.2) {
                self.mapView.mapStyle = style
            }
            UIView.animate(withDuration: 0.2) {
                myLocationButton?.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? .lightGray : .white
            } completion: { _ in
                self.mapView.selectedMarker?.tracksInfoWindowChanges = false
            }
        } catch {
            print(error)
        }
    }

    func createMarkers(on coordinate: CLLocationCoordinate2D) {
        guard userCreatedMarker?.position.longitude != coordinate.longitude, userCreatedMarker?.position.latitude != coordinate.latitude else {
            return
        }
        presenter?.setUserSelectedCenter(coordinate: coordinate)

        markers.forEach { hideMarker($0) }
        presenter?.removeAllData()
        self.showMarker(coordinate: coordinate, showInfo: true, isUserCreated: true)
        
        toggleListVisabilityButton.startLoading()
        presenter?.saveUserPinLocation(for: coordinate)
        presenter?.getNearbyCities(for: coordinate, completion: { cities in
            guard !cities.cities.isEmpty else { return }
            garanteeMainThread { [weak self] in
                guard let self = self else { return }
                let center = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                var maxDistance: Double = 0
                cities.cities.forEach {
                    let coords = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
                    let location = CLLocation(latitude: $0.lat, longitude: $0.lon)
                    let distance = center.distance(from: location)
                    if distance > maxDistance {
                        maxDistance = distance
                    }
                    
                    self.showMarker(coordinate: coords)
                }

                self.circle?.map = nil
                let distance = maxDistance + 1500
                let circle = GMSCircle(position: coordinate, radius: distance)
                circle.title = "Nearby Cities"
                circle.strokeColor = .gray
                circle.isTappable = true
                self.circle = circle
                circle.map = self.mapView
                self.animateToCoords(location: coordinate)
            }
        })
    }

    func showMarker(coordinate: CLLocationCoordinate2D, showInfo: Bool = false, isUserCreated: Bool = false) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = mapView
        marker.icon = GMSMarker.markerImage(with: isUserCreated ? userMarkerColor : notSelectedColor)
        if showInfo {
            mapView.selectedMarker = marker
            marker.tracksInfoWindowChanges = true
        }
        if isUserCreated {
            userCreatedMarker = marker
        }
        markers.append(marker)
    }

    func hideMarker(_ marker: GMSMarker) {
        marker.map = nil
        markers.remove(marker)
    }

    func animateToCoords(location: CLLocationCoordinate2D) {
        mapView.animate(toLocation: location)
        let zoom = Float(11.6 - circle.radius / 12585.5)
        self.mapView.animate(toZoom: zoom)
    }
    
}


//MARK: - MapControllerInterface

extension MapViewController: MapControllerInterface {
    
    func didCollectWeatherDataForCities() {
        toggleListVisabilityButton.stopLoading()
    }

    func currentLocationUpdated(location: CLLocation) {
        guard mapView.myLocation?.coordinate.latitude != location.coordinate.latitude, mapView.myLocation?.coordinate.longitude != location.coordinate.longitude else { return }
        mapView.setValue(location, forKey: "myLocation")

        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 10)
        createMarkers(on: location.coordinate)
    }
    
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        createMarkers(on: coordinate)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectMarker(lat: marker.position.latitude, lon: marker.position.longitude)
        return true
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let data = presenter?.getCurrentData(coordinate: marker.position) {
            marker.tracksInfoWindowChanges = false
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: 155, height: 60))
            markerInfoView = superView
            let subView = WeatherView(frame: superView.bounds, data: data)
            subView.setStyleColors(light: .red.withAlphaComponent(0.4),
                                   dark: .yellow.withAlphaComponent(0.4))
            subView.frame.size.height -= 5
            subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            subView.layer.cornerRadius = 5
            subView.clipsToBounds = true
            superView.addSubview(subView)
            return superView
        } else {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            markerInfoView = superView
            let indicator = UIActivityIndicatorView()
            superView.addSubview(indicator)
            indicator.frame = superView.bounds
            indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            
            presenter?.getCurrentData(for: marker.position, completion: { [weak self, weak marker, weak superView = self.markerInfoView] result in
                guard let self = self, let marker = marker, self.mapView.selectedMarker == marker else { return }
                let indicator = superView?.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
                indicator?.stopAnimating()
                indicator?.removeFromSuperview()
                marker.tracksInfoWindowChanges = false
                switch result {
                case .success:
                    self.mapView.selectedMarker = nil
                    self.mapView.selectedMarker = marker
                case .failure(let error):
                    let label = UILabel()
                    label.text = error.message
                    
                    superView?.layer.borderColor = UIColor.gray.cgColor
                    superView?.layer.borderWidth = 1
                    superView?.addSubview(label)
                    label.frame = superView?.bounds ?? .zero
                    label.frame.size.height -= 10
                    label.textAlignment = .center
                    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    label.font = .systemFont(ofSize: 14)
                    
                }
            })
            return superView
        }
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        if let location = mapView.myLocation {
            createMarkers(on: location.coordinate)
            mapView.animate(toLocation: location.coordinate)
        }
        return true
    }
    
}
