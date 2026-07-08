//
//  ShareCommentTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

struct ShareComment: Codable {
    let id: String
    let author: String
    let avatarImageName: String
    let text: String
    var isMine: Bool = false
}

final class ShareCommentTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShareCommentTableViewCell"
    var avatarTapHandler: (() -> Void)?
    var moreTapHandler: (() -> Void)?

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let moreButton = UIButton(type: .custom)
    private let bodyLabel = UILabel()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = 21
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarTapHandler = nil
        moreTapHandler = nil
    }

    func configure(with comment: ShareComment) {
        avatarImageView.image = UserProfileStore.avatarImage(for: comment.avatarImageName)
        nameLabel.text = comment.author
        bodyLabel.text = comment.text
        if comment.isMine {
            moreButton.setImage(nil, for: .normal)
            moreButton.setTitle("delete", for: .normal)
            moreButton.setTitleColor(UIColor(red: 0.86, green: 0.20, blue: 0.20, alpha: 1), for: .normal)
            moreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            moreButton.contentHorizontalAlignment = .right
        } else {
            moreButton.setTitle(nil, for: .normal)
            moreButton.setImage(UIImage(named: "ShareMoreButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
            moreButton.contentHorizontalAlignment = .center
        }
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(white: 1, alpha: 0.65).cgColor
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 21
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        )

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        moreButton.setImage(UIImage(named: "ShareMoreButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)

        bodyLabel.textColor = .black
        bodyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(moreButton)
        cardView.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalToConstant: 42),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 14),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -12),

            moreButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            moreButton.widthAnchor.constraint(equalToConstant: 58),
            moreButton.heightAnchor.constraint(equalTo: moreButton.widthAnchor),

            bodyLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    @objc private func didTapAvatar() {
        avatarTapHandler?()
    }

    @objc private func didTapMore() {
        moreTapHandler?()
    }
}
