//
//  AwareService+Fetch.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/22/21.
//

import Foundation
import UUSwiftNetworking


extension AwairService : AwareService {

	public func fetchDataFromRange(device : AwareDevice, start : Date, end : Date, _ completion : @escaping([AwareData])->Void) {

		var endString = end.uuRfc3339StringUtc()
		var startString = start.uuRfc3339StringUtc()

		// Dummy proof the arguments...
		if start > end {
			let swap = endString
			endString = startString
			startString = swap
		}

		let path = AwairService.rawDataPath(device)
		let args : UUQueryStringArgs = [
										 "fahrenheit" : device.fahrenheit,
										 "from" : startString,
										 "to" : endString,
									   ]

		let request = UUHttpRequest(url: path, queryArguments: args)
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			// If we need to refresh the auth token, then do that and then re-call this function...
			if AwairService.needsTokenRefresh(response.httpResponse) {
				self.refreshAuthToken { complete in
					self.fetchDataFromRange(device: device, start: start, end: end, completion)
				}
				return
			}

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

		let path = AwairService.latestFiveMinuteAveragePath(device)
		let args : UUQueryStringArgs = [
										 "fahrenheit" : device.fahrenheit,
										 "limit" : 1
									   ]

		let request = UUHttpRequest(url: path, queryArguments: args)
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			// If we need to refresh the auth token, then do that and then re-call this function...
			if AwairService.needsTokenRefresh(response.httpResponse) {
				self.refreshAuthToken { complete in
					self.fetchLatestAverageData(device: device, completion)
				}
				return
			}

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


	public func fetchLatestData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let request = UUHttpRequest(url: AwairService.latestDataPath(device))
		request.headerFields = ["Authorization" : "Bearer \(self.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			// If we need to refresh the auth token, then do that and then re-call this function...
			if AwairService.needsTokenRefresh(response.httpResponse) {
				self.refreshAuthToken { complete in
					self.fetchLatestData(device: device, completion)
				}
				return
			}

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

	public func fetchAllDevices(_ completion : @escaping ([AwareDevice])->Void) {

		let request = UUHttpRequest(url: AwairService.devicesPath())
		request.headerFields = ["Authorization" : "Bearer \(accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			// If we need to refresh the auth token, then do that and then re-call this function...
			if AwairService.needsTokenRefresh(response.httpResponse) {
				self.refreshAuthToken { complete in
					self.fetchAllDevices(completion)
				}
				return
			}

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
