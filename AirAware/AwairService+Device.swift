//
//  AwairService+Device.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/1/21.
//

import Foundation
import UUSwiftNetworking

extension AwareDevice {

	public func fetchAwairDisplayMode(_ completion : @escaping (String)->Void) {
		let path = AwairService.deviceModePath(self)
		let request = UUHttpRequest(url: path)
		request.headerFields = ["Authorization" : "Bearer \(AwairService.shared.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			// If we need to refresh the auth token, then do that and then re-call this function...
			if AwairService.needsTokenRefresh(response.httpResponse) {
				AwairService.shared.refreshAuthToken { complete in
					self.fetchAwairDisplayMode(completion)
				}
				return
			}

			if let dictionary = response.parsedResponse as? [String : Any],
			   let mode = dictionary["mode"] as? String
			{
				DispatchQueue.main.async {
					completion(mode)
				}
			}
		})
	}

	public func fetchAwairPowerStatus(_ completion : @escaping (Double?, Bool?)->Void) {
		let path = AwairService.devicePowerPath(self)
		let request = UUHttpRequest(url: path)
		request.headerFields = ["Authorization" : "Bearer \(AwairService.shared.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in

			// If we need to refresh the auth token, then do that and then re-call this function...
			if AwairService.needsTokenRefresh(response.httpResponse) {
				AwairService.shared.refreshAuthToken { complete in
					self.fetchAwairPowerStatus(completion)
				}
				return
			}

			var percentageReading : Double? = nil
			var pluggedStatus : Bool? = nil

			if let dictionary = response.parsedResponse as? [String : Any] {
				if let percentage = dictionary["percentage"] as? Double {
					percentageReading = percentage
				}

				if let plugged = dictionary["plugged"] as? Bool {
					pluggedStatus = plugged
				}
			}

			DispatchQueue.main.async {
				completion(percentageReading, pluggedStatus)
			}
		})
	}
}
