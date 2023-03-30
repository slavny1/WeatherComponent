//
//  WeatherView.swift
//  WeatherComponent
//
//  Created by Viacheslav on 30/03/23.
//

import UIKit
import WeatherKit

final class WeatherView: UIView {

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
        label.font = UIFont.systemFont(ofSize: 172, weight: .ultraLight)
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

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            iconView.widthAnchor.constraint(equalToConstant: 100),
            iconView.heightAnchor.constraint(equalToConstant: 100),

            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0),
            tempLabel.widthAnchor.constraint(equalToConstant: 300),
            tempLabel.heightAnchor.constraint(equalToConstant: 200),

            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: -50),
            locationLabel.widthAnchor.constraint(equalToConstant: 200),
            locationLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var weather: Weather? {
        didSet {
            if let weather = weather {
                configure(with: weather)
            }
        }
    }

    func configure(with data: Weather) {
        iconView.image = UIImage(systemName: data.currentWeather.symbolName)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
