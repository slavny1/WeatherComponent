//
//  ViewController.swift
//  WeatherComponent
//
//  Created by Viacheslav on 30/03/23.
//

import UIKit
import CoreLocation
import WeatherKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let weatherManager = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        getUserLocation()

        let iconView = UIImageView(image: UIImage(systemName: "star.square")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        iconView.contentMode = .scaleAspectFill

        let tempLabel = UILabel()
        tempLabel.text = "00"
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 172, weight: .ultraLight)

        let locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont.systemFont(ofSize: 48, weight: .ultraLight)

        view.addSubview(iconView)
        view.addSubview(tempLabel)
        view.addSubview(locationLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
                iconView.widthAnchor.constraint(equalToConstant: 100),
                iconView.heightAnchor.constraint(equalToConstant: 100)
            ])

            tempLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tempLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0)
//                tempLabel.widthAnchor.constraint(equalToConstant: 300),
//                tempLabel.heightAnchor.constraint(equalToConstant: 200)
            ])

            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                locationLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: -50),
                locationLabel.widthAnchor.constraint(equalToConstant: 200),
                locationLabel.heightAnchor.constraint(equalToConstant: 100)
            ])
    }

    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        getWeather(location: location)
    }

    func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await weatherManager.weather(for: location)

                print("Current weather" + String(describing: result.currentWeather))
                print("Daily forecast" + String(describing: result.dailyForecast))
                print("Minute forecast" + String(describing: result.minuteForecast))
                print(result.currentWeather.symbolName)

            } catch {
                print(String(describing: error))
            }
        }
    }

    func setUpView() {

    }

}

