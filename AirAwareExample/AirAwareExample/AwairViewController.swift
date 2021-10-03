//
//  AwairViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 10/1/21.
//

import UIKit
import AirAware
import UUSwiftNetworking


class AwairViewController: UIViewController {

	// Awair login views...
	@IBOutlet var awareDeviceView : UIView!
	@IBOutlet var awareDeviceLoginView : UIView!

	// Awair data display objects/labels...
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
	@IBOutlet var deviceNameLabel : UILabel!

	var devices : [AwareDevice] = []

	// These are the AirAware keys. You can/should replace with your own...
	private let clientID = "12d1f95f0f4a4228b58c1936484ee1b2"
	private let clientSecret = "3d28a325142f47a1a2e750a9a213dd15"
	private let redirectURL = "http://airaware.dev"

    override func viewDidLoad() {
        super.viewDidLoad()

		// Setup the service!
		AwairService.setup(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)

		// Style the views so we look good...
		self.styleViews()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if AwairService.shared.needsLogin() {
			self.awareDeviceView.isHidden = true
			self.awareDeviceLoginView.isHidden = false
		}
		else {
			self.awareDeviceView.isHidden = false
			self.awareDeviceLoginView.isHidden = true
			self.refreshAwareDevice()
		}
	}

	func styleViews() {
		self.awareDeviceView.layer.cornerRadius = 8.0
		self.awareDeviceLoginView.layer.cornerRadius = 8.0
	}

	@IBAction func onAwareLogin() {
		AwairService.shared.promptForUserLogin(viewController: self) { complete in
			if complete {
				self.awareDeviceView.isHidden = false
				self.awareDeviceLoginView.isHidden = true

				self.refreshAwareDevice()
			}
		}
	}

	@IBAction func refreshAwareDevice() {

		AwairService.shared.fetchDevices { devices in
			self.devices = devices
			self.refreshCurrentDevice()
		}
	}

	@IBAction func refreshCurrentDevice() {

		if let device = self.devices.first {

			device.fetchAwairDisplayMode { mode in
				self.mode.text = mode
			}

			device.fetchAwairPowerStatus { battery, plugged in
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


			//AwairService.shared.fetchCurrentData(device: device) { data in
			AwairService.shared.fetchLatestAverageData(device: device) { data in

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
}


extension AwairViewController : UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}




