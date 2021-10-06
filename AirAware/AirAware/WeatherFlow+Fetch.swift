//
//  WeatherFlow+Fetch.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/1/21.
//

import Foundation
import UUSwiftNetworking

extension WeatherFlowService : AwareService {

	public func fetchAllDevices(_ completion : @escaping([AwareDevice])->Void) {

		let path = WeatherFlowService.fetchStationsPath + "?token=" + WeatherFlowService.shared.accessToken

		UUHttpSession.get(url: path) { response in

			var devices : [AwareDevice] = []

			if let dictionary = response.parsedResponse as? [String:Any] {
				if let array = dictionary["stations"] as? [[String:Any]] {

					for stationDictionary in array {
						let name = stationDictionary["name"] as? String
						let locationName = stationDictionary["public_name"] as? String
						let latitude = stationDictionary["latitude"] as? Double
						let longitude = stationDictionary["longitude"] as? Double
						let identifier = stationDictionary["station_id"] as? Int

						var dictionary : [String:Any] = [:]
						dictionary["name"] = name
						dictionary["deviceId"] = identifier
						dictionary["latitude"] = latitude
						dictionary["longitude"] = longitude
						dictionary["locationName"] = locationName
						dictionary["deviceType"] = "WeatherFlow"

						//if let devices = stationDictionary["devices"] as? [[String:Any]] {
						//	for device in devices {
						//		print(device)
						//	}
						//}

						let device = AwareDevice(dictionary)
						devices.append(device)
					}
				}
			}

			DispatchQueue.main.async {
				completion(devices)
			}
		}
	}

	public func fetchLatestData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let path = WeatherFlowService.latestDataPath(device)
		UUHttpSession.get(url: path) { response in
			if let dictionary = response.parsedResponse as? [String:Any],
			   let observationArray = dictionary["obs"] as? [[String:Any]],
			   let observation = observationArray.first {

				var composedDictionary : [String : Any] = [:]
				if let temperature = observation["air_temperature"] as? Double {
					if device.fahrenheit {
						composedDictionary["temperature"] = (temperature * 1.8) + 32.0
					}
					else {
						composedDictionary["temperature"] = temperature
					}
				}

				if let pressure = observation["sea_level_pressure"] as? Double {
					composedDictionary["barometric_pressure"] = pressure * 0.0295301
				}
				composedDictionary["air_density"] = observation["air_density"]
				composedDictionary["dew_point"] = observation["dew_point"]
				composedDictionary["heat_index"] = observation["heat_index"]
				composedDictionary["humidity"] = observation["relative_humidity"]
				composedDictionary["solar_radiation"] = observation["solar_radiation"]

				/*
				 precip = 0;
				 "precip_accum_last_1hr" = 0;
				 "precip_accum_local_day" = 0;
				 "precip_accum_local_yesterday" = "16.792112";
				 "precip_minutes_local_day" = 0;
				 "precip_minutes_local_yesterday" = 13;
				 "pressure_trend" = falling;
				 "sea_level_pressure" = "1022.6";
				 "station_pressure" = 1013;
				 timestamp = 1633199724;
				 uv = "3.48";
				 "wet_bulb_temperature" = "14.7";
				 "wind_avg" = "0.5";
				 "wind_chill" = "19.9";
				 "wind_direction" = 243;
				 "wind_gust" = "1.6";
				 "wind_lull" = 0;
				 */

				let data = AwareData(composedDictionary)
				DispatchQueue.main.async {
					completion(data)
				}
			}
		}
	}
}
