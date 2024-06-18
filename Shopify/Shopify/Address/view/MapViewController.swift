//
//  MapViewController.swift
//  Shopify
//
//  Created by sarrah ashraf on 18/06/2024.
//

import UIKit
import MapKit

protocol MapSelectionDelegate: AnyObject {
    func didSelectLocation(address: String, city: String, country: String, latitude: Double, longitude: Double)
}

class MapViewController: UIViewController {
    weak var delegate: MapSelectionDelegate?
    private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

            let geocoder = CLGeocoder()
            let locationn = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geocoder.reverseGeocodeLocation(locationn) { [weak self] (placemarks, error) in
                guard let self = self, let placemark = placemarks?.first else { return }
                let address = [placemark.name, placemark.locality, placemark.administrativeArea, placemark.country]
                    .compactMap { $0 }
                    .joined(separator: ", ")

                let city = placemark.locality ?? ""
                let country = placemark.country ?? ""

                self.delegate?.didSelectLocation(address: address, city: city, country: country, latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
