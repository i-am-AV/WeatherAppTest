//
//  VerticalContainerView.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 05.06.2025.
//

import UIKit

final class VerticalContainerView: UIView {
    struct Model {
        let image: UIImage?
        let title: String
        let subtitle: String

        init(image: UIImage? = nil, title: String, subtitle: String) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
        }
    }

    // MARK: - Private UI properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()

    // MARK: - Internal methods

    func configure(with model: Model) {
        if let image = model.image {
            imageView.image = image
        } else {
            imageView.removeFromSuperview()
        }
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
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

// MARK: - Private methods

private extension VerticalContainerView {
    func setupView() {
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    func makeConstraints() {
        let constraints: [NSLayoutConstraint] = [
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
