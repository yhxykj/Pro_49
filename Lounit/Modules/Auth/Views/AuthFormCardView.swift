//
//  AuthFormCardView.swift
//  Lounit
//
//  Created by Codex on 2026/6/4.
//

import UIKit

enum AuthFormMode {
    case login
    case register

    var title: String {
        switch self {
        case .login:
            return "Welcome to join us"
        case .register:
            return "Create your account"
        }
    }

    var subtitle: String {
        switch self {
        case .login:
            return "Log in to share and discuss topics"
        case .register:
            return "Register to share and discuss topics"
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .login:
            return "Next"
        case .register:
            return "Create Account"
        }
    }
}

final class AuthFormCardView: UIView {
    var backHandler: (() -> Void)?
    var loginHandler: ((_ mail: String, _ password: String) -> Void)?
    var registrationCompleteHandler: ((_ mail: String, _ password: String) -> Void)?
    var agreementMissingHandler: (() -> Void)?
    var agreementLinksHandler: (() -> Void)?
    var validationFailedHandler: ((_ message: String) -> Void)?

    private let mode: AuthFormMode
    private let cardView = UIView()
    private let tourView = AuthTourBadgeView()
    private let backButton = UIButton(type: .custom)
    private let welcomeTextImageView = UIImageView()
    private let fieldsStack = UIStackView()
    private let mailField = AuthInputField(title: "Mail", iconName: "xmark", isSecure: false)
    private let passwordField = AuthInputField(title: "Password", iconName: "AuthEyeClosedIcon", isSecure: true)
    private let primaryButton = UIButton(type: .custom)
    private let agreementButton = UIButton(type: .custom)
    private let agreementLabel = UILabel()
    private var isAgreementAccepted = false

    init(mode: AuthFormMode) {
        self.mode = mode
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        self.mode = .login
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        setupBackButton()
        setupCard()
        setupText()
        setupFields()
        setupActions()
        setupAgreement()
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

    private func setupText() {
        welcomeTextImageView.image = UIImage(named: "AuthWelcomeText")?.withRenderingMode(.alwaysOriginal)
        welcomeTextImageView.contentMode = .scaleAspectFit
        welcomeTextImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupFields() {
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 28
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        fieldsStack.addArrangedSubview(mailField)
        fieldsStack.addArrangedSubview(passwordField)
    }

    private func setupActions() {
        primaryButton.setImage(UIImage(named: "AuthNextButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        primaryButton.imageView?.contentMode = .scaleAspectFit
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)

    }

    private func setupAgreement() {
        agreementButton.layer.cornerRadius = 6
        agreementButton.layer.borderWidth = 2
        agreementButton.layer.borderColor = UIColor.white.cgColor
        agreementButton.backgroundColor = .clear
        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        agreementButton.addTarget(self, action: #selector(didTapAgreement), for: .touchUpInside)

        agreementLabel.text = "I agree to the User Agreement and Privacy Policy"
        agreementLabel.textColor = .white
        agreementLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        agreementLabel.adjustsFontSizeToFitWidth = true
        agreementLabel.minimumScaleFactor = 0.75
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAgreementLinks))
        agreementLabel.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        addSubview(backButton)
        addSubview(cardView)
        addSubview(tourView)
        addSubview(agreementButton)
        addSubview(agreementLabel)

        cardView.addSubview(welcomeTextImageView)
        cardView.addSubview(fieldsStack)
        cardView.addSubview(primaryButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            tourView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: 52),
            tourView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            tourView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.48),
            tourView.heightAnchor.constraint(equalTo: tourView.widthAnchor, multiplier: 0.82),

            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            cardView.heightAnchor.constraint(equalToConstant: 463),

            welcomeTextImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 42),
            welcomeTextImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            welcomeTextImageView.widthAnchor.constraint(equalToConstant: 232),
            welcomeTextImageView.heightAnchor.constraint(equalToConstant: 60),

            fieldsStack.topAnchor.constraint(equalTo: welcomeTextImageView.bottomAnchor, constant: 26),
            fieldsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 28),
            fieldsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -28),

            primaryButton.topAnchor.constraint(equalTo: fieldsStack.bottomAnchor, constant: 24),
            primaryButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            primaryButton.widthAnchor.constraint(equalToConstant: 267),
            primaryButton.heightAnchor.constraint(equalToConstant: 64),

            agreementButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 14),
            agreementButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            agreementButton.widthAnchor.constraint(equalToConstant: 22),
            agreementButton.heightAnchor.constraint(equalToConstant: 22),

            agreementLabel.centerYAnchor.constraint(equalTo: agreementButton.centerYAnchor),
            agreementLabel.leadingAnchor.constraint(equalTo: agreementButton.trailingAnchor, constant: 8),
            agreementLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10)
        ])
    }

    @objc private func didTapBack() {
        backHandler?()
    }

    @objc private func didTapPrimary() {
        guard isAgreementAccepted else {
            agreementMissingHandler?()
            return
        }

        let mail = mailField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text
        guard !mail.isEmpty, !password.isEmpty else {
            validationFailedHandler?("Please enter your mail and password.")
            return
        }

        if mode == .login {
            loginHandler?(mail, password)
        } else {
            registrationCompleteHandler?(mail, password)
        }
    }

    @objc private func didTapAgreement() {
        isAgreementAccepted.toggle()
        let imageName = isAgreementAccepted ? "checkmark" : nil
        agreementButton.setImage(imageName.flatMap { UIImage(systemName: $0) }, for: .normal)
        agreementButton.tintColor = .white
        agreementButton.backgroundColor = isAgreementAccepted ? UIColor(red: 0.3, green: 0.64, blue: 0.96, alpha: 1) : .clear
    }

    @objc private func didTapAgreementLinks() {
        agreementLinksHandler?()
    }

}
