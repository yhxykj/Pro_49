//
//  ShareDetailPostTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ShareDetailPostTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShareDetailPostTableViewCell"
    var avatarTapHandler: (() -> Void)?
    var likeTapHandler: (() -> Void)?
    var moreTapHandler: (() -> Void)?

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let moreButton = UIButton(type: .custom)
    private let bodyLabel = UILabel()
    private let postImageView = UIImageView()
    private let likeButton = UIButton(type: .custom)
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
        avatarImageView.layer.cornerRadius = 21
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarTapHandler = nil
        likeTapHandler = nil
        moreTapHandler = nil
    }

    func configure(with post: SharePost) {
        avatarImageView.image = UIImage(named: post.avatarImageName)?.withRenderingMode(.alwaysOriginal)
        nameLabel.text = post.author
        bodyLabel.text = post.text
        postImageView.image = UIImage(named: post.postImageName)?.withRenderingMode(.alwaysOriginal)
        likeCountLabel.text = "\(post.likeCount)"
        likeCountLabel.textColor = post.isLiked
            ? UIColor(red: 0.94, green: 0.28, blue: 0.38, alpha: 1)
            : UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        likeButton.isSelected = post.isLiked
        likeButton.alpha = 1
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
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

        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 9
        postImageView.translatesAutoresizingMaskIntoConstraints = false

        likeButton.setImage(UIImage(named: "ShareHeartOutlineIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: "ShareLikeIcon")?.withRenderingMode(.alwaysOriginal), for: .selected)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)

        likeCountLabel.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        likeCountLabel.font = .systemFont(ofSize: 18, weight: .regular)
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
        cardView.addSubview(likeButton)
        cardView.addSubview(likeCountLabel)
        cardView.addSubview(commentButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalToConstant: 42),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 14),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -12),

            moreButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            moreButton.widthAnchor.constraint(equalToConstant: 32),
            moreButton.heightAnchor.constraint(equalTo: moreButton.widthAnchor),

            bodyLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 18),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),

            postImageView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 18),
            postImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            postImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 0.50),

            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            likeButton.widthAnchor.constraint(equalToConstant: 36),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),

            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),

            commentButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 32),
            commentButton.heightAnchor.constraint(equalTo: commentButton.widthAnchor),
            commentButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])
    }

    @objc private func didTapAvatar() {
        avatarTapHandler?()
    }

    @objc private func didTapLike() {
        likeTapHandler?()
    }

    @objc private func didTapMore() {
        moreTapHandler?()
    }
}
