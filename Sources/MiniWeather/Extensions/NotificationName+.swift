//
//  NotificationName+.swift
//  
//
//  Created by Denis on 05.09.2024.
//

import Foundation

extension Notification.Name {
	static let meteoDidUpdated: NSNotification.Name = .init("MeteoDidUpdate")
	static let locationAuthDidUpdated: NSNotification.Name = .init("LocationAuthDidUpdate")
}
