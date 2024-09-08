//
//  WeatherViewController.swift
//
//
//  Created by Denis on 04.09.2024.
//

import UIKit

protocol IWeatherView: AnyObject {
	func updateLabelText(with text: String)
}

final class WeatherViewController: UIViewController {
	private lazy var temperatureLabel: UILabel = makeTemperatureLabel()
	private lazy var refreshButton: UIButton = makeButton(
		color: .white,
		text: "Refresh",
		imageName: "repeat.circle"
	)
	
	var presenter: IWeatherPresenter?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpSubViews()
		setUpConstraints()
		view.backgroundColor = .gray
		refreshButton.addTarget(
			self,
			action: #selector(refreshAction),
			for: .touchUpInside
		)
		presenter?.refreshTemperature()
	}
	
	//MARK: - Private UI Methods
	private func setUpSubViews() {
		[
			temperatureLabel,
			refreshButton
		].forEach { subView in
			subView.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(subView)
		}
	}
	
	private func setUpConstraints() {
		NSLayoutConstraint.activate(
			[
				temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				temperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
				refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				refreshButton.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 50.0),
				refreshButton.heightAnchor.constraint(equalToConstant: 50.0),
				refreshButton.widthAnchor.constraint(equalTo: temperatureLabel.widthAnchor),
			]
		)
	}
	
	private func makeTemperatureLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.text = "Loading..."
		label.textColor = .black
		return label
	}
	
	private func makeButton(color: UIColor, text: String?, imageName: String?) -> UIButton {
		let button = UIButton(type: .system)
		
		button.setTitle(text, for: .normal)
		button.setTitleColor(.black, for: .normal)
		if let imageName = imageName {
			button.setImage(UIImage(systemName: imageName), for: .normal)
		}
		button.tintColor = .black
		button.backgroundColor = color
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
		button.layer.cornerRadius = 8
		button.layer.borderWidth = 2
		button.layer.borderColor = UIColor.black.cgColor
		button.isEnabled = true
		return button
	}
	
	@objc
	private func refreshAction() {
		presenter?.refreshTemperature()
	}
	
}

//MARK: - IWeatherView Implementation
extension WeatherViewController: IWeatherView {
	func updateLabelText(with text: String) {
		temperatureLabel.text = text
	}
}

