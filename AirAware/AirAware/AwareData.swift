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
	public let pm10 : Double?
	public let pm1 : Double?
	public let pm25 : Double?
	public let lux : Double?
	public let spl_a : Double?
	public let score : Double?

	public let airDensity : Double?
	public let barometricPressure : Double?
	public let dewPoint : Double?
	public let solarRadiation : Double?
	public let ozone : Double?



	init(_ dictionary : [String:Any]) {

		if dictionary["temp"] != nil {
			temperature = AwareData.loadDouble(dictionary["temp"])
		}
		else {
			temperature = AwareData.loadDouble(dictionary["temperature"])
		}

		if dictionary["humid"] != nil {
			humidity = AwareData.loadDouble(dictionary["humid"])
		}
		else {
			humidity = AwareData.loadDouble(dictionary["humidity"])
		}

		co2 = AwareData.loadDouble(dictionary["co2"])
		voc = AwareData.loadDouble(dictionary["voc"])
		pm25 = AwareData.loadDouble(dictionary["pm25"])
		pm10 = AwareData.loadDouble(dictionary["pm10"])
		pm1 = AwareData.loadDouble(dictionary["pm1"])
		lux = AwareData.loadDouble(dictionary["lux"])
		spl_a = AwareData.loadDouble(dictionary["spl_a"])
		airDensity = AwareData.loadDouble(dictionary["air_density"])
		barometricPressure = AwareData.loadDouble(dictionary["barometric_pressure"])
		dewPoint = AwareData.loadDouble(dictionary["dew_point"])
		solarRadiation = AwareData.loadDouble(dictionary["solar_radiation"])
		ozone = AwareData.loadDouble(dictionary["ozone"])
		score = AwareData.loadDouble(dictionary["score"])
	}

	static private func loadDouble(_ value : Any?) -> Double? {
		if let val = value as? Double {
			return val
		}
		else if let val = value as? Int {
			return Double(val)
		}
		else if let strVal = value as? String,
				let val = Double(strVal) {
			return val
		}
		else {
			return nil
		}
	}

	static private func loadInt(_ value : Any?) -> Int? {
		if let val = value as? Int {
			return val
		}
		else if let strVal = value as? String,
				let val = Int(strVal) {
			return val
		}
		else if let val = value as? Double {
			return Int(val)
		}
		else {
			return nil
		}
	}

	static private func loadString(_ value : Any?) -> String? {
		if let val = value as? String {
			return val
		}
		else if let val = value as? Double {
			return "\(val)"
		}
		else if let val = value as? Int {
			return "\(val)"
		}
		else {
			return nil
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
