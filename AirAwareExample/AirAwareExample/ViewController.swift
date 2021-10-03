//
//  ViewController.swift
//  AirAwareExample
//
//  Created by Jonathan Hays on 9/23/21.
//

import UIKit
import AirAware

let weatherFlowClientID = "697ac9ce-0310-4cc8-a73b-6f725b5473c8"
let weatherFlowSecret = "85a4e3ac-1a76-4a28-af2b-1dc48dbb5f07"
let weatherFlowRedirectURL = "weatherflow.airaware.dev"


class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		WeatherFlowService.setup(clientID: weatherFlowClientID, clientSecret: weatherFlowSecret, redirectURL: weatherFlowRedirectURL)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

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
	}

}






