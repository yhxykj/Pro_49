//
//  AuthInputField.swift
//  Lounit
//
//  Created by Codex on 2026/6/4.
//

import UIKit

final class AuthInputField: UIView {
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    private let titleLabel = UILabel()
    private let fieldContainerView = UIView()
    private let textField = UITextField()
    private let iconButton = UIButton(type: .custom)
    private let isPasswordField: Bool

    init(title: String, iconName: String, isSecure: Bool) {
        self.isPasswordField = isSecure
        super.init(frame: .zero)
        setupView(title: title, iconName: iconName, isSecure: isSecure)
    }

    required init?(coder: NSCoder) {
        self.isPasswordField = false
        super.init(coder: coder)
        setupView(title: "", iconName: "xmark", isSecure: false)
    }

    private func setupView(title: String, iconName: String, isSecure: Bool) {
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        textField.textColor = .black
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = isSecure ? .default : .emailAddress
        textField.textContentType = isSecure ? .password : .emailAddress
        textField.returnKeyType = .done
        textField.delegate = self
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false

        fieldContainerView.backgroundColor = .white
        fieldContainerView.layer.cornerRadius = 27
        fieldContainerView.layer.borderWidth = 3
        fieldContainerView.layer.borderColor = UIColor.black.cgColor
        fieldContainerView.translatesAutoresizingMaskIntoConstraints = false
        fieldContainerView.setContentCompressionResistancePriority(.required, for: .vertical)

        iconButton.setImage(makeIcon(named: iconName), for: .normal)
        iconButton.imageView?.contentMode = .scaleAspectFit
        iconButton.tintColor = UIColor(white: 0.35, alpha: 1)
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        iconButton.addTarget(self, action: #selector(didTapIcon), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(fieldContainerView)
        fieldContainerView.addSubview(textField)
        fieldContainerView.addSubview(iconButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 29),

            fieldContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
            fieldContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fieldContainerView.heightAnchor.constraint(equalToConstant: 54),
            fieldContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(equalToConstant: 92),

            textField.leadingAnchor.constraint(equalTo: fieldContainerView.leadingAnchor, constant: 28),
            textField.trailingAnchor.constraint(equalTo: iconButton.leadingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: fieldContainerView.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),

            iconButton.centerYAnchor.constraint(equalTo: fieldContainerView.centerYAnchor),
            iconButton.trailingAnchor.constraint(equalTo: fieldContainerView.trailingAnchor, constant: -18),
            iconButton.widthAnchor.constraint(equalToConstant: 34),
            iconButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func makeIcon(named name: String) -> UIImage? {
        if let image = UIImage(named: name)?.withRenderingMode(.alwaysOriginal) {
            return image
        }
        return UIImage(systemName: name)
    }

    @objc private func didTapIcon() {
        if isPasswordField {
            textField.isSecureTextEntry.toggle()
            let iconName = textField.isSecureTextEntry ? "AuthEyeClosedIcon" : "AuthEyeOpenIcon"
            iconButton.setImage(makeIcon(named: iconName), for: .normal)
        } else {
            textField.text = nil
        }
    }
}

extension AuthInputField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
