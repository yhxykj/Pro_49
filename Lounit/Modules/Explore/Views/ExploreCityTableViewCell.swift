//
//  ExploreCityTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ExploreCityTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ExploreCityTableViewCell"

    private let cityImageView = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let starImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let arrowImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configure(with city: ExploreCity) {
        cityImageView.image = UIImage(named: city.listImageName)?.withRenderingMode(.alwaysOriginal)
            ?? UIImage(named: "ExploreHeroImage")?.withRenderingMode(.alwaysOriginal)
        nameLabel.text = city.name
        subtitleLabel.text = city.subtitle
        ratingLabel.text = city.rating
    }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .white

        cityImageView.image = UIImage(named: "ExploreHeroImage")?.withRenderingMode(.alwaysOriginal)
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = 12
        cityImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.textColor = .black
        subtitleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.8
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        starImageView.image = UIImage(named: "ExploreStarIcon")?.withRenderingMode(.alwaysOriginal)
        starImageView.contentMode = .scaleAspectFit
        starImageView.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.textColor = .black
        ratingLabel.font = .systemFont(ofSize: 18, weight: .regular)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        arrowImageView.image = UIImage(named: "ExploreArrowIcon")?.withRenderingMode(.alwaysOriginal)
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cityImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            cityImageView.widthAnchor.constraint(equalToConstant: 150),
            cityImageView.heightAnchor.constraint(equalToConstant: 112),

            arrowImageView.topAnchor.constraint(equalTo: cityImageView.topAnchor, constant: 2),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),

            nameLabel.topAnchor.constraint(equalTo: cityImageView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 26),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 24),

            starImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            starImageView.bottomAnchor.constraint(equalTo: cityImageView.bottomAnchor, constant: -3),
            starImageView.widthAnchor.constraint(equalToConstant: 24),
            starImageView.heightAnchor.constraint(equalToConstant: 24),

            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 12),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
}
