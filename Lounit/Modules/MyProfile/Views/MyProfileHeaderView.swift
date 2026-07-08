//
//  MyProfileHeaderView.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileHeaderView: UIView {
    var followTapHandler: (() -> Void)? {
        get { statsView.followTapHandler }
        set { statsView.followTapHandler = newValue }
    }
    var fansTapHandler: (() -> Void)? {
        get { statsView.fansTapHandler }
        set { statsView.fansTapHandler = newValue }
    }
    var likesTapHandler: (() -> Void)? {
        get { statsView.likesTapHandler }
        set { statsView.likesTapHandler = newValue }
    }

    func configureStats(followCount: Int, fansCount: Int, likesCount: Int) {
        statsView.configure(followCount: followCount, fansCount: fansCount, likesCount: likesCount)
    }

    func configure(profile: UserProfile) {
        avatarImageView.image = UserProfileStore.avatarImage(for: profile.avatarImageName)
        nameLabel.text = profile.name
    }

    private let backgroundImageView = UIImageView()
    private let eyesLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let statsView = MyProfileStatsView()

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

    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        backgroundImageView.image = UIImage(named: "MyProfileHeaderBackground")?.withRenderingMode(.alwaysOriginal)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        eyesLabel.text = "👀"
        eyesLabel.font = .systemFont(ofSize: 24, weight: .regular)
        eyesLabel.textAlignment = .center
        eyesLabel.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.image = UserProfileStore.avatarImage(for: UserProfileStore.currentProfile.avatarImageName)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = UserProfileStore.currentProfile.name
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 27, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(backgroundImageView)
        addSubview(eyesLabel)
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(statsView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 375),

            eyesLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 58),
            eyesLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 52),
            eyesLabel.widthAnchor.constraint(equalToConstant: 50),
            eyesLabel.heightAnchor.constraint(equalToConstant: 36),

            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 128),
            avatarImageView.widthAnchor.constraint(equalToConstant: 104),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 26),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            nameLabel.heightAnchor.constraint(equalToConstant: 36),

            statsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            statsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            statsView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -42),
            statsView.heightAnchor.constraint(equalToConstant: 92),
            statsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
