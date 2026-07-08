//
//  ChatBubbleTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class ChatBubbleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ChatBubbleTableViewCell"

    private let avatarView = ChatMateAvatarBadgeView()
    private let bubbleView = UIView()
    private let messageLabel = UILabel()

    private var leadingConstraints: [NSLayoutConstraint] = []
    private var trailingConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        avatarView.configure(
            style: message.avatarStyle,
            title: message.avatarTitle,
            imageName: message.avatarImageName
        )

        if message.isOutgoing {
            bubbleView.backgroundColor = UIColor(red: 0.31, green: 0.64, blue: 0.96, alpha: 1)
            messageLabel.textColor = .white
            NSLayoutConstraint.deactivate(leadingConstraints)
            NSLayoutConstraint.activate(trailingConstraints)
        } else {
            bubbleView.backgroundColor = UIColor(white: 1.0, alpha: 0.82)
            messageLabel.textColor = UIColor(red: 0.08, green: 0.08, blue: 0.1, alpha: 1)
            NSLayoutConstraint.deactivate(trailingConstraints)
            NSLayoutConstraint.activate(leadingConstraints)
        }
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        avatarView.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.layer.cornerRadius = 5
        bubbleView.layer.masksToBounds = true
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(avatarView)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        leadingConstraints = [
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bubbleView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 13),
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -44)
        ]

        trailingConstraints = [
            avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bubbleView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -13),
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 118)
        ]

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            avatarView.widthAnchor.constraint(equalToConstant: 52),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),

            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
    }
}

final class ChatMateAvatarBadgeView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let photoImageView = UIImageView()
    private let iconImageView = UIImageView()
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
        layer.cornerRadius = bounds.height / 2
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
    }

    func configure(style: ChatMateAvatarStyle, title: String, imageName: String? = nil) {
        if let imageName, let image = UserProfileStore.avatarImage(for: imageName) {
            gradientLayer.isHidden = true
            photoImageView.isHidden = false
            iconImageView.isHidden = true
            titleLabel.isHidden = true
            photoImageView.image = image
            return
        }

        gradientLayer.isHidden = false
        photoImageView.isHidden = true
        photoImageView.image = nil
        iconImageView.isHidden = false
        titleLabel.isHidden = false

        switch style {
        case .person:
            gradientLayer.colors = [
                UIColor(red: 0.98, green: 0.80, blue: 0.68, alpha: 1).cgColor,
                UIColor(red: 0.47, green: 0.70, blue: 0.98, alpha: 1).cgColor
            ]
            iconImageView.image = UIImage(systemName: "person.fill")
            titleLabel.text = String(title.prefix(1))
        case .ai:
            gradientLayer.colors = [
                UIColor(red: 0.37, green: 0.67, blue: 1.0, alpha: 1).cgColor,
                UIColor(red: 0.80, green: 0.94, blue: 1.0, alpha: 1).cgColor
            ]
            iconImageView.image = UIImage(systemName: "sparkles")
            titleLabel.text = "AI"
        }
    }

    private func setupView() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)

        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.isHidden = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(photoImageView)
        addSubview(iconImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
