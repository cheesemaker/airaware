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


class ViewController: UIViewController {

	// A few helper functions to manage state+location
	let locationManager = CLLocationManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		PurpleAirService.setup(accessToken: purpleReadKey)
		WeatherFlowService.setup(clientID: weatherFlowClientID, clientSecret: weatherFlowSecret, redirectURL: weatherFlowRedirectURL)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		

		/*
		if WeatherFlowService.shared.needsLogin() {
			WeatherFlowService.shared.promptForUserLogin(viewController: self) { complete in

			}
		}

		WeatherFlowService.shared.fetchDevices { devices in
			WeatherFlowService.shared.fetchCurrentData(device: devices.first!) { data in
				let view = AwareDataView(title: "Outside", data)
				self.view.addSubview(view)
				view.translatesAutoresizingMaskIntoConstraints = false
				view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
				view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
			}
		}
		 */

		self.locationManager.delegate = self
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
	}

}



extension ViewController : CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		if let location = locations.first {

			manager.stopUpdatingLocation()

			PurpleAirService.shared.findClosestDevice(location: location.coordinate) { device in
				PurpleAirService.shared.fetchLatestData(device: device) { data in

					let view = AwareDataView(title: device.name, data)
					self.view.addSubview(view)
					view.translatesAutoresizingMaskIntoConstraints = false
					view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
					view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

				}
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


