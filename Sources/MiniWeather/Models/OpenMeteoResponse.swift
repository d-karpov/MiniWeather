//
//  OpenMeteoResponse.swift
//  
//
//  Created by Denis on 04.09.2024.
//

import Foundation

struct OpenMeteoResponse: Decodable {
	let currentUnits: CurrentUnits
	let current: CurrentTemperature
}

struct CurrentTemperature: Decodable {
	let time: String
	let temperature: Float
}

struct CurrentUnits: Decodable {
	let temperature: String
}
