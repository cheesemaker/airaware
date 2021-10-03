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

	public let airDensity : Double?
	public let barometricPressure : Double?
	public let dewPoint : Double?
	public let solarRadiation : Double?



	init(_ dictionary : [String:Any]) {

		if let temp = dictionary["temp"] as? Double {
			temperature = temp
		}
		else {
			temperature = dictionary["temperature"] as? Double
		}

		if let humid = dictionary["humid"] as? Double {
			humidity = humid
		}
		else {
			humidity = dictionary["humidity"] as? Double
		}

		co2 = dictionary["co2"] as? Double
		voc = dictionary["voc"] as? Double
		pm25 = dictionary["pm25"] as? Double
		lux = dictionary["lux"] as? Double
		spl_a = dictionary["spl_a"] as? Double
		airDensity = dictionary["air_density"] as? Double
		barometricPressure = dictionary["barometric_pressure"] as? Double
		dewPoint = dictionary["dew_point"] as? Double
		solarRadiation = dictionary["solar_radiation"] as? Double

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


// Helper functions to format the strings appropriately for display in the sample app...
extension AwareData {

	public func intString(_ value : Any?) -> String {
		if let value = value as? Int {
			return String(value)
		}
		else if let value = value as? Double {
			let intValue = Int(value)
			return String(intValue)
		}
		else {
			return "---"
		}
	}

	public func string(_ double : Double?) -> String {
		if let double = double {
			return String(format: "%0.2f", double)
		}
		return "---"
	}

}
