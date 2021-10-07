//
//  AwareService.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/15/21.
//

import UIKit

public class AwairService : NSObject {

	public static func setup(clientID : String, clientSecret: String, redirectURL : String) {
		AwairService.sharedInstance = AwairService(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
	}

	public static func setup(accessToken : String) {
		AwairService.sharedInstance = AwairService(accessToken: accessToken)
	}

	public static var shared : AwairService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if AwairService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return AwairService.sharedInstance
	}

	var savedAccessToken : String {
		if let token = UserDefaults.standard.string(forKey: AwairService.accessTokenStorageKey + "::" + self.clientID) {
			return token
		}

		return ""
	}

	var savedRefreshToken : String {
		if let token = UserDefaults.standard.string(forKey: AwairService.refreshTokenStorageKey + "::" + self.clientID) {
			return token
		}

		return ""
	}

	func saveTokens(accessToken : String, refreshToken : String) {
		UserDefaults.standard.setValue(accessToken, forKey: AwairService.accessTokenStorageKey + "::" + self.clientID)
		UserDefaults.standard.setValue(refreshToken, forKey: AwairService.refreshTokenStorageKey + "::" + self.clientID)
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

	private static let accessTokenStorageKey = "AwairService::AccessToken"
	private static let refreshTokenStorageKey = "AwairService::RefreshToken"

	// This must be set via the static setup functions
	private static var sharedInstance : AwairService!
}



