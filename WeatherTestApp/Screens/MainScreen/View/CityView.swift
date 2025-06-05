//
//  CityView.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 04.06.2025.
//

import UIKit

private enum Constant {
    enum TableView {
        static let cellHeight: CGFloat = 86
    }
}

final class CityView: UIView {

    // MARK: - Private UI properties

    private lazy var topRoundedView = RoundedView(
        backgroundColor: UIColor(red: 138/255, green: 141/255, blue: 147/255, alpha: 0.05),
        cornerRadius: 30
    ).prepareForAutoLayout()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()

        return imageView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor =  UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)

        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .systemFont(ofSize: 40, weight: .medium)
        label.textColor =  UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)

        return label
    }()

    private lazy var bottomRoundedView = RoundedView(
        backgroundColor: UIColor(red: 138/255, green: 141/255, blue: 147/255, alpha: 0.05),
        cornerRadius: 24
    ).prepareForAutoLayout()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [windContainerView, humidityContainerView, rainContainerView]
        ).prepareForAutoLayout()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        return stackView
    }()

    private lazy var windContainerView = VerticalContainerView().prepareForAutoLayout()

    private lazy var humidityContainerView = VerticalContainerView().prepareForAutoLayout()

    private lazy var rainContainerView = VerticalContainerView().prepareForAutoLayout()

    private lazy var tableView: UITableView = {
        let tableView = UITableView().prepareForAutoLayout()
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)

        return tableView
    }()

    // MARK: - Private properties

    private var items: [CityViewModel.Day] = [] {
        didSet { tableView.reloadData() }
    }

    // MARK: - Internal methods

    func configure(with viewModel: CityViewModel) {
        dateLabel.text = viewModel.date
        iconImageView.image = viewModel.image
        temperatureLabel.text = "\(viewModel.temperature)ºC"
        descriptionLabel.text = viewModel.conditionText

        windContainerView.configure(
            with: VerticalContainerView.Model(
                image: Images.wind,
                title: "\(viewModel.windSpeed) m/s",
                subtitle: "Wind"
            )
        )
        humidityContainerView.configure(
            with: VerticalContainerView.Model(
                image: Images.humidity,
                title: "\(viewModel.humidity) %",
                subtitle: "Humidity"
            )
        )

        #warning("Запрос дождя")
        rainContainerView.configure(
            with: VerticalContainerView.Model(
                image: Images.rain,
                title: "N/A %",
                subtitle: "Rain"
            )
        )

        items = viewModel.days
    }

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCell.reuseIdentifier,
                for: indexPath
            ) as? TableViewCell
        else {
            return UITableViewCell()
        }
        configureCell(cell, with: items[indexPath.row])

        return cell
    }

    private func configureCell(_ cell: TableViewCell, with item: CityViewModel.Day) {
        cell.configure(
            with: TableViewCell.Model(
                date: item.day,
                icon: item.icon ?? UIImage(),
                description: item.description,
                temperature: item.temperature,
                windSpeed: item.windSpeed,
                humidity: item.humidity
            )
        )
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.TableView.cellHeight
    }

    #warning("Вынести текстовки в отдельный файл")
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        createHeaderView(with: "Forecast for 5 days")
    }

    #warning("Мб создать кастомный класс")
    private func createHeaderView(with title: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let label = UILabel().prepareForAutoLayout()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        return view
    }
}

// MARK: - Private methods

private extension CityView {
    func setupView() {
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        addSubview(topRoundedView)
        topRoundedView.addSubview(iconImageView)
        topRoundedView.addSubview(dateLabel)
        topRoundedView.addSubview(temperatureLabel)
        topRoundedView.addSubview(descriptionLabel)

        addSubview(bottomRoundedView)
        bottomRoundedView.addSubview(horizontalStackView)

        addSubview(tableView)
    }

    func makeConstraints() {
        let constraints: [NSLayoutConstraint] = [
            topRoundedView.heightAnchor.constraint(equalToConstant: 152),
            topRoundedView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topRoundedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            topRoundedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            dateLabel.topAnchor.constraint(equalTo: topRoundedView.topAnchor, constant: 32),
            dateLabel.leadingAnchor.constraint(equalTo: topRoundedView.leadingAnchor, constant: 24),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: iconImageView.leadingAnchor, constant: -24),

            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: topRoundedView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: iconImageView.leadingAnchor, constant: -24),

            temperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            temperatureLabel.leadingAnchor.constraint(equalTo: topRoundedView.leadingAnchor, constant: 24),
            temperatureLabel.trailingAnchor.constraint(greaterThanOrEqualTo: iconImageView.leadingAnchor, constant: -24),

            iconImageView.heightAnchor.constraint(equalToConstant: 92),
            iconImageView.widthAnchor.constraint(equalToConstant: 92),
            iconImageView.centerYAnchor.constraint(equalTo: topRoundedView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: topRoundedView.trailingAnchor, constant: -24),

            bottomRoundedView.heightAnchor.constraint(equalToConstant: 95),
            bottomRoundedView.topAnchor.constraint(equalTo: topRoundedView.bottomAnchor, constant: 20),
            bottomRoundedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            bottomRoundedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            horizontalStackView.topAnchor.constraint(equalTo: bottomRoundedView.topAnchor, constant: 16),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomRoundedView.bottomAnchor, constant: -16),
            horizontalStackView.leadingAnchor.constraint(equalTo: bottomRoundedView.leadingAnchor, constant: 50),
            horizontalStackView.trailingAnchor.constraint(equalTo: bottomRoundedView.trailingAnchor, constant: -50),

            tableView.topAnchor.constraint(equalTo: bottomRoundedView.bottomAnchor, constant: 36),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
