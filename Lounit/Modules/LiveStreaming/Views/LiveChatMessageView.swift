//
//  LiveChatMessageView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class LiveChatMessageView: UIStackView {
    var reportTapHandler: (() -> Void)?

    private let avatarImageView = UIImageView()
    private let bubbleView = UIView()
    private let contentStackView = UIStackView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let reportButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    func configure(name: String, message: String, avatarImageName: String) {
        avatarImageView.image = UserProfileStore.avatarImage(for: avatarImageName)
        nameLabel.text = name
        messageLabel.text = message
        bubbleView.invalidateIntrinsicContentSize()
    }

    private func setupView() {
        axis = .horizontal
        alignment = .top
        spacing = 6
        translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.backgroundColor = UIColor(red: 0.33, green: 0.30, blue: 0.22, alpha: 0.58)
        bubbleView.layer.cornerRadius = 8
        bubbleView.clipsToBounds = true
        bubbleView.setContentHuggingPriority(.required, for: .horizontal)
        bubbleView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 4
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.textColor = .white
        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let reportImage = UIImage(systemName: "flag.fill")?.withRenderingMode(.alwaysTemplate)
        reportButton.setImage(reportImage, for: .normal)
        reportButton.tintColor = .white
        reportButton.backgroundColor = UIColor(white: 1, alpha: 0.18)
        reportButton.layer.cornerRadius = 12
        reportButton.clipsToBounds = true
        reportButton.imageView?.contentMode = .scaleAspectFit
        reportButton.accessibilityLabel = "Report"
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.addTarget(self, action: #selector(didTapReport), for: .touchUpInside)
    }

    private func setupLayout() {
        addArrangedSubview(avatarImageView)
        addArrangedSubview(bubbleView)
        addArrangedSubview(reportButton)

        bubbleView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(messageLabel)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.72),

            reportButton.widthAnchor.constraint(equalToConstant: 24),
            reportButton.heightAnchor.constraint(equalTo: reportButton.widthAnchor),

            contentStackView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            contentStackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            contentStackView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12)
        ])
    }

    @objc private func didTapReport() {
        reportTapHandler?()
    }
}
