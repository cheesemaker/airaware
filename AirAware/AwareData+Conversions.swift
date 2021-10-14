//
//  AwareData+Conversions.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/6/21.
//

import Foundation

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

	static public func convertCelsiusToFahrenheit(_ degrees : Double) -> Double {
		return ((degrees * 9.0) / 5.0) + 32.0
	}

	static public func convertFahrenheitToCelsius(_ degreees : Double) -> Double {
		return ((degreees - 32.0) * 5.0) / 9.0
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
