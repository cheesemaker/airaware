//
//  AwareDataView.swift
//  AirAware
//
//  Created by Jonathan Hays on 10/3/21.
//

import UIKit

public class AwareDataView: UIView {

	let data : AwareData
	let stackView = UIStackView()

	public init(title: String, _ data : AwareData) {
		self.data = data
		super.init(frame: .zero)

		let titleLabel = UILabel()
		self.addSubview(titleLabel)
		titleLabel.text = title
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
		titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

		self.stackView.translatesAutoresizingMaskIntoConstraints = false
		self.stackView.axis = .vertical
		self.stackView.distribution = .fillEqually
		self.addSubview(self.stackView)
		self.stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
		self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0).isActive = true
		self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0).isActive = true
		self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0).isActive = true

		if let value = data.score {
			self.stackView.addArrangedSubview(self.createLabel(name: "Air Quality:", value: data.string(value)))
		}

		if let value = data.temperature {
			self.stackView.addArrangedSubview(self.createLabel(name: "Temperature:", value: data.string(value)))
		}

		if let value = data.humidity {
			self.stackView.addArrangedSubview(self.createLabel(name: "Humidity:", value: data.string(value)))
		}

		if let value = data.co2 {
			self.stackView.addArrangedSubview(self.createLabel(name: "CO2:", value: data.string(value)))
		}

		if let value = data.voc {
			self.stackView.addArrangedSubview(self.createLabel(name: "VOC:", value: data.string(value)))
		}

		if let value = data.pm25 {
			self.stackView.addArrangedSubview(self.createLabel(name: "PM25:", value: data.string(value)))
		}

		if let value = data.lux {
			self.stackView.addArrangedSubview(self.createLabel(name: "LUX:", value: data.string(value)))
		}

		if let value = data.spl_a {
			self.stackView.addArrangedSubview(self.createLabel(name: "SPL/A:", value: data.string(value)))
		}

		if let value = data.airDensity {
			self.stackView.addArrangedSubview(self.createLabel(name: "Air Density:", value: data.string(value)))
		}

		if let value = data.barometricPressure {
			self.stackView.addArrangedSubview(self.createLabel(name: "Barometer:", value: data.string(value)))
		}

		if let value = data.dewPoint {
			self.stackView.addArrangedSubview(self.createLabel(name: "Dew Point:", value: data.string(value)))
		}

		if let value = data.solarRadiation {
			self.stackView.addArrangedSubview(self.createLabel(name: "Solar Radiation:", value: data.string(value)))
		}

		self.clipsToBounds = true
		self.layer.cornerRadius = 8.0
		self.backgroundColor = .lightGray
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func createLabel(name: String, value: String) -> UIView {
		let nameLabel = UILabel()
		let valueLabel = UILabel()
		let stackview = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
		stackview.axis = .horizontal
		stackview.distribution = .fillEqually
		stackview.spacing = 16.0
		nameLabel.text = name
		valueLabel.text = value
		nameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
		valueLabel.font = UIFont.systemFont(ofSize: 14.0)
		return stackview
	}

}
