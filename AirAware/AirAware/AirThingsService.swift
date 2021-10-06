//
//  AirThingsService.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/3/21.
//

import UIKit

let airThingsSecret = "9ed0882b-821b-4bf3-aaa7-2cea04805c98"
let airThingsId = "28cd34ac-d22d-4c63-a86d-79d2ce3ffd19"

public class AirThingsService : NSObject {

	public static func setup(clientID : String, clientSecret: String, redirectURL : String) {
		AirThingsService.sharedInstance = AirThingsService(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
	}

	public static func setup(accessToken : String) {
		AirThingsService.sharedInstance = AirThingsService(accessToken: accessToken)
	}

	public static var shared : AirThingsService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if AirThingsService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return AirThingsService.sharedInstance
	}

	var savedAccessToken : String {
		if let token = UserDefaults.standard.string(forKey: AirThingsService.accessTokenStorageKey + "::" + self.clientID) {
			return token
		}

		return ""
	}

	func saveTokens(accessToken : String) {
		UserDefaults.standard.setValue(accessToken, forKey: AirThingsService.accessTokenStorageKey + "::" + self.clientID)
	}

	private init(accessToken : String) {
		super.init()
		self.accessToken = accessToken
	}

	private init(clientID : String, clientSecret : String, redirectURL : String) {
		super.init()
		self.clientID = clientID
		self.clientSecret = clientSecret
		self.redirectURL = redirectURL
		self.accessToken = self.savedAccessToken
	}

	var loginCompletion : ((Bool)->Void)? = nil
	var accessToken : String = ""
	var clientID : String = ""
	var clientSecret : String = ""
	var redirectURL : String = ""

	private static let accessTokenStorageKey = "AirThingsService::AccessToken"

	// This must be set via the static setup functions
	private static var sharedInstance : AirThingsService!
}
