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

		var endString = end.uuRfc3339StringUtc()
		var startString = start.uuRfc3339StringUtc()

		// Dummy proof the arguments...
		if start > end {
			let swap = endString
			endString = startString
			startString = swap
		}

		let path = AwareService.rawDataPath(device)
		let args : UUQueryStringArgs = [
										 "fahrenheit" : "true",
										 "from" : startString,
										 "to" : endString,
									   ]

		let request = UUHttpRequest(url: path, queryArguments: args)
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			var returnArray : [AwareData] = []

			if let data = response.parsedResponse as? [String : Any],
			   let dataArray = data["data"] as? [[String : Any]] {

				for entry in dataArray {
					let awareData = AwareData.buildFromServerResponse(entry)
					returnArray.append(awareData)
				}
			}

			DispatchQueue.main.async {
				completion(returnArray)
			}
		})
	}

	public func fetchLatestAverageData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let path = AwareService.latestFiveMinuteAveragePath(device)
		// ?from=from&to=to&limit=limit&desc=desc&fahrenheit=fahrenheit
		let args : UUQueryStringArgs = [
										 "fahrenheit" : "true",
										 "limit" : 1
									   ]

		let request = UUHttpRequest(url: path, queryArguments: args)
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			if let data = response.parsedResponse as? [String : Any],
			   let dataArray = data["data"] as? [[String : Any]],
			   let entry = dataArray.last {

				let awareData = AwareData.buildFromServerResponse(entry)

				DispatchQueue.main.async {
					completion(awareData)
				}
			}
		})
	}


	public func fetchCurrentData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let request = UUHttpRequest(url: AwareService.latestDataPath(device))
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			if let data = response.parsedResponse as? [String : Any],
			   let dataArray = data["data"] as? [[String : Any]],
			   let entry = dataArray.last {

				let awareData = AwareData.buildFromServerResponse(entry)
				DispatchQueue.main.async {
					completion(awareData)
				}
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
