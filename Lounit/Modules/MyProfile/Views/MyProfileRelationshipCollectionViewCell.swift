//
//  MyProfileRelationshipCollectionViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

struct MyProfileRelationshipUser {
    let name: String
    let avatarImageName: String
    var isFollowed: Bool
}

final class MyProfileRelationshipCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MyProfileRelationshipCollectionViewCell"

    var followTapHandler: (() -> Void)?

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let followButton = UIButton(type: .custom)

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

    override func prepareForReuse() {
        super.prepareForReuse()
        followTapHandler = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = 18
        followButton.layer.cornerRadius = 22
    }

    func configure(with user: MyProfileRelationshipUser) {
        avatarImageView.image = UIImage(named: user.avatarImageName)?.withRenderingMode(.alwaysOriginal)
        nameLabel.text = user.name
        followButton.setTitle(user.isFollowed ? "Followed" : "Follow", for: .normal)
        followButton.backgroundColor = user.isFollowed
            ? UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 0.95)
            : UIColor(red: 0.30, green: 0.64, blue: 0.98, alpha: 1)
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 22
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        followButton.setTitleColor(.white, for: .normal)
        followButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        followButton.clipsToBounds = true
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        contentView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(followButton)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 74),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),

            followButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            followButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            followButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
            followButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func didTapFollow() {
        followTapHandler?()
    }
}
