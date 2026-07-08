//
//  AIChatMessageTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class AIChatMessageTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AIChatMessageTableViewCell"

    private let avatarImageView = UIImageView()
    private let bubbleView = UIView()
    private let messageLabel = UILabel()

    private var incomingConstraints: [NSLayoutConstraint] = []
    private var outgoingConstraints: [NSLayoutConstraint] = []

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

    func configure(with message: AIChatMessage) {
        messageLabel.text = message.text

        if message.isOutgoing {
            avatarImageView.isHidden = true
            bubbleView.backgroundColor = UIColor(red: 0.31, green: 0.64, blue: 0.96, alpha: 1)
            messageLabel.textColor = .white
            NSLayoutConstraint.deactivate(incomingConstraints)
            NSLayoutConstraint.activate(outgoingConstraints)
        } else {
            avatarImageView.isHidden = false
            bubbleView.backgroundColor = UIColor(red: 0.88, green: 0.95, blue: 1.0, alpha: 1)
            messageLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.12, alpha: 1)
            NSLayoutConstraint.deactivate(outgoingConstraints)
            NSLayoutConstraint.activate(incomingConstraints)
        }
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        avatarImageView.image = UIImage(named: "AIChatAvatar")?.withRenderingMode(.alwaysOriginal)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.layer.cornerRadius = 5
        bubbleView.layer.masksToBounds = true
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        incomingConstraints = [
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            bubbleView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 14),
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -80)
        ]

        outgoingConstraints = [
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 90)
        ]

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            avatarImageView.widthAnchor.constraint(equalToConstant: 35),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
    }
}
