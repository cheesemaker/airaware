//
//  PurpleAirService+Routes.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/5/21.
//

import Foundation

extension PurpleAirService {

	static func deviceListPath() -> String {
		let apiKey : String = PurpleAirService.shared.accessToken
		return "https://api.purpleair.com/v1/sensors?api_key=\(apiKey)&fields=latitude,longitude,name,model"
	}

	static func latestDataPath(_ device : AwareDevice) -> String {
		let apiKey : String = PurpleAirService.shared.accessToken
		return "https://api.purpleair.com/v1/sensors/\(device.deviceId)?api_key=\(apiKey)"
	}
}
