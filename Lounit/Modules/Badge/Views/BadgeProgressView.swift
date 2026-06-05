//
//  BadgeProgressView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class BadgeProgressView: UIView {
    private let trackImageView = UIImageView()
    private let fillView = UIView()
    private var fillWidthConstraint: NSLayoutConstraint?
    private var progress: CGFloat = 0

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
        layer.cornerRadius = bounds.height / 2
        fillView.layer.cornerRadius = bounds.height / 2
        fillWidthConstraint?.constant = bounds.width * progress
    }

    func setProgress(_ progress: CGFloat) {
        self.progress = min(max(progress, 0), 1)
        setNeedsLayout()
    }

    private func setupView() {
        clipsToBounds = true

        trackImageView.image = UIImage(named: "BadgeProgressTrack")?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16),
            resizingMode: .stretch
        )
        trackImageView.contentMode = .scaleToFill
        trackImageView.translatesAutoresizingMaskIntoConstraints = false

        fillView.backgroundColor = UIColor(red: 0.28, green: 0.62, blue: 0.96, alpha: 1)
        fillView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(trackImageView)
        addSubview(fillView)

        let fillWidthConstraint = fillView.widthAnchor.constraint(equalToConstant: 0)
        self.fillWidthConstraint = fillWidthConstraint

        NSLayoutConstraint.activate([
            trackImageView.topAnchor.constraint(equalTo: topAnchor),
            trackImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            fillView.topAnchor.constraint(equalTo: topAnchor),
            fillView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fillView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fillWidthConstraint
        ])
    }
}
