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
	public let precipitation : Double?
	public let windSpeed : Double?


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

		windSpeed = AwareData.loadDouble(dictionary["wind_speed"])
		precipitation = AwareData.loadDouble(dictionary["precipitation"])
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

		if let scoreValue = dictionary["score"] {
			score = AwareData.loadDouble(scoreValue)
		}
		else if let pm25Average = pm25 {
			score = AwareData.loadDouble(AwareData.convertPM25ToAQI(pm25Average))
		}
		else {
			score = nil
		}
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

	/*
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
	}*/
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

extension AwareData {

	static public func convertPressureToBarometric(_ pressure : Double) -> Double {
		return pressure * 0.0295301
	}

	static public func convertPM25ToAQI(_ pm25 : Double) -> Double {
		return convertPMToAQI(pm25, pm25AQITable)
	}

	static public func convertPM10ToAQI(_ pm25 : Double) -> Double {
		return convertPMToAQI(pm25, pm10AQITable)
	}

	// //////////////////////////////////////////////////////////////////////////////////////////////
	// Conversion code, adapted from:
	// https://github.com/nickpegg/purple_air_scraper/blob/master/purple_air_scraper.py
	// which is based on the official calculations found here:
	// https://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf

	static private func convertPMToAQI(_ pm : Double, _ table : [[Double]]) -> Double {
		var pm_min = 0.0
		var pm_max = 0.0
		var aqi_min = 0.0
		var aqi_max = 0.0

		for level in table {
			let table_pm = level[0]
			let table_aqi = level[1]
			if table_pm > pm {
				pm_max = table_pm
				aqi_max = table_aqi
				break
			}
			aqi_min = table_aqi
			pm_min = table_pm
		}

		var aqi = (aqi_max - aqi_min) * (pm - pm_min) / (pm_max - pm_min) + aqi_min
		if aqi > 500.0 {
			aqi = 500.0
		}
		return aqi
	}

}

fileprivate let pm25AQITable : [[Double]] = [
	[0, 0],
	[12.1, 51],
	[35.5, 101],
	[55.5, 151],
	[150.5, 201],
	[250.5, 301],
	[350.5, 401]
]

fileprivate let pm10AQITable : [[Double]] = [
	[0, 0],
	[55, 51],
	[155, 101],
	[255, 151],
	[355, 201],
	[425, 301],
	[505, 401]
]




/*

 UNUSED:
 // Code adapted from https://github.com/jasonsnell/PurpleAir-AQI-Scriptable-Widget/blob/main/purpleair-aqi.js

 public static func calculateAQI(humidity : Double, pm25Average : Double) -> Int?
 {
 if (pm25Average < 250.0) {
 let epaPM =  0.52 * pm25Average - 0.085 * humidity + 5.71
 return aqiFromPM(epaPM)
 }
 else {
 let epaPM = 0.0778 * pm25Average + 2.65
 return aqiFromPM(epaPM)
 }
 }

 private static func aqiFromPM(_ pm : Double) -> Int? {
 if (pm > 350.5) {
 return calculateAQI(pm, 500.0, 401.0, 500.0, 350.5)
 }
 if (pm > 250.5) {
 return calculateAQI(pm, 400.0, 301.0, 350.4, 250.5)
 }
 if (pm > 150.5) {
 return calculateAQI(pm, 300.0, 201.0, 250.4, 150.5)
 }
 if (pm > 55.5) {
 return calculateAQI(pm, 200.0, 151.0, 150.4, 55.5)
 }
 if (pm > 35.5) {
 return calculateAQI(pm, 150.0, 101.0, 55.4, 35.5)
 }
 if (pm > 12.1) {
 return calculateAQI(pm, 100.0, 51.0, 35.4, 12.1)
 }
 if (pm >= 0.0) {
 return calculateAQI(pm, 50.0, 0.0, 12.0, 0.0)
 }

 return nil
 }

 private static func calculateAQI(_ Cp : Double, _ Ih : Double, _ Il : Double, _ BPh : Double, _ BPl : Double) -> Int {
 let a = Ih - Il;
 let b = BPh - BPl;
 let c = Cp - BPl;
 let computed = (a / b) * c + Il
 return Int(computed.rounded())
 }
 */



