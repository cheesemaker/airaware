//
//  WeatherFlowService.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/1/21.
//

import UIKit

public class WeatherFlowService : NSObject {

	public static func setup(clientID : String, clientSecret: String, redirectURL : String) {
		WeatherFlowService.sharedInstance = WeatherFlowService(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
	}

	public static func setup(accessToken : String) {
		WeatherFlowService.sharedInstance = WeatherFlowService(accessToken: accessToken)
	}

	public static var shared : WeatherFlowService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if WeatherFlowService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return WeatherFlowService.sharedInstance
	}

	var savedAccessToken : String {
		if let token = UserDefaults.standard.string(forKey: WeatherFlowService.accessTokenStorageKey + "::" + self.clientID) {
			return token
		}

		return ""
	}

	func saveTokens(accessToken : String) {
		UserDefaults.standard.setValue(accessToken, forKey: WeatherFlowService.accessTokenStorageKey + "::" + self.clientID)
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

	private static let accessTokenStorageKey = "WeatherFlowService::AccessToken"

	// This must be set via the static setup functions
	private static var sharedInstance : WeatherFlowService!
}
