//
//  OpenWeatherService+Fetch.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/6/21.
//

import Foundation
import CoreLocation
import UUSwiftNetworking

extension OpenWeatherService : AwareService {

	func needsLogin() -> Bool {
		return false
	}

	public func fetchAllDevices(_ completion: @escaping ([AwareDevice]) -> Void) {

		// We create a single device that represents the AirNow EPA network...
		DispatchQueue.main.async {
			var dictionary : [String : Any] = [:]
			dictionary["name"] = "OpenWeather"
			if let location = self.location {
				dictionary["latitude"] = location.latitude
				dictionary["longitude"] = location.longitude
			}
			let device = AwareDevice(["name": "OpenWeather"])
			completion([device])
		}
	}

	public func fetchLatestData(device: AwareDevice, _ completion: @escaping (AwareData) -> Void) {

		// If we have a location, then prefer that over zipcode
		if let location = self.location {
			fetchLatestData(location: location, completion)
		}
		else if let location = OpenWeatherService.locationManager.location {
			fetchLatestData(location: location.coordinate, completion)
		}
		else {
			self.fetchLatestCompletion = completion
			OpenWeatherService.locationManager.delegate = self
			OpenWeatherService.locationManager.requestWhenInUseAuthorization()
			OpenWeatherService.locationManager.startUpdatingLocation()
		}
	}

	public func fetchLatestData(location: CLLocationCoordinate2D, _ completion : @escaping(AwareData)->Void) {
		let path = OpenWeatherService.latestWeatherPath + "?lat=\(location.latitude)&lon=\(location.longitude)&units=imperial&appid=" + self.accessToken

		UUHttpSession.get(url: path) { response in
			if let dictionary = response.parsedResponse as? [String : Any] {

				var composedDictionary : [String : Any] = [:]
				composedDictionary["latitude"] = location.latitude
				composedDictionary["longitude"] = location.longitude

				if let main = dictionary["main"] as? [String : Any] {
					let temp = main["temp"]
					let pressure = main["pressure"]
					let humidity = main["humidity"]

					composedDictionary["temperature"] = temp
					composedDictionary["humidity"] = humidity
					if let pressure = pressure as? Double {
						composedDictionary["barometric_pressure"] = AwareData.convertPressureToBarometric(pressure)
					}
				}

				if let wind = dictionary["wind"] as? [String:Any] {
					if let windSpeed = wind["speed"] as? Double {
						composedDictionary["wind_speed"] = windSpeed
					}
				}

				let data = AwareData(composedDictionary)
				DispatchQueue.main.async {
					completion(data)
				}
			}
		}
	}



}


extension OpenWeatherService : CLLocationManagerDelegate {

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		if let location = locations.first {
			manager.stopUpdatingLocation()
			manager.delegate = nil
			self.location = location.coordinate
			if let completion = self.fetchLatestCompletion {
				self.fetchLatestData(location: location.coordinate, completion)
			}
		}
	}
}
