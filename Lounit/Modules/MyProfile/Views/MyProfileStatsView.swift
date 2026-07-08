//
//  MyProfileStatsView.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileStatsView: UIView {
    var followTapHandler: (() -> Void)?
    var fansTapHandler: (() -> Void)?
    var likesTapHandler: (() -> Void)?

    private let followView = MyProfileStatItemView(value: "0", title: "Follow")
    private let fansView = MyProfileStatItemView(value: "4", title: "Fans")
    private let likesView = MyProfileStatItemView(value: "0", title: "Likes")
    private let firstDividerView = UIView()
    private let secondDividerView = UIView()

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
    }

    func configure(followCount: Int, fansCount: Int, likesCount: Int) {
        followView.configure(value: "\(followCount)")
        fansView.configure(value: "\(fansCount)")
        likesView.configure(value: "\(likesCount)")
    }

    private func setupView() {
        backgroundColor = .white
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        [firstDividerView, secondDividerView].forEach {
            $0.backgroundColor = UIColor(white: 0.82, alpha: 1)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        followView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFollow)))
        fansView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFans)))
        likesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLikes)))
    }

    private func setupLayout() {
        addSubview(followView)
        addSubview(fansView)
        addSubview(likesView)
        addSubview(firstDividerView)
        addSubview(secondDividerView)

        NSLayoutConstraint.activate([
            followView.leadingAnchor.constraint(equalTo: leadingAnchor),
            followView.topAnchor.constraint(equalTo: topAnchor),
            followView.bottomAnchor.constraint(equalTo: bottomAnchor),
            followView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / 3.0),

            fansView.leadingAnchor.constraint(equalTo: followView.trailingAnchor),
            fansView.topAnchor.constraint(equalTo: topAnchor),
            fansView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fansView.widthAnchor.constraint(equalTo: followView.widthAnchor),

            likesView.leadingAnchor.constraint(equalTo: fansView.trailingAnchor),
            likesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            likesView.topAnchor.constraint(equalTo: topAnchor),
            likesView.bottomAnchor.constraint(equalTo: bottomAnchor),

            firstDividerView.leadingAnchor.constraint(equalTo: followView.trailingAnchor),
            firstDividerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            firstDividerView.widthAnchor.constraint(equalToConstant: 1),
            firstDividerView.heightAnchor.constraint(equalToConstant: 58),

            secondDividerView.leadingAnchor.constraint(equalTo: fansView.trailingAnchor),
            secondDividerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondDividerView.widthAnchor.constraint(equalToConstant: 1),
            secondDividerView.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    @objc private func didTapFollow() {
        followTapHandler?()
    }

    @objc private func didTapFans() {
        fansTapHandler?()
    }

    @objc private func didTapLikes() {
        likesTapHandler?()
    }
}

private final class MyProfileStatItemView: UIView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    init(value: String, title: String) {
        super.init(frame: .zero)
        valueLabel.text = value
        titleLabel.text = title
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    func configure(value: String) {
        valueLabel.text = value
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true

        valueLabel.textColor = .black
        valueLabel.font = .systemFont(ofSize: 26, weight: .bold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(valueLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 31),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 9),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
}
