//
//  LiveRoomCollectionViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

struct LiveRoom {
    let title: String
    let imageName: String
}

final class LiveRoomCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "LiveRoomCollectionViewCell"

    private let cardView = UIView()
    private let cityImageView = UIImageView()
    private let liveBadgeImageView = UIImageView()
    private let exploreChipView = UIView()
    private let avatarImageView = UIImageView()
    private let exploreLabel = UILabel()
    private let titleBackgroundView = UIView()
    private let titleLabel = UILabel()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    func configure(with room: LiveRoom) {
        titleLabel.text = room.title
        cityImageView.image = UIImage(named: room.imageName)?.withRenderingMode(.alwaysOriginal)
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)
        cardView.layer.cornerRadius = 18
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.translatesAutoresizingMaskIntoConstraints = false

        liveBadgeImageView.image = UIImage(named: "LiveStatusBadge")?.withRenderingMode(.alwaysOriginal)
        liveBadgeImageView.contentMode = .scaleAspectFit
        liveBadgeImageView.translatesAutoresizingMaskIntoConstraints = false

        exploreChipView.backgroundColor = UIColor(white: 1, alpha: 0.62)
        exploreChipView.layer.cornerRadius = 16
        exploreChipView.clipsToBounds = true
        exploreChipView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.image = UIImage(named: "LoginMascot")?.withRenderingMode(.alwaysOriginal)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        exploreLabel.text = "Explore"
        exploreLabel.textColor = .white
        exploreLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        exploreLabel.translatesAutoresizingMaskIntoConstraints = false

        titleBackgroundView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = UIColor(white: 0.1, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(cityImageView)
        cardView.addSubview(titleBackgroundView)
        cardView.addSubview(liveBadgeImageView)
        cardView.addSubview(exploreChipView)

        exploreChipView.addSubview(avatarImageView)
        exploreChipView.addSubview(exploreLabel)
        titleBackgroundView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            cityImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cityImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cityImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cityImageView.heightAnchor.constraint(equalToConstant: 139),

            titleBackgroundView.topAnchor.constraint(equalTo: cityImageView.bottomAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

            liveBadgeImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5),
            liveBadgeImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -2),
            liveBadgeImageView.widthAnchor.constraint(equalToConstant: 69),
            liveBadgeImageView.heightAnchor.constraint(equalToConstant: 33),

            exploreChipView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            exploreChipView.bottomAnchor.constraint(equalTo: cityImageView.bottomAnchor, constant: -8),
            exploreChipView.widthAnchor.constraint(equalToConstant: 84),
            exploreChipView.heightAnchor.constraint(equalToConstant: 34),

            avatarImageView.leadingAnchor.constraint(equalTo: exploreChipView.leadingAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: exploreChipView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 34),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            exploreLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 2),
            exploreLabel.trailingAnchor.constraint(equalTo: exploreChipView.trailingAnchor, constant: -8),
            exploreLabel.centerYAnchor.constraint(equalTo: exploreChipView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -8)
        ])
    }
}
