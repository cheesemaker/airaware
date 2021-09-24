//
//  AwairData.swift
//  AirAware
//
//  Created by Jonathan Hays on 9/15/21.
//

import Foundation

public class AwareData {
	public let temperature : Double
	public let humidity : Double
	public let co2 : Double
	public let voc : Double
	public let pm25 : Double
	public let lux : Double
	public let spl_a : Double
	public let score : Int

	init(_ dictionary : [String:Any]) {
		temperature = dictionary["temp"] as? Double ?? -1
		humidity = dictionary["humid"] as? Double ?? -1
		co2 = dictionary["co2"] as? Double ?? -1
		voc = dictionary["voc"] as? Double ?? -1
		pm25 = dictionary["pm25"] as? Double ?? -1
		lux = dictionary["lux"] as? Double ?? -1
		spl_a = dictionary["spl_a"] as? Double ?? -1
		score = dictionary["score"] as? Int ?? -1
	}
}
