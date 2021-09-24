//
//  AwairDevice.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/15/21.
//

import Foundation
import UUSwiftNetworking

public class AwareDevice
{
	public let deviceId : Int
	public let deviceType : String
	public let uuid : String
	public let latitude : String
	public let locationName : String
	public let longitude : String
	public let macAddress : String
	public let name : String
	public let preference : String

	public var fahrenheit = true

	init(_ dictionary : [String: Any])
	{
		deviceId = dictionary["deviceId"] as? Int ?? -1
		deviceType = dictionary["deviceType"] as? String ?? ""
		uuid = dictionary["deviceUUID"] as? String ?? ""
		latitude = dictionary["latitude"] as? String ?? ""
		longitude = dictionary["longitude"] as? String ?? ""
		locationName = dictionary["locationName"] as? String ?? ""
		macAddress = dictionary["macAddress"] as? String ?? ""
		name = dictionary["name"] as? String ?? ""
		preference = dictionary["preference"] as? String ?? ""
	}

	public func fetchDisplayMode(_ completion : @escaping (String)->Void) {
		let path = AwareService.deviceModePath(self)
		let request = UUHttpRequest(url: path)
		request.headerFields = ["Authorization" : "Bearer \(AwareService.shared.accessToken)"]

		_ = UUHttpSession.executeRequest(request, { response in
			if let dictionary = response.parsedResponse as? [String : Any],
			   let mode = dictionary["mode"] as? String
			{
				DispatchQueue.main.async {
					completion(mode)
				}
			}
		})
	}
}
