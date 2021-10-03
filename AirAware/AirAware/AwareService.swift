//
//  AwareService.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/2/21.
//

import Foundation

protocol AwareService {

	func needsLogin() -> Bool
	func fetchDevices(_ completion : @escaping([AwareDevice])->Void)
	func fetchLatestData(device : AwareDevice, _ completion : @escaping(AwareData)->Void)

}
