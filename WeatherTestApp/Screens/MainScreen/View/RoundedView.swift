//
//  RoundedView.swift
//  WeatherTestApp
//
//  Created by Alex Vasilyev on 05.06.2025.
//

import UIKit

final class RoundedView: UIView {
    init(backgroundColor: UIColor, cornerRadius: CGFloat) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
