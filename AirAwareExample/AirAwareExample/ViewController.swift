//
//  ViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 9/23/21.
//

import UIKit
import AirAware
import CoreLocation

let weatherFlowClientID = "697ac9ce-0310-4cc8-a73b-6f725b5473c8"
let weatherFlowSecret = "85a4e3ac-1a76-4a28-af2b-1dc48dbb5f07"
let weatherFlowRedirectURL = "weatherflow.airaware.dev"

let purpleReadKey = "22F80E0E-252A-11EC-BAD6-42010A800017"
let purpleWriteKey = "22F8D1A9-252A-11EC-BAD6-42010A800017"


// These are the AirAware keys. You can/should replace with your own...
private let awairClientID = "12d1f95f0f4a4228b58c1936484ee1b2"
private let awairClientSecret = "3d28a325142f47a1a2e750a9a213dd15"
private let awairRedirectURL = "http://airaware.dev"


class ViewController: UIViewController {

	let airNowLoginButton = UIButton()
	let awairLoginButton = UIButton()
	let weatherFlowLoginButton = UIButton()
	let purpleAirLoginButton = UIButton()
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
	}

	func setupStackView() {
		self.view.addSubview(self.stackView)
		self.stackView.translatesAutoresizingMaskIntoConstraints = false
		self.stackView.axis = .vertical
		self.stackView.spacing = 16.0
		self.stackView.distribution = .equalCentering
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


