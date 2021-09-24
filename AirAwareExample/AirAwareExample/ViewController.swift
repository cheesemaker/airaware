//
//  ViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 9/23/21.
//

import UIKit
import AirAware

class ViewController: UIViewController {

	@IBOutlet var scoreLabel : UILabel!
	@IBOutlet var temperatureLabel : UILabel!
	@IBOutlet var humidityLabel : UILabel!
	@IBOutlet var co2Label : UILabel!
	@IBOutlet var vocLabel : UILabel!
	@IBOutlet var pm25Label : UILabel!
	@IBOutlet var luxLabel : UILabel!
	@IBOutlet var spl_aLabel: UILabel!
	@IBOutlet var mode : UILabel!

	var devices : [AwareDevice] = []

	private let clientID = "12d1f95f0f4a4228b58c1936484ee1b2"
	private let clientSecret = "3d28a325142f47a1a2e750a9a213dd15"
	private let redirectURL = "http://homemonitor.spsw.io"
	private let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTAzNDI3In0.Q8-rhqntPlspO2F2DU_gH7ho9lojIr9goui5dkdCEXk"


	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup the service!
		AwareService.setup(clientID: clientID, clientSecret: clientSecret, redirectURL: redirectURL)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if AwareService.shared.needsLogin() {
			AwareService.shared.promptForUserLogin(viewController: self) { complete in
				if complete {
					self.refreshService()
				}
			}
		}
		else {
			self.refreshService()
		}
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	@IBAction func refreshService() {
		AwareService.shared.fetchDevices { devices in

			self.devices = devices
			self.refreshDevice()
		}
	}

	@IBAction func refreshDevice() {

		if let device = self.devices.first {

			device.fetchDisplayMode { mode in
				self.mode.text = mode
			}

			AwareService.shared.fetchLatestAverageData(device: device) { data in
				//AwairService.shared.fetchCurrentData(device: device) { data in

				self.scoreLabel.text = data.score != -1 ? String(data.score) : "Unavailable"
				self.temperatureLabel.text = data.temperature != -1 ? String(data.temperature) : "Unavailable"
				self.humidityLabel.text = data.humidity != -1 ? String(data.humidity) : "Unavailable"
				self.co2Label.text = data.co2 != -1 ? String(data.co2) : "Unavailable"
				self.vocLabel.text = data.voc != -1 ? String(data.voc) : "Unavailable"
				self.pm25Label.text = data.pm25 != -1 ? String(data.pm25) : "Unavailable"
				self.luxLabel.text = data.lux != -1 ? String(data.lux) : "Unavailable"
				//self.spl_aLabel.text = String(data.spl_a)
			}

		}
	}
}
