//
//  AwareService+Fetch.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/22/21.
//

import Foundation
import UUSwiftNetworking

extension AwareService {

	public func fetchDataFromRange(device : AwareDevice, start : Date, end : Date, _ completion : @escaping([AwareData])->Void) {

	}

	public func fetchLatestAverageData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let path = AwareService.latestFiveMinuteAveragePath(device)
		// ?from=from&to=to&limit=limit&desc=desc&fahrenheit=fahrenheit
		let args : UUQueryStringArgs = [
										 "fahrenheight" : "yes",
										 "limit" : 1
									   ]
		let request = UUHttpRequest(url: path, queryArguments: args)
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			var compiledDictionary : [String:Any] = [:]

			if let data = response.parsedResponse as? [String : Any],
			   let dataArray = data["data"] as? [[String : Any]] {

				for entry in dataArray {
					if let score = entry["score"] as? Int {
						compiledDictionary["score"] = score
					}

					if let sensorArray = entry["sensors"] as? [[String : Any]] {
						for sensor in sensorArray {
							let name = sensor["comp"] as? String ?? "Unknown"
							let value = sensor["value"] as? Double ?? -1

							compiledDictionary[name] = value

							print("\(name) = \(value)")
						}
					}
				}
			}

			let awareData = AwareData(compiledDictionary)

			DispatchQueue.main.async {
				completion(awareData)
			}

		})
	}


	public func fetchCurrentData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let request = UUHttpRequest(url: device.fetchDataPath())
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			var compiledDictionary : [String:Any] = [:]

			if let data = response.parsedResponse as? [String : Any],
			   let dataArray = data["data"] as? [[String : Any]] {

				for entry in dataArray {
					if let score = entry["score"] as? Int {
						compiledDictionary["score"] = score
					}

					if let sensorArray = entry["sensors"] as? [[String : Any]] {
						for sensor in sensorArray {
							let name = sensor["comp"] as? String ?? "Unknown"
							let value = sensor["value"] as? Double ?? -1

							compiledDictionary[name] = value
						}
					}
				}
			}

			let awareData = AwareData(compiledDictionary)

			DispatchQueue.main.async {
				completion(awareData)
			}
		})
	}

	public func fetchDevices(_ completion : @escaping ([AwareDevice])->Void) {

		let request = UUHttpRequest(url: AwareService.devicesPath)
		request.headerFields = ["Authorization" : "Bearer \(accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			var devices : [AwareDevice] = []
			if let deviceDictionary = response.parsedResponse as? [String:Any],
			   let array = deviceDictionary["devices"] as? [[String:Any]] {

				for dictionary in array {
					let device = AwareDevice(dictionary)
					devices.append(device)
				}
			}

			DispatchQueue.main.async {
				completion(devices)
			}
		})
	}
}
