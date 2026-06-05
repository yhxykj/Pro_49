//
//  BadgeTaskView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class BadgeTaskView: UIView {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let progressView = BadgeProgressView()

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

    func configure(title: String, count: String, progress: CGFloat) {
        titleLabel.text = title
        countLabel.text = count
        progressView.setProgress(progress)
    }

    private func setupView() {
        backgroundColor = UIColor(red: 0.52, green: 0.79, blue: 0.96, alpha: 1)
        layer.cornerRadius = 22
        clipsToBounds = true

        iconImageView.image = UIImage(named: "BadgeEnergyIcon")?.withRenderingMode(.alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 19, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 18, weight: .medium)
        countLabel.textAlignment = .right
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        progressView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(progressView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 18),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressView.leadingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),

            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            countLabel.widthAnchor.constraint(equalToConstant: 72),
            countLabel.heightAnchor.constraint(equalToConstant: 24),

            progressView.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            progressView.widthAnchor.constraint(equalToConstant: 122),
            progressView.heightAnchor.constraint(equalToConstant: 13)
        ])
    }
}
