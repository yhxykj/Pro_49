//
//  ChatMateMessageCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class ChatMateMessageCell: UITableViewCell {
    static let reuseIdentifier = "ChatMateMessageCell"

    private let cardView = UIView()
    private let avatarView = ChatMateAvatarView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let messageLabel = UILabel()

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

    func configure(with conversation: ChatMateConversation) {
        nameLabel.text = conversation.name
        dateLabel.text = conversation.date
        messageLabel.text = conversation.message
        avatarView.configure(
            style: conversation.avatarStyle,
            title: conversation.name,
            imageName: conversation.avatarImageName
        )
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = UIColor(white: 1.0, alpha: 0.94)
        cardView.layer.cornerRadius = 27
        cardView.layer.masksToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        avatarView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textAlignment = .right
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.8
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.textColor = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1)
        messageLabel.font = .systemFont(ofSize: 17, weight: .regular)
        messageLabel.numberOfLines = 1
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(avatarView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            cardView.heightAnchor.constraint(equalToConstant: 88),
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            avatarView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 62),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -12),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),

            dateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            dateLabel.widthAnchor.constraint(equalToConstant: 116),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -22),
            messageLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

private final class ChatMateAvatarView: UIView {
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
        if let imageName, let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            gradientLayer.isHidden = true
            photoImageView.isHidden = false
            photoImageView.image = image
            iconImageView.isHidden = true
            titleLabel.isHidden = true
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
                UIColor(red: 0.96, green: 0.74, blue: 0.62, alpha: 1).cgColor,
                UIColor(red: 0.48, green: 0.71, blue: 0.98, alpha: 1).cgColor
            ]
            iconImageView.image = UIImage(systemName: "person.fill")
            iconImageView.tintColor = .white
            titleLabel.text = String(title.prefix(1))
        case .ai:
            gradientLayer.colors = [
                UIColor(red: 0.40, green: 0.68, blue: 1.0, alpha: 1).cgColor,
                UIColor(red: 0.78, green: 0.93, blue: 1.0, alpha: 1).cgColor
            ]
            iconImageView.image = UIImage(named: "AIChatAvatar")?.withRenderingMode(.alwaysOriginal)
            titleLabel.text = nil
        }
    }

    private func setupView() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)

        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.isHidden = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
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
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
