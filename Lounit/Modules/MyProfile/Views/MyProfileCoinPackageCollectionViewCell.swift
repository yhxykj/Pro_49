//
//  MyProfileCoinPackageCollectionViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

struct MyProfileCoinPackage {
    let diamonds: Int
    let price: String
    let productIdentifier: String
    var isSelected: Bool
}

final class MyProfileCoinPackageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MyProfileCoinPackageCollectionViewCell"

    private let coinContainerView = UIView()
    private let coinImageView = UIImageView()
    private let coinLabel = UILabel()
    private let priceButton = UIButton(type: .custom)

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

    func configure(with package: MyProfileCoinPackage) {
        coinLabel.text = "\(package.diamonds)"
        priceButton.setTitle(package.price, for: .normal)
        coinContainerView.backgroundColor = package.isSelected
            ? UIColor(red: 0.30, green: 0.64, blue: 0.98, alpha: 1)
            : UIColor(white: 0.96, alpha: 1)
        coinLabel.textColor = package.isSelected ? .white : .black
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        coinContainerView.layer.cornerRadius = 22
        coinContainerView.clipsToBounds = true
        coinContainerView.translatesAutoresizingMaskIntoConstraints = false

        coinImageView.image = UIImage(named: "MyProfileShopCoin")?.withRenderingMode(.alwaysOriginal)
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false

        coinLabel.textAlignment = .center
        coinLabel.font = .systemFont(ofSize: 20, weight: .bold)
        coinLabel.translatesAutoresizingMaskIntoConstraints = false

        priceButton.backgroundColor = .black
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        priceButton.layer.cornerRadius = 19
        priceButton.clipsToBounds = true
        priceButton.isUserInteractionEnabled = false
        priceButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        contentView.addSubview(coinContainerView)
        contentView.addSubview(priceButton)
        coinContainerView.addSubview(coinImageView)
        coinContainerView.addSubview(coinLabel)

        NSLayoutConstraint.activate([
            coinContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coinContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coinContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coinContainerView.heightAnchor.constraint(equalToConstant: 104),

            coinImageView.topAnchor.constraint(equalTo: coinContainerView.topAnchor, constant: 12),
            coinImageView.centerXAnchor.constraint(equalTo: coinContainerView.centerXAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 52),
            coinImageView.heightAnchor.constraint(equalTo: coinImageView.widthAnchor),

            coinLabel.topAnchor.constraint(equalTo: coinImageView.bottomAnchor, constant: 4),
            coinLabel.leadingAnchor.constraint(equalTo: coinContainerView.leadingAnchor, constant: 8),
            coinLabel.trailingAnchor.constraint(equalTo: coinContainerView.trailingAnchor, constant: -8),
            coinLabel.heightAnchor.constraint(equalToConstant: 28),

            priceButton.topAnchor.constraint(equalTo: coinContainerView.bottomAnchor, constant: 8),
            priceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceButton.heightAnchor.constraint(equalToConstant: 38),
            priceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
