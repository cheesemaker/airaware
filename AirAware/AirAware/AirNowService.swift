//
//  AirNowService.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/28/21.
//

import Foundation
import CoreLocation

public class AirNowService : NSObject {

	public static let shared = AirNowService()

	var accessToken : String {
		get {
			if let token = UserDefaults.standard.string(forKey: AirNowService.accessTokenStorageKey) {
				return token
			}

			return ""
		}

		set {
			UserDefaults.standard.set(newValue, forKey:AirNowService.accessTokenStorageKey)
		}
	}

	static let locationManager = CLLocationManager()

	var fetchLatestCompletion : ((AwareData) -> Void)? = nil
	var loginCompletion : ((Bool)->Void)? = nil
	var location : CLLocationCoordinate2D? = nil
	var zipcode : String? = nil

	private override init() {
		super.init()
	}

	private static let accessTokenStorageKey = "AwareAirNowService::AccessToken"
}


