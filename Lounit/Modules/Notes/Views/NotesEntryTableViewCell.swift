//
//  NotesEntryTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

struct NotesEntry {
    let date: String
    let text: String
    let imageNames: [String]
}

final class NotesEntryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotesEntryTableViewCell"

    private let dateLabel = UILabel()
    private let cardView = UIView()
    private let bodyLabel = UILabel()
    private let imageStackView = UIStackView()
    private var imageViews: [UIImageView] = []

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

    override func prepareForReuse() {
        super.prepareForReuse()
        imageViews.forEach { $0.image = nil }
    }

    func configure(with entry: NotesEntry) {
        dateLabel.text = entry.date
        bodyLabel.text = entry.text

        imageViews.enumerated().forEach { index, imageView in
            guard index < entry.imageNames.count else { return }
            imageView.image = UIImage(named: entry.imageNames[index])?.withRenderingMode(.alwaysOriginal)
        }
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        dateLabel.textColor = UIColor(white: 0.22, alpha: 1)
        dateLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        cardView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 0.92)
        cardView.layer.cornerRadius = 24
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        bodyLabel.textColor = UIColor(white: 0.23, alpha: 1)
        bodyLabel.font = .systemFont(ofSize: 20, weight: .regular)
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        imageStackView.axis = .horizontal
        imageStackView.spacing = 10
        imageStackView.distribution = .fillEqually
        imageStackView.translatesAutoresizingMaskIntoConstraints = false

        (0..<3).forEach { _ in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 14
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageStackView.addArrangedSubview(imageView)
            imageViews.append(imageView)
        }
    }

    private func setupLayout() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(cardView)

        cardView.addSubview(bodyLabel)
        cardView.addSubview(imageStackView)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            dateLabel.heightAnchor.constraint(equalToConstant: 38),

            cardView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 18),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),

            bodyLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),

            imageStackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 22),
            imageStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            imageStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            imageStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            imageStackView.heightAnchor.constraint(equalToConstant: 118)
        ])
    }
}
