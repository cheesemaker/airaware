//
//  ViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 9/23/21.
//

import UIKit
import AirAware
import CoreLocation
import UUSwiftNetworking

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.styleViews()

		// Setup the service!
		AwareService.setup(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if AwareService.shared.needsLogin() {
			self.awareDeviceView.isHidden = true
			self.awareDeviceLoginView.isHidden = false
		}
		else {
			self.awareDeviceView.isHidden = false
			self.awareDeviceLoginView.isHidden = true
			self.refreshAwareDevice()
		}

		if AirNowService.shared.needsLogin() {
			self.airNowView.isHidden = true
			self.airNowLoginView.isHidden = false
		}
		else {
			self.airNowView.isHidden = false
			self.airNowLoginView.isHidden = true
			self.refreshAirNow()
		}
	}


	func styleViews() {
		self.airNowView.layer.cornerRadius = 8.0
		self.airNowLoginView.layer.cornerRadius = 8.0
		self.awareDeviceView.layer.cornerRadius = 8.0
		self.awareDeviceLoginView.layer.cornerRadius = 8.0

		self.airNowUserNameField.textContentType = .username
		self.airNowPasswordField.textContentType = .password
	}

	@IBAction func onAwareLogin() {
		AwareService.shared.promptForUserLogin(viewController: self) { complete in
			if complete {
				self.awareDeviceView.isHidden = false
				self.awareDeviceLoginView.isHidden = true

				self.refreshAwareDevice()
			}
		}
	}

	@IBAction func onAirNowLogin() {

		// 		AirNowService.shared.promptForUserLogin(viewController: self) { complete in
		AirNowService.shared.login(username: self.airNowUserNameField.text!, password: self.airNowPasswordField.text!) { complete in
			if complete {
				self.airNowView.isHidden = false
				self.airNowLoginView.isHidden = true

				self.refreshAirNow()
			}
		}
	}

	@IBAction func refreshAwareDevice() {
		AwareService.shared.fetchDevices { devices in

			self.devices = devices
			self.refreshDevice()
		}
	}

	@IBAction func refreshAirNow() {
		self.locationManager.delegate = self
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
	}

	func refreshDevice() {

		if let device = self.devices.first {

			device.fetchDisplayMode { mode in
				self.mode.text = mode
			}

			device.fetchPowerStatus { battery, plugged in
				// Default to not displaying since not all devices support fetching the power status...
				self.batteryStatus.text = ""
				self.pluggedStatus.text = ""

				if let battery = battery {
					self.batteryStatus.text = "\(battery)%"
				}
				if let plugged = plugged {
					self.pluggedStatus.text = plugged ? "Charging" : "Unplugged"
				}
			}

			AwareService.shared.fetchLatestAverageData(device: device) { data in
				//AwairService.shared.fetchCurrentData(device: device) { data in

				self.scoreLabel.text = data.intString(data.score)
				self.temperatureLabel.text = data.string(data.temperature)
				self.humidityLabel.text = data.string(data.humidity)
				self.co2Label.text = data.string(data.co2)
				self.vocLabel.text = data.string(data.voc)
				self.pm25Label.text = data.string(data.pm25)
				self.deviceNameLabel.text = device.name
			}

		}
	}


	@IBOutlet var scoreLabel : UILabel!
	@IBOutlet var temperatureLabel : UILabel!
	@IBOutlet var humidityLabel : UILabel!
	@IBOutlet var co2Label : UILabel!
	@IBOutlet var vocLabel : UILabel!
	@IBOutlet var pm25Label : UILabel!
	@IBOutlet var spl_aLabel: UILabel!
	@IBOutlet var mode : UILabel!
	@IBOutlet var pluggedStatus : UILabel!
	@IBOutlet var batteryStatus : UILabel!
	@IBOutlet var aqiLabel : UILabel!
	@IBOutlet var deviceNameLabel : UILabel!

	@IBOutlet var awareDeviceView : UIView!
	@IBOutlet var airNowView : UIView!
	@IBOutlet var awareDeviceLoginView : UIView!
	@IBOutlet var airNowLoginView : UIView!

	@IBOutlet var airNowUserNameField : UITextField!
	@IBOutlet var airNowPasswordField : UITextField!

	let locationManager = CLLocationManager()
	var devices : [AwareDevice] = []

	private let clientID = "12d1f95f0f4a4228b58c1936484ee1b2"
	private let clientSecret = "3d28a325142f47a1a2e750a9a213dd15"
	private let redirectURL = "http://airaware.dev"

}


extension ViewController : UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}

extension ViewController : CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		if let location = locations.first {

			manager.stopUpdatingLocation()

			AirNowService.shared.fetchLatest(location: location.coordinate) { data in
				self.aqiLabel.text = data.intString(data.score)
			}
		}
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		manager.startUpdatingLocation()
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		manager.startUpdatingLocation()
	}
}
