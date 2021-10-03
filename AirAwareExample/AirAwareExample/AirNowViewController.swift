//
//  AirNowViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 10/1/21.
//

import UIKit
import AirAware
import CoreLocation
import UUSwiftNetworking

class AirNowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.styleViews()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

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
		self.airNowUserNameField.textContentType = .username
		self.airNowPasswordField.textContentType = .password
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

	@IBAction func refreshAirNow() {

		self.locationManager.delegate = self
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
	}



	// AirNow login views...
	@IBOutlet var airNowLoginView : UIView!
	@IBOutlet var airNowView : UIView!
	@IBOutlet var airNowUserNameField : UITextField!
	@IBOutlet var airNowPasswordField : UITextField!

	// AirNow display objects...
	@IBOutlet var aqiLabel : UILabel!


	// A few helper functions to manage state+location
	let locationManager = CLLocationManager()
}


extension AirNowViewController : CLLocationManagerDelegate {

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


extension AirNowViewController : UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}
