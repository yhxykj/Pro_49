//
//  MyProfileLikePostTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileLikePostTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MyProfileLikePostTableViewCell"

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let moreButton = UIButton(type: .custom)
    private let bodyLabel = UILabel()
    private let postImageView = UIImageView()
    private let likeIconImageView = UIImageView()
    private let likeCountLabel = UILabel()
    private let commentButton = UIButton(type: .custom)

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
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    func configure(with post: SharePost) {
        avatarImageView.image = UIImage(named: post.avatarImageName)?.withRenderingMode(.alwaysOriginal)
        nameLabel.text = post.author
        bodyLabel.text = post.text
        postImageView.image = UIImage(named: post.postImageName)?.withRenderingMode(.alwaysOriginal)
        likeCountLabel.text = "\(post.likeCount)"
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        moreButton.setImage(UIImage(named: "ShareMoreButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.translatesAutoresizingMaskIntoConstraints = false

        bodyLabel.textColor = .black
        bodyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 8
        postImageView.translatesAutoresizingMaskIntoConstraints = false

        likeIconImageView.image = UIImage(named: "ShareLikeIcon")?.withRenderingMode(.alwaysOriginal)
        likeIconImageView.contentMode = .scaleAspectFit
        likeIconImageView.translatesAutoresizingMaskIntoConstraints = false

        likeCountLabel.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        likeCountLabel.font = .systemFont(ofSize: 17, weight: .regular)
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false

        commentButton.setImage(UIImage(named: "ShareCommentIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        commentButton.imageView?.contentMode = .scaleAspectFit
        commentButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(moreButton)
        cardView.addSubview(bodyLabel)
        cardView.addSubview(postImageView)
        cardView.addSubview(likeIconImageView)
        cardView.addSubview(likeCountLabel)
        cardView.addSubview(commentButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -12),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),

            moreButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            moreButton.widthAnchor.constraint(equalToConstant: 32),
            moreButton.heightAnchor.constraint(equalTo: moreButton.widthAnchor),

            bodyLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),

            postImageView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            postImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 0.52),

            likeIconImageView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 14),
            likeIconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            likeIconImageView.widthAnchor.constraint(equalToConstant: 36),
            likeIconImageView.heightAnchor.constraint(equalTo: likeIconImageView.widthAnchor),

            likeCountLabel.leadingAnchor.constraint(equalTo: likeIconImageView.trailingAnchor, constant: 6),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeIconImageView.centerYAnchor),
            likeCountLabel.heightAnchor.constraint(equalToConstant: 26),

            commentButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            commentButton.centerYAnchor.constraint(equalTo: likeIconImageView.centerYAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 32),
            commentButton.heightAnchor.constraint(equalTo: commentButton.widthAnchor),
            commentButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
}
