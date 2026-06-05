//
//  LiveGiftPanelView.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

private struct LiveGiftOption {
    let imageName: String
    let price: String
}

final class LiveGiftPanelView: UIView {
    var sendGiftHandler: ((String, Int) -> Void)?

    private let selectedColor = UIColor(red: 78.0 / 255.0, green: 164.0 / 255.0, blue: 252.0 / 255.0, alpha: 1)
    private let unselectedColor = UIColor(red: 54.0 / 255.0, green: 53.0 / 255.0, blue: 84.0 / 255.0, alpha: 1)
    private let giftGridStackView = UIStackView()
    private let footerView = UIView()
    private let balanceCoinImageView = UIImageView()
    private let balanceLabel = UILabel()
    private let quantityContainerView = UIView()
    private let minusButton = UIButton(type: .custom)
    private let quantityLabel = UILabel()
    private let plusButton = UIButton(type: .custom)
    private let giftButton = UIButton(type: .custom)
    private var giftViews: [LiveGiftOptionView] = []
    private var selectedIndex = 0
    private var quantity = 1

    private let gifts: [LiveGiftOption] = [
        LiveGiftOption(imageName: "LiveGiftWand", price: "111"),
        LiveGiftOption(imageName: "LiveGiftMacaron", price: "111"),
        LiveGiftOption(imageName: "LiveGiftIceCream", price: "111"),
        LiveGiftOption(imageName: "LiveGiftFlower", price: "111"),
        LiveGiftOption(imageName: "LiveGiftCup", price: "111"),
        LiveGiftOption(imageName: "LiveGiftCar", price: "111"),
        LiveGiftOption(imageName: "LiveGiftBalloon", price: "111"),
        LiveGiftOption(imageName: "LiveGiftRocket", price: "111")
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        updateSelection()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
        updateSelection()
    }

    private func setupView() {
        backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.28, alpha: 1)
        layer.cornerRadius = 22
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        giftGridStackView.axis = .vertical
        giftGridStackView.spacing = 32
        giftGridStackView.translatesAutoresizingMaskIntoConstraints = false

        footerView.backgroundColor = .clear
        footerView.translatesAutoresizingMaskIntoConstraints = false

        balanceCoinImageView.image = UIImage(named: "LiveGiftCoinLarge")?.withRenderingMode(.alwaysOriginal)
        balanceCoinImageView.contentMode = .scaleAspectFit
        balanceCoinImageView.translatesAutoresizingMaskIntoConstraints = false

        balanceLabel.text = "111"
        balanceLabel.textColor = .white
        balanceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false

        quantityContainerView.backgroundColor = .black
        quantityContainerView.layer.cornerRadius = 17
        quantityContainerView.clipsToBounds = true
        quantityContainerView.translatesAutoresizingMaskIntoConstraints = false

