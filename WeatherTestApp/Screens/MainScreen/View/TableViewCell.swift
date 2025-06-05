//
//  TableViewCell.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit

final class TableViewCell: UITableViewCell {
    static var reuseIdentifier: String { "\(TableViewCell.self)" }

    struct Model {
        let date: String
        let icon: UIImage
        let description: String
        let temperature: String
        let windSpeed: String
        let humidity: String
    }

    // MARK: - Private UI зкщзукешуы

    private lazy var roundedView = RoundedView(
        backgroundColor: UIColor(red: 138/255, green: 141/255, blue: 147/255, alpha: 0.05),
        cornerRadius: 21
    ).prepareForAutoLayout()

    private lazy var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor =  UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)

        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()

        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        label.textAlignment = .center

        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor =  UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)

        return label
    }()

    private lazy var windContainerView = VerticalContainerView().prepareForAutoLayout()

    private lazy var humidityContainerView = VerticalContainerView().prepareForAutoLayout()

    // MARK: - Internal methods

    func configure(with model: Model) {
        dateLabel.text = model.date
        iconImageView.image = model.icon
        descriptionLabel.text = model.description
        temperatureLabel.text = "\(model.temperature)ºC"
        windContainerView.configure(
            with: VerticalContainerView.Model(
                title: "\(model.windSpeed) m/s",
                subtitle: "Wind"
            )
        )
        humidityContainerView.configure(
            with: VerticalContainerView.Model(
                title: "\(model.humidity) %",
                subtitle: "Humidity"
            )
        )
    }

    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        iconImageView.image = nil
        descriptionLabel.text = nil
        temperatureLabel.text = nil
    }
}

// MARK: - Private methods

private extension TableViewCell {
    func setupView() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        contentView.addSubview(roundedView)
        roundedView.addSubview(temperatureLabel)
        roundedView.addSubview(dateLabel)
        roundedView.addSubview(iconImageView)
        roundedView.addSubview(descriptionLabel)
        roundedView.addSubview(windContainerView)
        roundedView.addSubview(humidityContainerView)
    }

    func makeConstraints() {
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let constraints: [NSLayoutConstraint] = [
            roundedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            roundedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            roundedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            roundedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            temperatureLabel.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: 16),
            temperatureLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.leadingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -14),

            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 10),

            descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            descriptionLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: windContainerView.leadingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -14),

            windContainerView.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor),
            windContainerView.trailingAnchor.constraint(equalTo: humidityContainerView.leadingAnchor, constant: -4),
            windContainerView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -14),

            humidityContainerView.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor),
            humidityContainerView.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor, constant: -16),
            humidityContainerView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor, constant: -14),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
