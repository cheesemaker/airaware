//
//  AwareService + Routes.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/22/21.
//

import Foundation

extension AwareService {

	static func devicesPath() -> String {
		return "https://developer-apis.awair.is/v1/users/self/devices"
	}

	static func latestFiveMinuteAveragePath(_ device : AwareDevice) -> String {
		return "https://developer-apis.awair.is/v1/users/self/devices/\(device.deviceType)/\(device.deviceId)/air-data/5-min-avg"
	}

	static func rawDataPath(_ device : AwareDevice) -> String {
		return "https://developer-apis.awair.is/v1/users/self/devices/\(device.deviceType)/\(device.deviceId)/air-data/raw"
	}

	static func latestDataPath(_ device : AwareDevice) -> String {
		return "https://developer-apis.awair.is/v1/users/self/devices/\(device.deviceType)/\(device.deviceId)/air-data/latest?fahrenheit=\(device.fahrenheit)"
	}

	static func deviceModePath(_ device : AwareDevice) -> String {
		return "https://developer-apis.awair.is/v1/devices/\(device.deviceType)/\(device.deviceId)/display"
	}

	static func devicePowerPath(_ device : AwareDevice) -> String {
		return "https://developer-apis.awair.is/v1/devices/\(device.deviceType)/\(device.deviceId)/power-status"
	}

	static let tokenExchangePath = "https://oauth2.awair.is/v2/token"
	static let loginPath = "https://oauth-login.awair.is"
}
