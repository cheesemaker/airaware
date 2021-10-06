//
//  AirNowService.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/28/21.
//

import Foundation
import CoreLocation

public class AirNowService : NSObject {

	public static func setup(zipcode : String) {
		AirNowService.sharedInstance = AirNowService()
		AirNowService.sharedInstance.zipcode = zipcode
	}

	public static func setup(location : CLLocationCoordinate2D) {
		AirNowService.sharedInstance = AirNowService()
		AirNowService.sharedInstance.location = location
	}

	public static var shared : AirNowService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if AirNowService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return AirNowService.sharedInstance
	}

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

	private static let accessTokenStorageKey = "AwareAirNowService::AccessToken"
	private static var sharedInstance : AirNowService!
	var loginCompletion : ((Bool)->Void)? = nil
	var location : CLLocationCoordinate2D? = nil
	var zipcode : String? = nil


	private override init() {
		super.init()
	}
}


