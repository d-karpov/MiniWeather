//
//  OpenMeteoService.swift
//  
//
//  Created by Denis on 04.09.2024.
//

import UIKit

protocol IMeteoService {
	var currentTemperature: String? { get }
	func getCurrentTemperature(latitude: String, longitude: String)
}

private enum API {
	static let baseForecastURL: String = "https://api.open-meteo.com/v1/forecast"
	
	enum QueryItems: String {
		case latitude
		case longitude
		case current
		case temperature
		case timezone
	}
}

final class OpenMeteoService: IMeteoService {
	
	private(set) var currentTemperature: String?
	
	func getCurrentTemperature(latitude: String, longitude: String) {
		if let request = temperatureRequest(latitude: latitude, longitude: longitude) {
			let task = URLSession.shared
				.objectTask(for: request) { [weak self] (result: Result<OpenMeteoResponse, Error>) in
					guard let self else { preconditionFailure("No OpenMeteoService") }
					switch result {
					case .success(let response):
						self.currentTemperature = "\(response.current.temperature) \(response.currentUnits.temperature)"
						NotificationCenter.default.post(
							name: .meteoDidUpdated,
							object: self
						)
					case .failure(let error):
						print("\(error.localizedDescription)")
					}
				}
			task.resume()
		}
	}
	
	private func temperatureRequest(latitude: String, longitude: String) -> URLRequest? {
		if var components = URLComponents(string: API.baseForecastURL) {
			components.queryItems = [
				URLQueryItem(
					name: API.QueryItems.latitude.rawValue,
					value: latitude
				),
				URLQueryItem(
					name: API.QueryItems.longitude.rawValue,
					value: longitude
				),
				URLQueryItem(
					name: API.QueryItems.current.rawValue,
					value: API.QueryItems.temperature.rawValue
				),
				URLQueryItem(
					name: API.QueryItems.timezone.rawValue,
					value: TimeZone.current.identifier
				)
			]
			
			if let url = components.url {
				return URLRequest(url: url)
			}
		}
		return .none
	}
}
