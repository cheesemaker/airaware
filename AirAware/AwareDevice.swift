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
	public let latitude : Double
	public let locationName : String
	public let longitude : Double
	public let name : String
	public let preference : String

	public var fahrenheit = true

	init(_ dictionary : [String: Any])
	{
		deviceId = AwareDevice.fetchInt(dictionary["deviceId"])
		deviceType = AwareDevice.fetchString(dictionary["deviceType"])
		locationName = AwareDevice.fetchString(dictionary["locationName"])
		name = AwareDevice.fetchString(dictionary["name"])
		preference = AwareDevice.fetchString(dictionary["preference"])
		latitude = AwareDevice.fetchDouble(dictionary["latitude"])
		longitude = AwareDevice.fetchDouble(dictionary["longitude"])
	}

	private static func fetchDouble(_ value : Any?) -> Double {
		if let doubleValue = value as? Double {
			return doubleValue
		}
		else if let doubleString = value as? String,
				let doubleValue = Double(doubleString) {
			return doubleValue
		}
		else {
			return 0.0
		}
	}

	private static func fetchInt(_ value : Any?) -> Int {
		if let intValue = value as? Int {
			return intValue
		}
		else if let intString = value as? String,
				let intValue = Int(intString) {
			return intValue
		}
		else {
			return -1
		}
	}

	private static func fetchString(_ value : Any?) -> String {
		if let str = value as? String {
			return str
		}
		else {
			return ""
		}
	}

}
