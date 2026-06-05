//
//  ProfileSetupCardView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ProfileSetupCardView: UIView {
    var backHandler: (() -> Void)?
    var completeHandler: (() -> Void)?

    private let backButton = UIButton(type: .custom)
    private let tourView = AuthTourBadgeView()
    private let cardView = UIView()
    private let titleImageView = UIImageView()
    private let avatarView = UIView()
    private let avatarSwitchButton = UIButton(type: .custom)
    private let nameLabel = UILabel()
    private let nameFieldContainerView = UIView()
    private let nameTextField = UITextField()
    private let createAccountButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setupBackButton()
        setupCard()
        setupTitle()
        setupAvatar()
        setupNameField()
        setupCreateButton()
        setupLayout()
    }

    private func setupBackButton() {
        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }

    private func setupCard() {
        cardView.backgroundColor = UIColor(red: 0.57, green: 0.65, blue: 0.68, alpha: 0.86)
        cardView.layer.cornerRadius = 34
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.18
        cardView.layer.shadowRadius = 22
        cardView.layer.shadowOffset = CGSize(width: 0, height: 14)
        cardView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTitle() {
        titleImageView.image = UIImage(named: "ProfileInfoTitle")?.withRenderingMode(.alwaysOriginal)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupAvatar() {
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 60
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarSwitchButton.setImage(UIImage(named: "ProfileAvatarSwitchIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        avatarSwitchButton.imageView?.contentMode = .scaleAspectFit
        avatarSwitchButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupNameField() {
        nameLabel.text = "Name"
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        nameFieldContainerView.backgroundColor = .white
        nameFieldContainerView.layer.cornerRadius = 27
        nameFieldContainerView.layer.borderWidth = 3
        nameFieldContainerView.layer.borderColor = UIColor.black.cgColor
        nameFieldContainerView.translatesAutoresizingMaskIntoConstraints = false

        nameTextField.textColor = .black
        nameTextField.font = .systemFont(ofSize: 18, weight: .semibold)
        nameTextField.borderStyle = .none
        nameTextField.backgroundColor = .clear
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupCreateButton() {
        createAccountButton.setImage(UIImage(named: "ProfileCreateAccountButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createAccountButton.imageView?.contentMode = .scaleAspectFit
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(backButton)
        addSubview(cardView)
        addSubview(tourView)

        cardView.addSubview(titleImageView)
        cardView.addSubview(avatarView)
        cardView.addSubview(avatarSwitchButton)
        cardView.addSubview(nameLabel)
        cardView.addSubview(nameFieldContainerView)
        cardView.addSubview(createAccountButton)

        nameFieldContainerView.addSubview(nameTextField)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            tourView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: 52),
            tourView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            tourView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.48),
            tourView.heightAnchor.constraint(equalTo: tourView.widthAnchor, multiplier: 0.82),

            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            cardView.heightAnchor.constraint(equalToConstant: 463),

            titleImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30),
            titleImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 268),
            titleImageView.heightAnchor.constraint(equalToConstant: 68),

            avatarView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 16),
            avatarView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 120),
            avatarView.heightAnchor.constraint(equalToConstant: 120),

            avatarSwitchButton.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            avatarSwitchButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            avatarSwitchButton.widthAnchor.constraint(equalToConstant: 32),
            avatarSwitchButton.heightAnchor.constraint(equalToConstant: 32),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 33),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -33),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),

            nameFieldContainerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            nameFieldContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 33),
            nameFieldContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -33),
            nameFieldContainerView.heightAnchor.constraint(equalToConstant: 54),

            nameTextField.leadingAnchor.constraint(equalTo: nameFieldContainerView.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: nameFieldContainerView.trailingAnchor, constant: -24),
            nameTextField.centerYAnchor.constraint(equalTo: nameFieldContainerView.centerYAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 42),

            createAccountButton.topAnchor.constraint(equalTo: nameFieldContainerView.bottomAnchor, constant: 24),
            createAccountButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalToConstant: 267),
            createAccountButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    @objc private func didTapBack() {
        backHandler?()
    }

    @objc private func didTapCreateAccount() {
        completeHandler?()
    }
}
