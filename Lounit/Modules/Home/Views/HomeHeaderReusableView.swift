//
//  HomeHeaderReusableView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class HomeHeaderReusableView: UICollectionReusableView {
    static let reuseIdentifier = "HomeHeaderReusableView"

    var exploreTapHandler: (() -> Void)?
    var notesTapHandler: (() -> Void)?
    var badgeTapHandler: (() -> Void)?

    private let titleImageView = UIImageView()
    private let avatarView = UIImageView()
    private let promptCardImageView = UIImageView()
    private let searchBarImageView = UIImageView()
    private let categoryStackView = UIStackView()
    private let recommendedTitleLabel = UILabel()

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
        avatarView.layer.cornerRadius = avatarView.bounds.height / 2
    }

    private func setupView() {
        backgroundColor = .clear

        titleImageView.image = UIImage(named: "HomeHeaderTitle")?.withRenderingMode(.alwaysOriginal)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        avatarView.image = UIImage(named: "LoginMascot")?.withRenderingMode(.alwaysOriginal)
        avatarView.contentMode = .scaleAspectFill
        avatarView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        promptCardImageView.image = UIImage(named: "HomeExplorePromptCard")?.withRenderingMode(.alwaysOriginal)
        promptCardImageView.contentMode = .scaleAspectFill
        promptCardImageView.clipsToBounds = true
        promptCardImageView.translatesAutoresizingMaskIntoConstraints = false

        searchBarImageView.image = UIImage(named: "HomeSearchBar")?.withRenderingMode(.alwaysOriginal)
        searchBarImageView.contentMode = .scaleToFill
        searchBarImageView.translatesAutoresizingMaskIntoConstraints = false

        categoryStackView.axis = .horizontal
        categoryStackView.distribution = .equalSpacing
        categoryStackView.alignment = .center
        categoryStackView.translatesAutoresizingMaskIntoConstraints = false

        let categoryImageViews = [
            UIImageView(image: UIImage(named: "HomeCategoryExplore")?.withRenderingMode(.alwaysOriginal)),
            UIImageView(image: UIImage(named: "HomeCategoryNotes")?.withRenderingMode(.alwaysOriginal)),
            UIImageView(image: UIImage(named: "HomeCategoryBadge")?.withRenderingMode(.alwaysOriginal))
        ]

        categoryImageViews.enumerated().forEach { index, imageView in
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            categoryStackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 94),
                imageView.heightAnchor.constraint(equalToConstant: 124)
            ])

            if index == 0 {
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExplore)))
            } else if index == 1 {
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNotes)))
            } else if index == 2 {
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBadge)))
            }
        }

        recommendedTitleLabel.text = "Recommended cities"
        recommendedTitleLabel.textColor = .black
        recommendedTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        recommendedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(titleImageView)
        addSubview(avatarView)
        addSubview(promptCardImageView)
        addSubview(searchBarImageView)
        addSubview(categoryStackView)
        addSubview(recommendedTitleLabel)

        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 62),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleImageView.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -12),
            titleImageView.heightAnchor.constraint(equalToConstant: 42),

            avatarView.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            avatarView.widthAnchor.constraint(equalToConstant: 58),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),

            promptCardImageView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 38),
            promptCardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            promptCardImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            promptCardImageView.heightAnchor.constraint(equalToConstant: 166),

            searchBarImageView.leadingAnchor.constraint(equalTo: promptCardImageView.leadingAnchor, constant: 22),
            searchBarImageView.trailingAnchor.constraint(equalTo: promptCardImageView.trailingAnchor, constant: -22),
            searchBarImageView.bottomAnchor.constraint(equalTo: promptCardImageView.bottomAnchor, constant: -18),
            searchBarImageView.heightAnchor.constraint(equalToConstant: 48),

            categoryStackView.topAnchor.constraint(equalTo: promptCardImageView.bottomAnchor, constant: 28),
            categoryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            categoryStackView.heightAnchor.constraint(equalToConstant: 124),

            recommendedTitleLabel.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 26),
            recommendedTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            recommendedTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            recommendedTitleLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    @objc private func didTapExplore() {
        exploreTapHandler?()
    }

    @objc private func didTapNotes() {
        notesTapHandler?()
    }

    @objc private func didTapBadge() {
        badgeTapHandler?()
    }
}
