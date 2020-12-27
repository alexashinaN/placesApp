//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Violence on 23.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
	func getNewAddress(_ address: String?)
}

class MapViewController: UIViewController {
	enum LocationMode {
		case current
		case place
	}
	
	var mapViewControllerDelegate: MapViewControllerDelegate?
	let mapView = MKMapView()
	let closeButton = UIButton()
	var place: PlaceModel?
	let annotationIdentifier = "annotationIdentifier"
	let locationManager = CLLocationManager()
	let userLocationButton = UIButton()
	let regionInMeters = 1000.00
	let pinImageView = UIImageView()
	let addressLabel = UILabel()
	let doneButton = UIButton()
	let goButton = UIButton()
	var placeCoordinate:CLLocationCoordinate2D?
	var directionsArray: [MKDirections] = []
	var previousLocation: CLLocation? {
		didSet {
			startTrackingUserLocation()
		}
	}
	var mode: LocationMode? {
		didSet {
			guard let mode = mode else { return }
			pinImageView.isHidden = mode == .current ? false : true
			addressLabel.isHidden = mode == .current ? false : true
			doneButton.isHidden = mode == .current ? false : true
			goButton.isHidden = mode == .current ? true : false
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		closeButton.setImage(UIImage(named: "camcel"), for: .normal)
		setupLayout()
		closeButton.addTarget(self, action: #selector(closeMap), for: .touchUpInside)
		userLocationButton.setImage(UIImage(named: "Location"), for: .normal)
		userLocationButton.addTarget(self, action: #selector(centerViewInUserLocation), for: .touchUpInside)
		pinImageView.image = UIImage(named: "Pin")
		addressLabel.text = ""
		addressLabel.lineBreakMode = .byWordWrapping
		addressLabel.numberOfLines = 0
		addressLabel.font = UIFont.boldSystemFont(ofSize: 16)
		doneButton.setTitle("Done", for: .normal)
		doneButton.setTitleColor(.black, for: .normal)
		doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
		doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
		goButton.setImage(UIImage(named: "GetDirection"), for: .normal)
		goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
		setupPlacemark()
		mapView.delegate = self
		checkLocationServices()
		
	}
	
	@objc func closeMap(sender: UIButton) {
		dismiss(animated: true)
	}
	
	@objc func centerViewInUserLocation(sender: UIButton) {
		showUserLocation()
	}
	
	@objc func doneButtonPressed(sender: UIButton) {
		mapViewControllerDelegate?.getNewAddress(addressLabel.text)
		dismiss(animated: true)
	}
	
	@objc func goButtonPressed(sender: UIButton) {
		getDirections()
	}
	
	func setupLayout() {
		view.addSubviews(mapView, closeButton, userLocationButton, pinImageView, addressLabel, doneButton, goButton)
		
		NSLayoutConstraint.activate([
			mapView.topAnchor.constraint(equalTo: view.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
			mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
			
			closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			view.rightAnchor.constraint(equalTo: closeButton.rightAnchor, constant: 20),
			closeButton.widthAnchor.constraint(equalToConstant: 20),
			closeButton.heightAnchor.constraint(equalToConstant: 20),
			
			view.bottomAnchor.constraint(equalTo: userLocationButton.safeAreaLayoutGuide.bottomAnchor, constant: 70),
			view.rightAnchor.constraint(equalTo: userLocationButton.rightAnchor, constant: 20),
			userLocationButton.widthAnchor.constraint(equalToConstant: 40),
			userLocationButton.heightAnchor.constraint(equalToConstant: 40),
			
			pinImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
			pinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pinImageView.widthAnchor.constraint(equalToConstant: 40),
			pinImageView.heightAnchor.constraint(equalToConstant: 40),
			
			addressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
			addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			view.bottomAnchor.constraint(equalTo: doneButton.safeAreaLayoutGuide.bottomAnchor, constant: 70),
			doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			doneButton.widthAnchor.constraint(equalToConstant: 60),
			doneButton.heightAnchor.constraint(equalToConstant: 30),
			
			view.bottomAnchor.constraint(equalTo: goButton.safeAreaLayoutGuide.bottomAnchor, constant: 70),
			goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			goButton.widthAnchor.constraint(equalToConstant: 40),
			goButton.heightAnchor.constraint(equalToConstant: 40),
			
		])
	}
	
	private func setupPlacemark() {
		guard let location = place?.locationName else { return }
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(location) { (placemarks, error) in
			
			if let error = error {
				print(error)
				return
			}
			guard let placemarks = placemarks else { return }
			let placemark = placemarks.first
			let annotation = MKPointAnnotation()
			annotation.title = self.place?.locationName
			annotation.subtitle = self.place?.typeName
			
			guard let placemarkLocation = placemark?.location else { return }
			annotation.coordinate = placemarkLocation.coordinate
			self.placeCoordinate = placemarkLocation.coordinate
			
			self.mapView.showAnnotations([annotation], animated: true)
			self.mapView.selectAnnotation(annotation, animated: true)
		}
	}
	
	private func checkLocationServices() {
		if CLLocationManager.locationServicesEnabled() {
			setupLocationManager()
			checkLocationAuthorization()
		} else {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.showAlert(title: "Location Services are disabled", message: "To enable it go: Settings -> Privacy -> Location Services")
			}
		}
	}
	
	func showUserLocation() {
		
		if let location = locationManager.location?.coordinate {
			let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
			mapView.setRegion(region, animated: true)
		}
	}
	
	private func startTrackingUserLocation() {
		guard let previousLocation = previousLocation else { return }
		let center = getCenterLocation(for: mapView)
		guard center.distance(from: previousLocation) > 50 else { return }
		self.previousLocation = center
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.showUserLocation()
		}
	}
	
	private func resetMapView(withNew directions: MKDirections) {
		mapView.removeOverlays(mapView.overlays)
		directionsArray.append(directions)
		let _ = directionsArray.map { $0.cancel() }
		directionsArray.removeAll()
	}
	
	private func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		
	}
	
	private func checkLocationAuthorization() {
		switch CLLocationManager.authorizationStatus() {
		case .authorizedWhenInUse:
			mapView.showsUserLocation = true
			break
		case .denied:
			
			break
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .restricted:
			
			break
		case .authorizedAlways:
			break
		@unknown default:
			print("new case is available")
		}
	}
	
	private func getCenterLocation(for mapView: MKMapView)  -> CLLocation {
		let latitude = mapView.centerCoordinate.latitude
		let longitude = mapView.centerCoordinate.longitude
		
		return CLLocation(latitude: latitude, longitude: longitude )
	}
	
	private func showAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default)
		
