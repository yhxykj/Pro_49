//
//  UserCenterHeaderView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class UserCenterHeaderView: UIView {
    var followStateChangeHandler: ((Bool) -> Void)?
    var messageTapHandler: (() -> Void)?

    private let backgroundImageView = UIImageView()
    private let avatarImageView = UIImageView()
    private let badgeImageView = UIImageView()
    private let nameLabel = UILabel()
    private let statsContainerView = UIView()
    private let followStatsView = UserCenterStatView(value: "8", title: "Follow")
    private let fansStatsView = UserCenterStatView(value: "16", title: "Fans")
    private let likesStatsView = UserCenterStatView(value: "24", title: "Likes")
    private let firstDividerView = UIView()
    private let secondDividerView = UIView()
    private let messageButton = UIButton(type: .custom)
    private let followButton = UIButton(type: .custom)
    private let followLabel = UILabel()
    private var isFollowing = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        updateFollowState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
        updateFollowState()
    }

    func configure(
        name: String,
        avatarImageName: String,
        backgroundImageName: String,
        followCount: Int,
        fansCount: Int,
        likesCount: Int,
        isFollowing: Bool
    ) {
        nameLabel.text = name
        avatarImageView.image = UIImage(named: avatarImageName)?.withRenderingMode(.alwaysOriginal)
        backgroundImageView.image = UIImage(named: backgroundImageName)?.withRenderingMode(.alwaysOriginal)
        followStatsView.configure(value: "\(followCount)")
        fansStatsView.configure(value: "\(fansCount)")
        likesStatsView.configure(value: "\(likesCount)")
        self.isFollowing = isFollowing
        updateFollowState()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = 56
        statsContainerView.layer.cornerRadius = statsContainerView.bounds.height / 2
    }

    private func setupView() {
        backgroundColor = .clear

        backgroundImageView.image = UIImage(named: "BadgeCurrentExplorer")?.withRenderingMode(.alwaysOriginal)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.image = UIImage(named: "BadgeCurrentExplorer")?.withRenderingMode(.alwaysOriginal)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 56
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        badgeImageView.image = UIImage(named: "UserCenterBadgeIcon")?.withRenderingMode(.alwaysOriginal)
        badgeImageView.contentMode = .scaleAspectFit
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = "Marceline"
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 27, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        statsContainerView.backgroundColor = .white
        statsContainerView.clipsToBounds = true
        statsContainerView.translatesAutoresizingMaskIntoConstraints = false

        [firstDividerView, secondDividerView].forEach {
            $0.backgroundColor = UIColor(white: 0.82, alpha: 1)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        messageButton.setImage(UIImage(named: "UserCenterMessageButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.imageView?.contentMode = .scaleAspectFit
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)

        followButton.imageView?.contentMode = .scaleAspectFit
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)

        followLabel.textColor = .white
        followLabel.font = .systemFont(ofSize: 26, weight: .regular)
        followLabel.textAlignment = .center
        followLabel.isUserInteractionEnabled = false
        followLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(backgroundImageView)
        addSubview(avatarImageView)
        addSubview(badgeImageView)
        addSubview(nameLabel)
        addSubview(statsContainerView)
        addSubview(messageButton)
        addSubview(followButton)

        statsContainerView.addSubview(followStatsView)
        statsContainerView.addSubview(fansStatsView)
        statsContainerView.addSubview(likesStatsView)
        statsContainerView.addSubview(firstDividerView)
        statsContainerView.addSubview(secondDividerView)

        followButton.addSubview(followLabel)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 372),

            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            avatarImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -118),
            avatarImageView.widthAnchor.constraint(equalToConstant: 112),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            badgeImageView.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4),
            badgeImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 4),
            badgeImageView.widthAnchor.constraint(equalToConstant: 36),
            badgeImageView.heightAnchor.constraint(equalTo: badgeImageView.widthAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 26),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            nameLabel.heightAnchor.constraint(equalToConstant: 36),

            statsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            statsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            statsContainerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -34),
            statsContainerView.heightAnchor.constraint(equalToConstant: 92),

            followStatsView.leadingAnchor.constraint(equalTo: statsContainerView.leadingAnchor),
            followStatsView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            followStatsView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor),
            followStatsView.widthAnchor.constraint(equalTo: statsContainerView.widthAnchor, multiplier: 1.0 / 3.0),

            fansStatsView.leadingAnchor.constraint(equalTo: followStatsView.trailingAnchor),
            fansStatsView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            fansStatsView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor),
            fansStatsView.widthAnchor.constraint(equalTo: followStatsView.widthAnchor),

            likesStatsView.leadingAnchor.constraint(equalTo: fansStatsView.trailingAnchor),
            likesStatsView.trailingAnchor.constraint(equalTo: statsContainerView.trailingAnchor),
            likesStatsView.topAnchor.constraint(equalTo: statsContainerView.topAnchor),
            likesStatsView.bottomAnchor.constraint(equalTo: statsContainerView.bottomAnchor),

            firstDividerView.leadingAnchor.constraint(equalTo: followStatsView.trailingAnchor),
            firstDividerView.centerYAnchor.constraint(equalTo: statsContainerView.centerYAnchor),
            firstDividerView.widthAnchor.constraint(equalToConstant: 1),
            firstDividerView.heightAnchor.constraint(equalToConstant: 58),

            secondDividerView.leadingAnchor.constraint(equalTo: fansStatsView.trailingAnchor),
            secondDividerView.centerYAnchor.constraint(equalTo: statsContainerView.centerYAnchor),
            secondDividerView.widthAnchor.constraint(equalToConstant: 1),
            secondDividerView.heightAnchor.constraint(equalToConstant: 58),

            messageButton.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 28),
            messageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            messageButton.widthAnchor.constraint(equalTo: followButton.widthAnchor),
            messageButton.heightAnchor.constraint(equalToConstant: 64),

            followButton.topAnchor.constraint(equalTo: statsContainerView.bottomAnchor, constant: 28),
            followButton.leadingAnchor.constraint(equalTo: messageButton.trailingAnchor, constant: 14),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            followButton.heightAnchor.constraint(equalToConstant: 64),

            followLabel.centerXAnchor.constraint(equalTo: followButton.centerXAnchor),
            followLabel.centerYAnchor.constraint(equalTo: followButton.centerYAnchor),
            followLabel.leadingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: 10),
            followLabel.trailingAnchor.constraint(equalTo: followButton.trailingAnchor, constant: -10)
        ])
    }

    private func updateFollowState() {
        let imageName = isFollowing ? "UserCenterFollowingButtonBackground" : "UserCenterFollowButtonBackground"
        followButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        followLabel.text = isFollowing ? "Following" : "Follow"
    }

    @objc private func didTapFollow() {
        isFollowing.toggle()
        updateFollowState()
        followStateChangeHandler?(isFollowing)
    }

    @objc private func didTapMessage() {
        messageTapHandler?()
    }
}

private final class UserCenterStatView: UIView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    init(value: String, title: String) {
        super.init(frame: .zero)
        valueLabel.text = value
        titleLabel.text = title
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    func configure(value: String) {
        valueLabel.text = value
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        valueLabel.textColor = .black
        valueLabel.font = .systemFont(ofSize: 26, weight: .bold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(valueLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
