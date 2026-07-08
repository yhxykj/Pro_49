//
//  MyProfileBlacklistTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

struct MyProfileBlacklistUser {
    let name: String
    let avatarImageName: String
}

final class MyProfileBlacklistTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MyProfileBlacklistTableViewCell"

    var removeTapHandler: (() -> Void)?

    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let removeButton = UIButton(type: .custom)

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

    override func prepareForReuse() {
        super.prepareForReuse()
        removeTapHandler = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    func configure(with user: MyProfileBlacklistUser) {
        avatarImageView.image = UIImage(named: user.avatarImageName)?.withRenderingMode(.alwaysOriginal)
        nameLabel.text = user.name
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        containerView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        removeButton.setImage(UIImage(named: "MyProfileBlacklistRemoveButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        removeButton.imageView?.contentMode = .scaleAspectFit
        removeButton.contentHorizontalAlignment = .fill
        removeButton.contentVerticalAlignment = .fill
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
    }

    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 88),

            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),

            removeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14),
            removeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 56),
            removeButton.heightAnchor.constraint(equalTo: removeButton.widthAnchor)
        ])
    }

    @objc private func didTapRemove() {
        removeTapHandler?()
    }
}
