//
//  AirNowService+Fetch.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/28/21.
//

import Foundation
import CoreLocation
import UUSwiftCore
import UUSwiftNetworking
import CoreLocation

extension AirNowService : AwareService {

	public func fetchAllDevices(_ completion: @escaping ([AwareDevice]) -> Void) {

		// We create a single device that represents the AirNow EPA network...
		DispatchQueue.main.async {
			var dictionary : [String : Any] = [:]
			dictionary["name"] = "AirNow"
			if let location = self.location {
				dictionary["latitude"] = location.latitude
				dictionary["longitude"] = location.longitude
			}
			let device = AwareDevice(["name": "AirNow"])
			completion([device])
		}
	}

	public func fetchLatestData(device: AwareDevice, _ completion: @escaping (AwareData) -> Void) {

		// If we have a location, then prefer that over zipcode
		if let location = self.location {
			fetchLatestData(location: location, completion)
		}
		else if let zipcode = self.zipcode {
			fetchLatestData(zipcode, completion)
		}
		else if let location = AirNowService.locationManager.location {
			fetchLatestData(location: location.coordinate, completion)
		}
		else {
			self.fetchLatestCompletion = completion
			AirNowService.locationManager.delegate = self
			AirNowService.locationManager.requestWhenInUseAuthorization()
			AirNowService.locationManager.startUpdatingLocation()
		}
	}


	public func fetchOnDate(zipcode : String, date : Date = Date(), distance : Int = 25,  _ completion : @escaping(AwareData)->Void) {
		let dateString = date.uuFourDigitYear + "-" + date.uuNumericMonthOfYear + "-" + date.uuDayOfMonth
		let path = AirNowService.forecastPath + "?format=application/json&zipCode=\(zipcode)&date=\(dateString)&distance=\(distance)&API_KEY=\(self.accessToken)"

		UUHttpSession.get(url: path) { response in
			if let array = response.parsedResponse as? [[String : Any]] {
				var awareDictionary : [String : Any] = [:]
				for dictionary in array {
					if let aqi = dictionary["AQI"] as? Int {
						awareDictionary["score"] = aqi
					}
				}

				let awareData = AwareData(awareDictionary)
				DispatchQueue.main.async {
					completion(awareData)
				}
			}
		}
	}

	public func fetchLatestData(location: CLLocationCoordinate2D, distance : Int = 25, _ completion : @escaping(AwareData)->Void) {
		let path = AirNowService.latestByLatLongPath + "?format=application/json&latitude=\(location.latitude)&longitude=\(location.longitude)&distance=\(distance)&API_KEY=\(self.accessToken)"

		UUHttpSession.get(url: path) { response in
			if let array = response.parsedResponse as? [[String : Any]] {
				var awareDictionary : [String : Any] = [:]
				for dictionary in array {
					if let aqi = dictionary["AQI"] as? Int {
						awareDictionary["score"] = aqi
					}
				}

				let awareData = AwareData(awareDictionary)
				DispatchQueue.main.async {
					completion(awareData)
				}
			}
		}
	}

	public func fetchLatestData(_ zipcode : String,  _ completion : @escaping(AwareData)->Void) {

		let path = AirNowService.latestByZipcodePath + "?format=application/json&zipCode=\(zipcode)&distance=25&API_KEY=\(self.accessToken)"
		UUHttpSession.get(url: path) { response in
			if let array = response.parsedResponse as? [[String : Any]] {
				var awareDictionary : [String : Any] = [:]
				for dictionary in array {
					if let aqi = dictionary["AQI"] as? Int {
						awareDictionary["score"] = aqi
					}
				}

				let awareData = AwareData(awareDictionary)
				DispatchQueue.main.async {
					completion(awareData)
				}
			}
		}
	}

}


extension AirNowService : CLLocationManagerDelegate {

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

