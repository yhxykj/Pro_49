//
//  LiveStreamingHeaderReusableView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class LiveStreamingHeaderReusableView: UICollectionReusableView {
    static let reuseIdentifier = "LiveStreamingHeaderReusableView"

    var createTapHandler: (() -> Void)?

    private let titleImageView = UIImageView()
    private let createCardImageView = UIImageView()
    private let createCardButton = UIButton(type: .custom)

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
        backgroundColor = .clear

        titleImageView.image = UIImage(named: "LiveStreamingTitle")?.withRenderingMode(.alwaysOriginal)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        createCardImageView.image = UIImage(named: "LiveCreateRoomCard")?.withRenderingMode(.alwaysOriginal)
        createCardImageView.contentMode = .scaleToFill
        createCardImageView.clipsToBounds = true
        createCardImageView.translatesAutoresizingMaskIntoConstraints = false

        createCardButton.backgroundColor = .clear
        createCardButton.translatesAutoresizingMaskIntoConstraints = false
        createCardButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(titleImageView)
        addSubview(createCardImageView)
        addSubview(createCardButton)

        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 78),
            titleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleImageView.widthAnchor.constraint(equalToConstant: 208),
            titleImageView.heightAnchor.constraint(equalToConstant: 31),

            createCardImageView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 32),
            createCardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            createCardImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createCardImageView.heightAnchor.constraint(equalToConstant: 166),

            createCardButton.topAnchor.constraint(equalTo: createCardImageView.topAnchor),
            createCardButton.leadingAnchor.constraint(equalTo: createCardImageView.leadingAnchor),
            createCardButton.trailingAnchor.constraint(equalTo: createCardImageView.trailingAnchor),
            createCardButton.bottomAnchor.constraint(equalTo: createCardImageView.bottomAnchor)
        ])
    }

    @objc private func didTapCreate() {
        createTapHandler?()
    }
}
