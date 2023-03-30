//
//  WeatherView.swift
//  WeatherComponent
//
//  Created by Viacheslav on 30/03/23.
//

import UIKit
import WeatherKit
import CoreLocation

final class WeatherView: UIView {

    private let loadingView = LoadingView()

    private let iconView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star.square"))
        image.contentMode = .scaleAspectFill
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 148, weight: .ultraLight)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "feels like"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .ultraLight)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.text = "last update"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 72, weight: .ultraLight)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconView)
        addSubview(tempLabel)
        addSubview(locationLabel)
        addSubview(feelsLikeLabel)
        addSubview(lastUpdateLabel)
        addSubview(loadingView)

        loadingView.backgroundColor = .white
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([

            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            locationLabel.widthAnchor.constraint(equalToConstant: 400),
            locationLabel.heightAnchor.constraint(equalToConstant: 100),

            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 50),
            iconView.widthAnchor.constraint(equalToConstant: 250),
            iconView.heightAnchor.constraint(equalToConstant: 100),

            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 30),
            tempLabel.widthAnchor.constraint(equalToConstant: 300),
            tempLabel.heightAnchor.constraint(equalToConstant: 200),

            feelsLikeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            feelsLikeLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: -50),
            feelsLikeLabel.widthAnchor.constraint(equalToConstant: 200),
            feelsLikeLabel.heightAnchor.constraint(equalToConstant: 100),

            lastUpdateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            lastUpdateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            lastUpdateLabel.widthAnchor.constraint(equalToConstant: 350),
            lastUpdateLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: Weather?, location: CLLocation?) {
        loadingView.isHidden = false
        if let location = location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Error getting address: \(error.localizedDescription)")
                    return
                }
                guard let placemarks = placemarks?.first else { return }

                DispatchQueue.main.async {
                    self.locationLabel.text = placemarks.locality ?? "No where"
                    self.loadingView.isHidden = true
                }
            }
        }

        if let data = data {
            iconView.image = UIImage(named: data.currentWeather.symbolName)

            let formatter = MeasurementFormatter()
            formatter.unitStyle = .short
            formatter.numberFormatter.maximumFractionDigits = 0
            formatter.unitOptions = .providedUnit

            tempLabel.text = formatter.string(from: data.currentWeather.temperature) + "C"
            feelsLikeLabel.text = "feels like: " + formatter.string(from: data.currentWeather.apparentTemperature) + "C"

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            lastUpdateLabel.text = "last updated: " + dateFormatter.string(from: data.currentWeather.date)
        }

    }
}
