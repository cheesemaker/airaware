//
//  OpenWeatherService.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/6/21.
//

import Foundation
import CoreLocation

public class OpenWeatherService : NSObject {

	public static var shared : OpenWeatherService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if OpenWeatherService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return OpenWeatherService.sharedInstance
	}


	public static func setup(accessToken : String) {
		OpenWeatherService.sharedInstance = OpenWeatherService(accessToken : accessToken)
	}

	public var accessToken : String!

	private init(accessToken : String) {
		super.init()
		self.accessToken = accessToken
	}

	// This must be set via the static setup functions
	private static var sharedInstance : OpenWeatherService!

	static let locationManager = CLLocationManager()

	var fetchLatestCompletion : ((AwareData) -> Void)? = nil
	var location : CLLocationCoordinate2D? = nil
}
