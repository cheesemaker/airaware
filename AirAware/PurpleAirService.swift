//
//  PurpleAirService.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/4/21.
//

import Foundation

public class PurpleAirService : NSObject {

	public static var shared : PurpleAirService {

		// If this occurs, it means that the application most likely failed to call either of the setup functions
		if PurpleAirService.sharedInstance == nil {
			fatalError("Attempting to access shared service object before static setup function called.")
		}

		return PurpleAirService.sharedInstance
	}


	public static func setup(accessToken : String) {
		PurpleAirService.sharedInstance = PurpleAirService(accessToken : accessToken)
	}

	public var accessToken : String!

	private init(accessToken : String) {
		super.init()
		self.accessToken = accessToken
	}

	// This must be set via the static setup functions
	private static var sharedInstance : PurpleAirService!
}
