//
//  AirNowService+Routes.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/28/21.
//

import Foundation

extension AirNowService {

	static public let loginPath = "https://docs.airnowapi.org/login"

	static public let webservicesPath = "https://docs.airnowapi.org/webservices"

	static public let latestByZipcodePath = "https://www.airnowapi.org/aq/observation/zipCode/current/"

	static public let latestByLatLongPath = "https://www.airnowapi.org/aq/observation/latLong/current/"

	static public let forecastPath = "https://www.airnowapi.org/aq/forecast/zipCode/"
}
