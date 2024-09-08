// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "MiniWeather",
	platforms: [
		.iOS(.v17)
	],
	products: [
		.library(
			name: "MiniWeather",
			targets: ["MiniWeather"]),
	],
	targets: [
		.target(
			name: "MiniWeather"),
	]
)
