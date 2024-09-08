//
//  WeatherPresenter.swift
//  
//
//  Created by Denis on 04.09.2024.
//

import UIKit

protocol IWeatherPresenter: AnyObject {
	func refreshTemperature()
}

final class WeatherPresenter {
	private let locationService: ILocationService
	private let meteoService: IMeteoService
	private var meteoObserver: NSObjectProtocol?
	private var locationObserver: NSObjectProtocol?
	private weak var view: IWeatherView?
	
	init(locationService: ILocationService, meteoService: IMeteoService, view: IWeatherView?) {
		self.locationService = locationService
		self.meteoService = meteoService
		self.view = view
		meteoObserver = NotificationCenter.default.addObserver(
			forName: .meteoDidUpdated,
			object: .none,
			queue: .main,
			using: { [weak self] _ in
				self?.updateTemperature()
			}
		)
		locationObserver = NotificationCenter.default.addObserver(
			forName: .locationAuthDidUpdated,
			object: .none,
			queue: .main,
			using: { [weak self] _ in
				self?.getCurrentTemperature()
			}
		)
	}
	
	//MARK: - Private Methods
	private func getCurrentTemperature() {
		switch locationService.currentLocation {
		case .success(let location):
			meteoService.getCurrentTemperature(
				latitude: location.coordinate.latitude.description,
				longitude: location.coordinate.longitude.description
			)
		case .failure(let error):
			view?.updateLabelText(with: error.localizedDescription)
		case .none:
			locationService.getLocation()
		}
	}
	
	private func updateTemperature() {
		if let temperature = meteoService.currentTemperature {
			view?.updateLabelText(with: "Current temperature:\n" + temperature)
		}
	}
}

//MARK: - IWeatherPresenter Implementation
extension WeatherPresenter: IWeatherPresenter {
	func refreshTemperature() {
		locationService.getLocation()
		getCurrentTemperature()
	}
}
