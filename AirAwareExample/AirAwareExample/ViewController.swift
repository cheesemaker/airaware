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

	let stackView = UIStackView()

	// A few helper functions to manage state+location
	let locationManager = CLLocationManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		PurpleAirService.setup(accessToken: purpleReadKey)
		WeatherFlowService.setup(clientID: weatherFlowClientID, clientSecret: weatherFlowSecret, redirectURL: weatherFlowRedirectURL)
		AwairService.setup(clientID: awairClientID, clientSecret: awairClientSecret, redirectURL: awairRedirectURL)

		
		self.view.addSubview(self.stackView)
		self.stackView.translatesAutoresizingMaskIntoConstraints = false
		self.stackView.axis = .vertical
		self.stackView.spacing = 16.0
		self.stackView.distribution = .equalCentering
		self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
		self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
		self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		

		if WeatherFlowService.shared.needsLogin() {
			WeatherFlowService.shared.promptForUserLogin(viewController: self) { complete in
				self.updateWeatherFlow()
			}
		}
		else {
			self.updateWeatherFlow()
		}

		if AwairService.shared.needsLogin() {
			AwairService.shared.promptForUserLogin(viewController: self) { complete in
				if complete {
					self.updateAwairDevice()
				}
			}
		}
		else {
			self.updateAwairDevice()
		}


		self.locationManager.delegate = self
		self.locationManager.requestWhenInUseAuthorization()
	}

	func updateAwairDevice() {
		AwairService.shared.fetchAllDevices { devices in
			if let device = devices.first {
				AwairService.shared.fetchLatestAverageData(device: device) { data in
					let view = AwareDataView(title: device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}
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

}



extension ViewController : CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		if let location = locations.first {

			manager.stopUpdatingLocation()
			manager.delegate = nil

			PurpleAirService.shared.findClosestDevice(location: location.coordinate) { device in
				PurpleAirService.shared.fetchLatestData(device: device) { data in

					let view = AwareDataView(title: "PurpleAir: " + device.name, data)
					self.stackView.addArrangedSubview(view)
				}
			}

			AirNowService.setup(location: location.coordinate)
			AirNowService.shared.fetchLatestData(location: location.coordinate) { data in
				let view = AwareDataView(title: "AirNow", data)
				self.stackView.addArrangedSubview(view)
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


