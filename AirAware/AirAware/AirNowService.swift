//
//  AirNowService.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/28/21.
//

import Foundation

public class AirNowService : NSObject {

	public static let shared : AirNowService = AirNowService()


	private override init() {
		super.init()
	}

	var loginCompletion : ((Bool)->Void)? = nil
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
}


