//
//  AwareService.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/15/21.
//

import UIKit

public class AwareService : NSObject {

	public static func setup(clientID : String, clientSecret: String, redirectURL : String) {
		AwareService.sharedInstance = AwareService(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
	}

	public static func setup(accessToken : String) {
		AwareService.sharedInstance = AwareService(accessToken: accessToken)
	}

	public static var shared : AwareService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if AwareService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return AwareService.sharedInstance
	}

	private var savedAccessToken : String {
		if let token = UserDefaults.standard.string(forKey: AwareService.accessTokenStorageKey + "::" + self.clientID) {
			return token
		}

		return ""
	}

	private var savedRefreshToken : String {
		if let token = UserDefaults.standard.string(forKey: AwareService.refreshTokenStorageKey + "::" + self.clientID) {
			return token
		}

		return ""
	}

	func saveTokens(accessToken : String, refreshToken : String) {
		UserDefaults.standard.setValue(accessToken, forKey: AwareService.accessTokenStorageKey + "::" + self.clientID)
		UserDefaults.standard.setValue(refreshToken, forKey: AwareService.refreshTokenStorageKey + "::" + self.clientID)
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

	private static let accessTokenStorageKey = "AwareService::AccessToken"
	private static let refreshTokenStorageKey = "AwareService::RefreshToken"

	// This must be set via the static setup functions
	private static var sharedInstance : AwareService!
}



