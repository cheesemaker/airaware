//
//  PurpleAirService+Fetch.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/5/21.
//

import Foundation
import CoreLocation
import UUSwiftNetworking

extension PurpleAirService {

	func needsLogin() -> Bool {
		return false
	}

	public func fetchDevices(_ completion : @escaping([AwareDevice])->Void) {

		let path = PurpleAirService.deviceListPath()

		UUHttpSession.get(url: path) { response in

			var devices : [AwareDevice] = []

			if let dictionary = response.parsedResponse as? [String : Any],
			   let sensorArray = dictionary["data"] as? [[Any]] {


				for sensor in sensorArray {
					if let sensorId = sensor[0] as? Int,
					   let latitude = sensor[1] as? Double,
					   let longitude = sensor[2] as? Double,
					   let name = sensor[3] as? String,
					   let model = sensor[4] as? String {

						var composedDictionary : [String : Any] = [:]
						composedDictionary["latitude"] = latitude
						composedDictionary["longitude"] = longitude
						composedDictionary["deviceId"] = sensorId
						composedDictionary["name"] = name
						composedDictionary["deviceType"] = model

						let device = AwareDevice(composedDictionary)
						devices.append(device)
					}
				}

				DispatchQueue.main.async {
					completion(devices)
				}
			}
		}
	}

	
	public func findClosestDevice(location : CLLocationCoordinate2D, _ completion : @escaping(AwareDevice)->Void) {

		self.fetchDevices { devices in

			let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
			var closestDistance : Double = 10000000.0
			var closestDevice = devices.first!

			for device in devices {
				let deviceLocation = CLLocation(latitude: device.latitude, longitude: device.longitude)
				let distance = deviceLocation.distance(from: currentLocation)
				if distance < closestDistance {
					closestDevice = device
					closestDistance = distance
				}
			}

			DispatchQueue.main.async {
				completion(closestDevice)
			}
		}
	}

	public func fetchLatestData(device : AwareDevice, _ completion : @escaping(AwareData)->Void) {

		let path = PurpleAirService.latestDataPath(device)

		UUHttpSession.get(url: path) { response in

			if let dictionary = response.parsedResponse as? [String : Any] {
				if let sensorDictionary = dictionary["sensor"] as? [String : Any] {

					let humidity = sensorDictionary["humidity"]
					let temperature = sensorDictionary["temperature"]
					let voc = sensorDictionary["voc"]
					let ozone = sensorDictionary["ozone1"]
					let pm25 = sensorDictionary["pm2.5"]
					let pressure = sensorDictionary["pressure"]
					let pm10 = sensorDictionary["pm10"]
					let pm1 = sensorDictionary["pm1.0"]

					var composedDictionary : [String : Any] = [:]
					composedDictionary["humidity"] = humidity
					composedDictionary["temperature"] = temperature
					composedDictionary["voc"] = voc
					composedDictionary["ozone"] = ozone
					composedDictionary["pm25"] = pm25

					// Convert to barometric pressure from milibars
					if let pressure = pressure as? Double {
						let barometer = pressure * 0.0295301
						composedDictionary["barometric_pressure"] = barometer
					}
					composedDictionary["pm10"] = pm10
					composedDictionary["pm1"] = pm1

					let awareData = AwareData(composedDictionary)
					DispatchQueue.main.async {
						completion(awareData)
					}
				}
			}
		}
	}
}
