//
//  AwareService.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/2/21.
//

import Foundation
import CoreLocation

protocol AwareService {

	func needsLogin() -> Bool
	func fetchAllDevices(_ completion : @escaping([AwareDevice])->Void)
	func findClosestDevice(location : CLLocationCoordinate2D, _ completion : @escaping(AwareDevice)->Void)
	func fetchLatestData(device : AwareDevice, _ completion : @escaping(AwareData)->Void)

}
