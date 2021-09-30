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

extension AirNowService {

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

	public func fetchLatest(location: CLLocationCoordinate2D, distance : Int = 25, _ completion : @escaping(AwareData)->Void) {
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

	public func fetchLatest(_ zipcode : String,  _ completion : @escaping(AwareData)->Void) {

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


