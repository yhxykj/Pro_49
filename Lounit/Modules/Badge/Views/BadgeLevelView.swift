//
//  BadgeLevelView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class BadgeLevelView: UIView {
    private let badgeImageView = UIImageView()
    private let valueLabel = UILabel()
    private let energyLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    func configure(imageName: String, value: String, title: String) {
        badgeImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        valueLabel.text = value
        energyLabel.text = title
    }

    private func setupView() {
        backgroundColor = .clear

        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false

        valueLabel.textColor = UIColor(red: 0.28, green: 0.62, blue: 0.96, alpha: 1)
        valueLabel.font = .systemFont(ofSize: 17, weight: .medium)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        energyLabel.textColor = UIColor(white: 0.43, alpha: 1)
        energyLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        energyLabel.textAlignment = .center
        energyLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(badgeImageView)
        addSubview(valueLabel)
        addSubview(energyLabel)

        NSLayoutConstraint.activate([
            badgeImageView.topAnchor.constraint(equalTo: topAnchor),
            badgeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            badgeImageView.widthAnchor.constraint(equalToConstant: 80),
            badgeImageView.heightAnchor.constraint(equalToConstant: 80),

            valueLabel.topAnchor.constraint(equalTo: badgeImageView.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 22),

            energyLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            energyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            energyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            energyLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
