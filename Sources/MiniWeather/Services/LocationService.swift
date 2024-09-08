//
//  LocationService.swift
//  
//
//  Created by Denis on 04.09.2024.
//

import CoreLocation
import UIKit

protocol ILocationService: AnyObject {
	var currentLocation: Result<CLLocation, LocationServiceErrors>? { get }
	func getLocation()
}

enum LocationServiceErrors: Error, LocalizedError {
	case noLocation, notAllowed
	
	var errorDescription: String? {
		switch self {
		case .noLocation:
			return "Error while getting current location"
		case .notAllowed:
			return "Location tracking aren't allowed"
		}
	}
}

final class LocationService: NSObject, CLLocationManagerDelegate {
	private let locationManager = CLLocationManager()

	var currentLocation: Result<CLLocation, LocationServiceErrors>?
	
	override init() {
		super.init()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch locationManager.authorizationStatus {
		case .authorizedAlways, .authorizedWhenInUse: getLocation()
		case .denied, .restricted: currentLocation = .failure(.notAllowed)
		case .notDetermined: NSLog("Not determined LocationManagerAuth State - Auth were requested")
		@unknown default: NSLog("Not determined error from LocationService")
		}
		NotificationCenter.default.post(name: .locationAuthDidUpdated, object: self)
	}
	
}

//MARK: - ILocationService Implementation
extension LocationService: ILocationService {
	func getLocation() {
		if let location = locationManager.location {
			currentLocation = .success(location)
		}
	}
}
