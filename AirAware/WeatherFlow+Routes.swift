//
//  WeatherFlow+Routes.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/1/21.
//

import Foundation

extension WeatherFlowService {

	public static let tokenExchangePath = "https://swd.weatherflow.com/id/oauth2/token"
	public static let loginPath = "https://tempestwx.com/authorize.html"
	public static let fetchStationsPath = "https://swd.weatherflow.com/swd/rest/stations"

	static func latestDataPath(_ device : AwareDevice) -> String {
		return "https://swd.weatherflow.com/swd/rest/observations/station/\(device.deviceId)?token=\(WeatherFlowService.shared.accessToken)"
	}

}