		alert.addAction(okAction)
		present(alert, animated: true )
		
	}
	
	private func getDirections() {
		guard let location = locationManager.location?.coordinate else {
			showAlert(title: "Error", message: "Current location is not found")
			return
		}
		
		locationManager.startUpdatingLocation()
		previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
		
		guard let request = createDirectionRequest(from: location) else {
			showAlert(title: "Error", message: "Destination is not found")
			return
		}
		let directions = MKDirections(request: request)
		resetMapView(withNew: directions)
		directions.calculate { (response, error) in
			if let error = error {
				print(error)
				return
			}
			guard let response = response else {
				self.showAlert(title: "Error", message: "Direction is not available")
				return
			}
			for route in response.routes {
				self.mapView.addOverlay(route.polyline)
				self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
				
				let distance = String(format: "%.1f", route.distance / 1000)
				let timaInterval = route.expectedTravelTime
				
				print("distance = \(distance)")
				print("time = \(timaInterval)")
			}
		}
	}
	
	private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
		guard let destinationCoordinate = placeCoordinate else { return nil }
		let startLocation = MKPlacemark(coordinate: coordinate)
		let destination = MKPlacemark(coordinate: destinationCoordinate)
		
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: startLocation)
		request.destination = MKMapItem(placemark: destination)
		request.transportType = .automobile
		return request
	}
}

extension MapViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		guard !(annotation is MKUserLocation) else { return nil }
		
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
		
		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			annotationView?.canShowCallout = true
		}
		if let imageData = place?.image {
			let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
			imageView.layer.cornerRadius = 10
			imageView.clipsToBounds = true
			imageView.image = imageData
			annotationView?.rightCalloutAccessoryView = imageView
		}
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		let center = getCenterLocation(for: mapView)
		let geocoder = CLGeocoder()
		
		geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
			if let error = error {
				print(error)
				return
			}
			guard let placemarks = placemarks else { return }
			let placemark = placemarks.first
			let streetName = placemark?.thoroughfare
			let buildNumber = placemark?.subThoroughfare
			
			DispatchQueue.main.async {
				if streetName != nil && buildNumber != nil {
					self.addressLabel.text = "\(streetName!), \(buildNumber!) "
				} else if streetName != nil {
					self.addressLabel.text = "\(streetName!)"
				} else {
					self.addressLabel.text = ""
				}
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay:  overlay as! MKPolyline)
		renderer.strokeColor = .blue
		
		return renderer
	}
}

extension MapViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		checkLocationAuthorization()
	}
}
