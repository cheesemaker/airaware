//
//  AirThingsBluetoothScanner.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/13/21.
//

import Foundation
import CoreBluetooth
import UUSwiftBluetooth

class AirThingsBluetoothDevice : AwareDevice {

	enum deviceType {
		case unknown
		case waveMini
		case wavePlus
		case wave2
	}

	var type : deviceType = .unknown
	let peripheral : UUPeripheral

	init(peripheral : UUPeripheral, _ dictionary : [String : Any]) {
		self.peripheral = peripheral
		super.init(dictionary)
	}
}

public class AirThingsBluetoothService : AwareService {

	public static let shared = AirThingsBluetoothService()

	public func needsLogin() -> Bool {
		return false
	}

	public func fetchAllDevices(_ completion: @escaping ([AwareDevice]) -> Void) {
		self.startScan(completion)
	}

	public func fetchLatestData(device: AwareDevice, _ completion: @escaping (AwareData) -> Void) {
		if let device = device as? AirThingsBluetoothDevice {
			if let characteristic = self.findDataCharacteristic(device.peripheral) {
				self.readCharacteristicData(device.peripheral, characteristic: characteristic, completion: completion)
			}
			else {
				self.discoverServices(device.peripheral, completion)
			}
		}
	}

	private func findDataCharacteristic(_ peripheral : UUPeripheral) -> CBCharacteristic? {
		if let services = peripheral.services {
			for service in services {
				if let characteristics = service.characteristics {
					for characteristic in characteristics {
						if characteristic.uuid.uuidString.lowercased().contains("ade7-11e4-89d3-123b93f75cba") {
							return characteristic
						}
					}
				}
			}
		}

		return nil
	}


	private var devices : [AirThingsBluetoothDevice] = []

	private func startScan(_ completion: @escaping ([AwareDevice]) -> Void) {
		UUCentralManager.shared.startScan(serviceUuids: nil, allowDuplicates: false, peripheralFactory: nil, filters: nil) { peripheral in

			if peripheral.name.contains("Airthings") {
				
				var dictionary : [String : Any] = [:]
				dictionary["name"] = peripheral.name
				dictionary["deviceId"] = peripheral.identifier
				dictionary["deviceType"] = peripheral.name

				let device = AirThingsBluetoothDevice(peripheral: peripheral, dictionary)
				self.devices.append(device)

				DispatchQueue.main.async {
					completion(self.devices)
				}
			}

		}
		willRestoreCallback: { state in
		}
	}

	private func discoverServices(_ peripheral : UUPeripheral, _ completion: @escaping (AwareData) -> Void) {
		peripheral.connect { peripheral in
			peripheral.discoverServices { peripheral, error in
				self.interrogateServices(peripheral, completion)
			}
		}
		disconnected: { peripheral, error in
		}
	}

	private func interrogateServices(_ peripheral : UUPeripheral, _ completion: @escaping (AwareData) -> Void) {
		if let services = peripheral.services {
			for service in services {

				let uuid : CBUUID = service.uuid
				if uuid.uuidString.lowercased().contains("123b93f75cba") {
					self.discoverCharacteristics(peripheral, service: service, completion: completion)
				}
			}
		}
	}

	private func discoverCharacteristics(_ peripheral : UUPeripheral, service : CBService, completion: @escaping (AwareData) -> Void) {

		peripheral.discoverCharacteristics(nil, for: service) { peripheral, error in

			if let characteristic = self.findDataCharacteristic(peripheral) {
				self.readCharacteristicData(peripheral, characteristic: characteristic, completion: completion)
			}
		}
	}

	private func readCharacteristicData(_ peripheral : UUPeripheral, characteristic : CBCharacteristic, completion: @escaping (AwareData) -> Void) {

		peripheral.readValue(for: characteristic) { peripheral, characteristic, error in

			if let data = characteristic.value {
				var temp = Float(data.doubleBytes[1])
				temp = temp / 100.0
				temp = temp - 273.15

				var humidity = Float(data.doubleBytes[3])
				humidity = humidity / 100.0

				let voc = Float(data.doubleBytes[4])

				var dictionary : [String : Any] = [:]
				dictionary["temperature"] = AwareData.convertCelsiusToFahrenheit(Double(temp))
				dictionary["voc"] = voc
				dictionary["humidity"] = humidity

				let data = AwareData(dictionary)
				DispatchQueue.main.async {
					completion(data)
				}
			}
		}
	}
}


extension Data {
	var bytes: [UInt8] {
		return [UInt8](self)
	}

	var doubleBytes : [UInt16] {
		return [UInt16](withUnsafeBytes { $0.bindMemory(to: UInt16.self) })
	}

}
