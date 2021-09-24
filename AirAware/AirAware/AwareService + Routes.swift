//
//  AwareService + Routes.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/22/21.
//

import Foundation

extension AwareService {

	static let devicesPath = "https://developer-apis.awair.is/v1/users/self/devices"

	static func latestFiveMinuteAveragePath(_ device : AwareDevice) -> String {
		return "https://developer-apis.awair.is/v1/users/self/devices/\(device.deviceType)/\(device.deviceId)/air-data/5-min-avg"
	}

	//let dataPath = "https://developer-apis.awair.is/v1/users/self/devices/device_type/device_id/air-data/raw?from=from&to=to&limit=limit&desc=desc&fahrenheit=fahrenheit"
}
