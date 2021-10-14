//
//  ViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 9/23/21.
//

import UIKit
import AirAware
import CoreLocation
import UUSwiftBluetooth
import CoreBluetooth
import SwiftUI

// Insert the ID's and keys for your project here...
let awairClientID = ""
let awairClientSecret = ""
let awairRedirectURL = ""
let weatherFlowClientID = ""
let weatherFlowSecret = ""
let weatherFlowRedirectURL = ""
let purpleReadKey = ""
let openWeatherKey = ""



class ViewController: UIViewController {

	let airNowLoginButton = UIButton()
	let awairLoginButton = UIButton()
	let weatherFlowLoginButton = UIButton()
	let purpleAirLoginButton = UIButton()
	let openWeatherLoginButton = UIButton()
	let airThingsLoginButton = UIButton()

	let stackView = UIStackView()

	// A few helper functions to manage state+location
	let locationManager = CLLocationManager()



	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupStackView()
		self.setupAirNowService()
		self.setupAwairService()
		self.setupWeatherFlowService()
		self.setupPurpleAirService()
		self.setupOpenWeatherService()
		self.setupAirThingsService()
	}

	func setupStackView() {
		self.stackView.backgroundColor = .lightGray
		self.stackView.layer.cornerRadius = 8.0
		self.stackView.clipsToBounds = true
		self.view.addSubview(self.stackView)
		self.stackView.translatesAutoresizingMaskIntoConstraints = false
		self.stackView.axis = .vertical
		self.stackView.spacing = 16.0
		self.stackView.distribution = .equalSpacing
		self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
		self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
	}


	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: -
	// MARK: Awair

	func setupAwairService() {
		AwairService.setup(clientID: awairClientID, clientSecret: awairClientSecret, redirectURL: awairRedirectURL)
		self.awairLoginButton.addTarget(self, action: #selector(onAwairLogin), for: .touchUpInside)
		self.awairLoginButton.setTitle("Awair Login", for: .normal)
		if AwairService.shared.needsLogin() {
			self.stackView.addArrangedSubview(self.awairLoginButton)
		}
		else {
			self.updateAwairDevice()
		}
	}

	func updateAwairDevice() {
		AwairService.shared.fetchAllDevices { devices in
			if let device = devices.first {
				AwairService.shared.fetchLatestData(device: device) { data in
					let view = AwareDataView(title: device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}
		}
	}

	@objc func onAwairLogin() {
		AwairService.shared.promptForUserLogin(viewController: self) { complete in
			if complete {
				self.awairLoginButton.removeFromSuperview()
				self.updateAwairDevice()
			}
		}
	}

	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: -
	// MARK: AirThings

	func setupAirThingsService() {
		self.airThingsLoginButton.addTarget(self, action: #selector(onAirThingsLogin), for: .touchUpInside)
		self.airThingsLoginButton.setTitle("Scan For AirThings", for: .normal)
		self.stackView.addArrangedSubview(self.airThingsLoginButton)
	}

	@objc func onAirThingsLogin() {
		self.airThingsLoginButton.isEnabled = false
		self.airThingsLoginButton.setTitle("Scanning for AirThings...", for: .normal)

		AirThingsBluetoothService.shared.fetchAllDevices { devices in
			if let device = devices.first {
				AirThingsBluetoothService.shared.fetchLatestData(device: device) { data in
					self.airThingsLoginButton.removeFromSuperview()
					let view = AwareDataView(title: device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}
		}
	}


	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: -
	// MARK: WeatherFlow

	func setupWeatherFlowService() {

		WeatherFlowService.setup(clientID: weatherFlowClientID, clientSecret: weatherFlowSecret, redirectURL: weatherFlowRedirectURL)

		self.weatherFlowLoginButton.addTarget(self, action: #selector(onWeatherFlowLogin), for: .touchUpInside)
		self.weatherFlowLoginButton.setTitle("WeatherFlow Login", for: .normal)
		if WeatherFlowService.shared.needsLogin() {
			self.stackView.addArrangedSubview(self.weatherFlowLoginButton)
		}
		else {
			self.updateWeatherFlow()
		}
	}

	func updateWeatherFlow() {

		WeatherFlowService.shared.fetchAllDevices { devices in
			if let device = devices.first {
				WeatherFlowService.shared.fetchLatestData(device: device) { data in
					let view = AwareDataView(title: "WeatherFlow: " + device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}
		}
	}

	@objc func onWeatherFlowLogin() {
		WeatherFlowService.shared.promptForUserLogin(viewController: self) { complete in

			if complete {
				self.weatherFlowLoginButton.removeFromSuperview()
				self.updateWeatherFlow()
			}
		}
	}



	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: -
	// MARK: AirNow

	func setupAirNowService() {

		self.airNowLoginButton.addTarget(self, action: #selector(onAirNowLogin), for: .touchUpInside)
		self.airNowLoginButton.setTitle("AirNow Login", for: .normal)
		if AirNowService.shared.needsLogin() {
			self.stackView.addArrangedSubview(self.airNowLoginButton)
		}
		else {
			self.updateAirNowService()
		}
	}

	func updateAirNowService() {
		AirNowService.shared.fetchAllDevices { devices in
			if let device = devices.first {
				AirNowService.shared.fetchLatestData(device: device) { data in
					let view = AwareDataView(title: "AirNow", data)
					self.stackView.addArrangedSubview(view)
				}
			}
		}
	}

	@objc func onAirNowLogin() {
		AirNowService.shared.promptForUserLogin(viewController: self) { complete in
			if complete{
				self.airNowLoginButton.removeFromSuperview()
				self.updateAirNowService()
			}
		}
	}



	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: -
	// MARK: PurpleAir

	func setupPurpleAirService() {
		PurpleAirService.setup(accessToken: purpleReadKey)
		self.purpleAirLoginButton.setTitle("PurpleAir Login", for: .normal)
		self.purpleAirLoginButton.addTarget(self, action: #selector(onPurpleAirLogin), for: .touchUpInside)

		if self.locationManager.location != nil {
			self.updatePurpleAirService()
		}
		else {
			self.stackView.addArrangedSubview(self.purpleAirLoginButton)
		}
	}

	func updatePurpleAirService() {

		if let location = self.locationManager.location {
			PurpleAirService.shared.findClosestDevice(location: location.coordinate) { device in
				PurpleAirService.shared.fetchLatestData(device: device) { data in

					let view = AwareDataView(title: "PurpleAir: " + device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}
		}
	}

	@objc func onPurpleAirLogin() {
		self.locationManager.delegate = self
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.purpleAirLoginButton.removeFromSuperview()
	}


	// ///////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: -
	// MARK: OpenWeather

	func setupOpenWeatherService() {
		OpenWeatherService.setup(accessToken: openWeatherKey)
		self.openWeatherLoginButton.setTitle("OpenWeather Login", for: .normal)
		self.openWeatherLoginButton.addTarget(self, action: #selector(onOpenWeatherLogin), for: .touchUpInside)
		self.stackView.addArrangedSubview(self.openWeatherLoginButton)
	}


	@objc func onOpenWeatherLogin() {

		self.openWeatherLoginButton.removeFromSuperview()
		OpenWeatherService.shared.fetchAllDevices { devices in
			if let device = devices.first {
				OpenWeatherService.shared.fetchLatestData(device: device) { data in

					let view = AwareDataView(title: "OpenWeather: " + device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}
		}
	}
}



// ///////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: CLLocationManagerDelegate

extension ViewController : CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		manager.stopUpdatingLocation()
		manager.delegate = nil

		self.updatePurpleAirService()
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		manager.startUpdatingLocation()
	}

}


