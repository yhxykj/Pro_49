//
//  ModerationCardOverlayView.swift
//  Lounit
//
//  Created by Codex on 2026/6/9.
//

import UIKit

struct ModerationCardAction {
    let title: String
    let message: String
    let systemImageName: String
    let tintColor: UIColor
    let handler: () -> Void
}

final class ModerationCardOverlayView: UIView {
    private let cardView = UIView()
    private var cardBottomConstraint: NSLayoutConstraint?
    private var actionHandlers: [() -> Void] = []

    static func present(
        in hostView: UIView,
        title: String,
        message: String,
        actions: [ModerationCardAction],
        cancelTitle: String? = "Cancel"
    ) {
        let overlayView = ModerationCardOverlayView(
            title: title,
            message: message,
            actions: actions,
            cancelTitle: cancelTitle
        )
        hostView.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: hostView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: hostView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: hostView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: hostView.bottomAnchor)
        ])

        overlayView.show()
    }

    private init(
        title: String,
        message: String,
        actions: [ModerationCardAction],
        cancelTitle: String?
    ) {
        super.init(frame: .zero)
        actionHandlers = actions.map(\.handler)
        setupView(title: title, message: message, actions: actions, cancelTitle: cancelTitle)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView(
        title: String,
        message: String,
        actions: [ModerationCardAction],
        cancelTitle: String?
    ) {
        backgroundColor = UIColor.black.withAlphaComponent(0.34)
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false

        let backdropButton = UIButton(type: .custom)
        backdropButton.backgroundColor = .clear
        backdropButton.translatesAutoresizingMaskIntoConstraints = false
        backdropButton.addTarget(self, action: #selector(dismissOnly), for: .touchUpInside)

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 26
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.22
        cardView.layer.shadowRadius = 26
        cardView.layer.shadowOffset = CGSize(width: 0, height: 16)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let grabberView = UIView()
        grabberView.backgroundColor = UIColor(white: 0.86, alpha: 1)
        grabberView.layer.cornerRadius = 2
        grabberView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor(white: 0.08, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = UIColor(white: 0.38, alpha: 1)
        messageLabel.font = .systemFont(ofSize: 15, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        actions.enumerated().forEach { index, action in
            stackView.addArrangedSubview(makeActionControl(action: action, index: index))
        }

        addSubview(backdropButton)
        addSubview(cardView)
        cardView.addSubview(grabberView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(messageLabel)
        cardView.addSubview(stackView)

        let cardBottomConstraint = cardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 260)
        self.cardBottomConstraint = cardBottomConstraint

        NSLayoutConstraint.activate([
            backdropButton.topAnchor.constraint(equalTo: topAnchor),
            backdropButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            cardBottomConstraint,

            grabberView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            grabberView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 42),
            grabberView.heightAnchor.constraint(equalToConstant: 4),

            titleLabel.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 22),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18)
        ])

        if let cancelTitle {
            let cancelButton = UIButton(type: .system)
            cancelButton.setTitle(cancelTitle, for: .normal)
            cancelButton.setTitleColor(UIColor(white: 0.36, alpha: 1), for: .normal)
            cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            cancelButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cancelButton.layer.cornerRadius = 18
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.addTarget(self, action: #selector(dismissOnly), for: .touchUpInside)
            cardView.addSubview(cancelButton)

            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
                cancelButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                cancelButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                cancelButton.heightAnchor.constraint(equalToConstant: 44),
                cancelButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
            ])
        } else {
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -22).isActive = true
        }
    }

    private func makeActionControl(action: ModerationCardAction, index: Int) -> UIControl {
        let control = UIControl()
        control.tag = index
        control.backgroundColor = UIColor(white: 0.97, alpha: 1)
        control.layer.cornerRadius = 18
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didTapAction(_:)), for: .touchUpInside)

        let iconBackgroundView = UIView()
        iconBackgroundView.backgroundColor = action.tintColor.withAlphaComponent(0.12)
        iconBackgroundView.layer.cornerRadius = 22
        iconBackgroundView.isUserInteractionEnabled = false
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: action.systemImageName))
        iconImageView.tintColor = action.tintColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = action.title
        titleLabel.textColor = UIColor(white: 0.10, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = action.message
        messageLabel.textColor = UIColor(white: 0.42, alpha: 1)
        messageLabel.font = .systemFont(ofSize: 13, weight: .medium)
        messageLabel.numberOfLines = 2
        messageLabel.isUserInteractionEnabled = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = UIColor(white: 0.68, alpha: 1)
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.isUserInteractionEnabled = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        control.addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(iconImageView)
        control.addSubview(titleLabel)
        control.addSubview(messageLabel)
        control.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            control.heightAnchor.constraint(equalToConstant: 76),

            iconBackgroundView.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: 14),
            iconBackgroundView.centerYAnchor.constraint(equalTo: control.centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 44),
            iconBackgroundView.heightAnchor.constraint(equalTo: iconBackgroundView.widthAnchor),

            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 23),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            chevronImageView.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: control.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),

            titleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: control.topAnchor, constant: 15),

            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])

        return control
    }

    private func show() {
        layoutIfNeeded()
        cardBottomConstraint?.constant = -10

        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseOut]) {
            self.alpha = 1
            self.layoutIfNeeded()
        }
    }

    @objc private func dismissOnly() {
        dismiss()
    }

    @objc private func didTapAction(_ sender: UIControl) {
        let handler = actionHandlers[sender.tag]
        dismiss(completion: handler)
    }

    private func dismiss(completion: (() -> Void)? = nil) {
        cardBottomConstraint?.constant = 260
        UIView.animate(withDuration: 0.20, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }
}
