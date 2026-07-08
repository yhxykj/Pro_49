//
//  MyProfileActionButtonsView.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileActionButtonsView: UIView {
    var editTapHandler: (() -> Void)?
    var walletTapHandler: (() -> Void)?

    private let editButton = UIButton(type: .custom)
    private let walletButton = UIButton(type: .custom)

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

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        editButton.setImage(UIImage(named: "MyProfileEditButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.contentHorizontalAlignment = .fill
        editButton.contentVerticalAlignment = .fill
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)

        walletButton.setImage(UIImage(named: "MyProfileWalletButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        walletButton.imageView?.contentMode = .scaleAspectFit
        walletButton.contentHorizontalAlignment = .fill
        walletButton.contentVerticalAlignment = .fill
        walletButton.translatesAutoresizingMaskIntoConstraints = false
        walletButton.addTarget(self, action: #selector(didTapWallet), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(editButton)
        addSubview(walletButton)

        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editButton.topAnchor.constraint(equalTo: topAnchor),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            walletButton.leadingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: 13),
            walletButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            walletButton.topAnchor.constraint(equalTo: topAnchor),
            walletButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            walletButton.widthAnchor.constraint(equalTo: editButton.widthAnchor)
        ])
    }

    @objc private func didTapEdit() {
        editTapHandler?()
    }

    @objc private func didTapWallet() {
        walletTapHandler?()
    }
}
