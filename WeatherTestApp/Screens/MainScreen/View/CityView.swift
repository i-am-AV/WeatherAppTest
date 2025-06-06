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
    enum RoundedView {
        static let topViewCornerRadius: CGFloat = 30
        static let bottomViewCornerRadius: CGFloat = 24
    }
    enum Header {
        static let titleInset: CGFloat = 16
    }
}

final class CityView: UIView {
    // MARK: - Private UI properties

    private lazy var topRoundedView = RoundedView(
        backgroundColor: Colors.Background.secondary,
        cornerRadius: Constant.RoundedView.topViewCornerRadius
    ).prepareForAutoLayout()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()

        return imageView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.system10Regular
        label.textColor = Colors.Text.secondary2

        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.system40Medium
        label.textColor = Colors.Text.main

        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Fonts.system14Medium
        label.textColor = Colors.Text.secondary

        return label
    }()

    private lazy var bottomRoundedView = RoundedView(
        backgroundColor: Colors.Background.secondary,
        cornerRadius: Constant.RoundedView.bottomViewCornerRadius
    ).prepareForAutoLayout()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [windContainerView, humidityContainerView]
        ).prepareForAutoLayout()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        return stackView
    }()

    private lazy var windContainerView = VerticalContainerView().prepareForAutoLayout()

    private lazy var humidityContainerView = VerticalContainerView().prepareForAutoLayout()

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
                subtitle: Texts.Container.wind
            )
        )
        humidityContainerView.configure(
            with: VerticalContainerView.Model(
                image: Images.humidity,
                title: "\(viewModel.humidity) %",
                subtitle: Texts.Container.humidity
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
        cell.selectionStyle = .none

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

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        createHeaderView(with: Texts.Table.headerTitle)
    }

    private func createHeaderView(with title: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let label = UILabel().prepareForAutoLayout()
        label.text = title
        label.font = Fonts.system14Medium
        label.textColor = Colors.Text.secondary

        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Header.titleInset).isActive = true
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

            iconImageView.heightAnchor.constraint(equalToConstant: 64),
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
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
