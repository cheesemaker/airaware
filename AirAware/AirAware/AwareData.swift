//
//  AwairData.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/15/21.
//

import Foundation

public class AwareData {
	public let temperature : Double?
	public let humidity : Double?
	public let co2 : Double?
	public let voc : Double?
	public let pm25 : Double?
	public let lux : Double?
	public let spl_a : Double?
	public let score : Double?

	init(_ dictionary : [String:Any]) {
		temperature = dictionary["temp"] as? Double
		humidity = dictionary["humid"] as? Double
		co2 = dictionary["co2"] as? Double
		voc = dictionary["voc"] as? Double
		pm25 = dictionary["pm25"] as? Double
		lux = dictionary["lux"] as? Double
		spl_a = dictionary["spl_a"] as? Double

		if let value = dictionary["score"] as? Int {
			score = Double(value)
		}
		else if let value = dictionary["score"] as? Double {
			score = value
		}
		else {
			score = nil
		}
	}

	static func buildFromServerResponse(_ entry : [String : Any]) -> AwareData {

		var compiledDictionary : [String:Any] = [:]

		if let score = entry["score"] as? Int {
			compiledDictionary["score"] = score
		}
		else if let score = entry["score"] as? Double {
			compiledDictionary["score"] = score
		}

		if let sensorArray = entry["sensors"] as? [[String : Any]] {
			for sensor in sensorArray {
				let name = sensor["comp"] as? String ?? "Unknown"
				let value = sensor["value"] as? Double ?? -1

				compiledDictionary[name] = value
			}
		}

		return AwareData(compiledDictionary)
	}
}
