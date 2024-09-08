//
//  PublicMethods.swift
//
//
//  Created by Denis on 06.09.2024.
//

import UIKit

public final class MiniWeather {
	
	public static let icon: UIImage? = UIImage(systemName: "sun.rain.circle")
	public static let appName: String = "MiniWeather"
	
	public static func assembly() -> UIViewController {
		let view = WeatherViewController()
		let presenter = WeatherPresenter(
			locationService: LocationService(),
			meteoService: OpenMeteoService(),
			view: view
		)
		view.presenter = presenter
		return view
	}
}