        minusButton.setImage(UIImage(named: "LiveGiftMinusButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        minusButton.imageView?.contentMode = .scaleAspectFit
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)

        quantityLabel.text = "1"
        quantityLabel.textColor = .white
        quantityLabel.font = .systemFont(ofSize: 16, weight: .bold)
        quantityLabel.textAlignment = .center
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false

        plusButton.setImage(UIImage(named: "LiveGiftPlusButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusButton.imageView?.contentMode = .scaleAspectFit
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)

        giftButton.setImage(UIImage(named: "LiveGiftSendButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        giftButton.imageView?.contentMode = .scaleAspectFit
        giftButton.translatesAutoresizingMaskIntoConstraints = false
        giftButton.addTarget(self, action: #selector(didTapSendGift), for: .touchUpInside)
    }

    private func setupLayout() {
        addSubview(giftGridStackView)
        addSubview(footerView)

        setupGiftGrid()

        footerView.addSubview(balanceCoinImageView)
        footerView.addSubview(balanceLabel)
        footerView.addSubview(quantityContainerView)
        footerView.addSubview(giftButton)

        quantityContainerView.addSubview(minusButton)
        quantityContainerView.addSubview(quantityLabel)
        quantityContainerView.addSubview(plusButton)

        NSLayoutConstraint.activate([
            giftGridStackView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            giftGridStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            giftGridStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            footerView.topAnchor.constraint(greaterThanOrEqualTo: giftGridStackView.bottomAnchor, constant: 20),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            footerView.heightAnchor.constraint(equalToConstant: 46),

            balanceCoinImageView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            balanceCoinImageView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            balanceCoinImageView.widthAnchor.constraint(equalToConstant: 34),
            balanceCoinImageView.heightAnchor.constraint(equalTo: balanceCoinImageView.widthAnchor),

            balanceLabel.leadingAnchor.constraint(equalTo: balanceCoinImageView.trailingAnchor, constant: 8),
            balanceLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            balanceLabel.widthAnchor.constraint(equalToConstant: 56),

            giftButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            giftButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            giftButton.widthAnchor.constraint(equalToConstant: 74),
            giftButton.heightAnchor.constraint(equalToConstant: 32),

            quantityContainerView.trailingAnchor.constraint(equalTo: giftButton.leadingAnchor, constant: -18),
            quantityContainerView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            quantityContainerView.widthAnchor.constraint(equalToConstant: 92),
            quantityContainerView.heightAnchor.constraint(equalToConstant: 34),

            minusButton.leadingAnchor.constraint(equalTo: quantityContainerView.leadingAnchor, constant: 2),
            minusButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor),

            plusButton.trailingAnchor.constraint(equalTo: quantityContainerView.trailingAnchor, constant: -2),
            plusButton.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),

            quantityLabel.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: quantityContainerView.centerYAnchor)
        ])
    }

    private func setupGiftGrid() {
        stride(from: 0, to: gifts.count, by: 4).forEach { startIndex in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .center
            rowStackView.distribution = .equalSpacing
            rowStackView.translatesAutoresizingMaskIntoConstraints = false

            gifts[startIndex..<min(startIndex + 4, gifts.count)].enumerated().forEach { offset, gift in
                let giftView = LiveGiftOptionView(selectedColor: selectedColor, unselectedColor: unselectedColor)
                giftView.configure(imageName: gift.imageName, price: gift.price)
                giftView.tag = startIndex + offset
                giftView.addTarget(self, action: #selector(didSelectGift(_:)), for: .touchUpInside)
                rowStackView.addArrangedSubview(giftView)
                giftViews.append(giftView)

                NSLayoutConstraint.activate([
                    giftView.widthAnchor.constraint(equalToConstant: 74),
                    giftView.heightAnchor.constraint(equalToConstant: 108)
                ])
            }

            giftGridStackView.addArrangedSubview(rowStackView)
            rowStackView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        }
    }

    private func updateSelection() {
        giftViews.enumerated().forEach { index, giftView in
            giftView.setSelected(index == selectedIndex)
        }
    }

    @objc private func didSelectGift(_ sender: LiveGiftOptionView) {
        selectedIndex = sender.tag
        updateSelection()
    }

    @objc private func didTapMinus() {
        quantity = max(1, quantity - 1)
        updateQuantity()
    }

    @objc private func didTapPlus() {
        quantity += 1
        updateQuantity()
    }

    @objc private func didTapSendGift() {
        guard selectedIndex < gifts.count else { return }
        sendGiftHandler?(gifts[selectedIndex].imageName, quantity)
    }

    private func updateQuantity() {
        quantityLabel.text = "\(quantity)"
    }
}

private final class LiveGiftOptionView: UIControl {
    private let selectedColor: UIColor
    private let unselectedColor: UIColor
    private let imageBackgroundView = UIView()
    private let giftImageView = UIImageView()
    private let coinImageView = UIImageView()
    private let priceLabel = UILabel()

    init(selectedColor: UIColor, unselectedColor: UIColor) {
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        selectedColor = UIColor(red: 78.0 / 255.0, green: 164.0 / 255.0, blue: 252.0 / 255.0, alpha: 1)
        unselectedColor = UIColor(red: 54.0 / 255.0, green: 53.0 / 255.0, blue: 84.0 / 255.0, alpha: 1)
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    func configure(imageName: String, price: String) {
        giftImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        priceLabel.text = price
    }

    func setSelected(_ selected: Bool) {
        imageBackgroundView.backgroundColor = selected ? selectedColor : unselectedColor
    }

    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        imageBackgroundView.backgroundColor = unselectedColor
        imageBackgroundView.layer.cornerRadius = 12
        imageBackgroundView.layer.borderWidth = 1
        imageBackgroundView.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        imageBackgroundView.isUserInteractionEnabled = false
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        giftImageView.contentMode = .scaleAspectFit
        giftImageView.isUserInteractionEnabled = false
        giftImageView.translatesAutoresizingMaskIntoConstraints = false

        coinImageView.image = UIImage(named: "LiveGiftCoinSmall")?.withRenderingMode(.alwaysOriginal)
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.isUserInteractionEnabled = false
        coinImageView.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.textColor = .white
        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        priceLabel.isUserInteractionEnabled = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        addSubview(imageBackgroundView)
        addSubview(coinImageView)
        addSubview(priceLabel)
        imageBackgroundView.addSubview(giftImageView)

        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            imageBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 64),
            imageBackgroundView.heightAnchor.constraint(equalTo: imageBackgroundView.widthAnchor),

            giftImageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            giftImageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            giftImageView.widthAnchor.constraint(equalToConstant: 44),
            giftImageView.heightAnchor.constraint(equalTo: giftImageView.widthAnchor),

            coinImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            coinImageView.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: 14),
            coinImageView.widthAnchor.constraint(equalToConstant: 18),
            coinImageView.heightAnchor.constraint(equalTo: coinImageView.widthAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 6),
            priceLabel.centerYAnchor.constraint(equalTo: coinImageView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }
}
