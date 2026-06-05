//
//  LiveChatMessageCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class LiveChatMessageCell: UITableViewCell {
    static let reuseIdentifier = "LiveChatMessageCell"

    private let messageView = LiveChatMessageView()

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

    func configure(name: String, message: String, avatarImageName: String) {
        messageView.configure(name: name, message: message, avatarImageName: avatarImageName)
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupLayout() {
        contentView.addSubview(messageView)

        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
