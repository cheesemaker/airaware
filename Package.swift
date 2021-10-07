// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(

	name: "AirAware",

	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],

	products: [
		.library(
			name: "AirAware",
			targets: ["AirAware"]),
	],

	dependencies: [
		.package(
			url: "https://github.com/SilverPineSoftware/UUSwiftNetworking.git",
			from: "1.0.5"
		)
	],

	targets: [
		.target(
			name: "AirAware",
			dependencies: [ "UUSwiftNetworking" ],
			path: "AirAware",
			exclude: ["Info.plist"])
	],

	swiftLanguageVersions: [
		.v4_2,
		.v5
	]
)

