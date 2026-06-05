//
//  HomeCityCollectionViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class HomeCityCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeCityCollectionViewCell"

    private let imageContainerView = UIView()
    private let cityImageView = UIImageView()
    private let titleBackgroundView = UIView()
    private let titleLabel = UILabel()
    private let arrowButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with city: HomeCity) {
        titleLabel.text = city.name
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false

        imageContainerView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)
        imageContainerView.layer.cornerRadius = 18
        imageContainerView.clipsToBounds = true
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false

        cityImageView.image = UIImage(named: "AuthCityBackground")?.withRenderingMode(.alwaysOriginal)
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.translatesAutoresizingMaskIntoConstraints = false

        titleBackgroundView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        arrowButton.setImage(UIImage(named: "HomeCityArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        arrowButton.imageView?.contentMode = .scaleAspectFit
        arrowButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageContainerView)
        contentView.addSubview(arrowButton)
        imageContainerView.addSubview(cityImageView)
        imageContainerView.addSubview(titleBackgroundView)
        titleBackgroundView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            cityImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            cityImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            cityImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            cityImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.62),

            titleBackgroundView.topAnchor.constraint(equalTo: cityImageView.bottomAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: titleBackgroundView.centerYAnchor),

            arrowButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -1),
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            arrowButton.widthAnchor.constraint(equalToConstant: 44),
            arrowButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
