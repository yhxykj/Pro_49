//
//  MyProfileCoinShopViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit
import StoreKit

@MainActor
final class MyProfileCoinShopViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let largeCoinImageView = UIImageView()
    private let remainingTitleLabel = UILabel()
    private let remainingValueLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let collectionView: UICollectionView
    private weak var paymentLoadingOverlayView: UIView?
    private var selectedPackageIndex = 0
    private var isProcessingPayment = false

    private var packages: [MyProfileCoinPackage] = [ // whwwsrxelwalihvt
        MyProfileCoinPackage(diamonds: 63700, price: "$99.99", productIdentifier: "abzawgcpjukkdpnp", isSelected: true),
        MyProfileCoinPackage(diamonds: 29400, price: "$49.99", productIdentifier: "egcxbayhztwupakk", isSelected: false),
        MyProfileCoinPackage(diamonds: 10800, price: "$19.99", productIdentifier: "btibqmlqfwjcbaao", isSelected: false),
        MyProfileCoinPackage(diamonds: 5150, price: "$9.99", productIdentifier: "sawdcavypxabrfsn", isSelected: false),
        MyProfileCoinPackage(diamonds: 2450, price: "$4.99", productIdentifier: "ilxnmifjahzjqnfn", isSelected: false),
        MyProfileCoinPackage(diamonds: 800, price: "$1.99", productIdentifier: "jxjxelgvghadptgj", isSelected: false),
        MyProfileCoinPackage(diamonds: 400, price: "$0.99", productIdentifier: "new_1000", isSelected: false)
    ]

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateRemainingBalance(animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        view.bringSubviewToFront(backButton)
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.82, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.50, 0.94]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        titleLabel.text = "shop"
        titleLabel.textColor = .white
        titleLabel.font = .myProfilePageTitleFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        largeCoinImageView.image = UIImage(named: "MyProfileShopCoinLarge")?.withRenderingMode(.alwaysOriginal)
        largeCoinImageView.contentMode = .scaleAspectFit
        largeCoinImageView.translatesAutoresizingMaskIntoConstraints = false

        remainingTitleLabel.text = "Remaining"
        remainingTitleLabel.textColor = .white
        remainingTitleLabel.font = .systemFont(ofSize: 32, weight: .medium)
        remainingTitleLabel.textAlignment = .left
        remainingTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        remainingValueLabel.text = "\(GoldCoinStore.balance)"
        remainingValueLabel.textColor = UIColor(red: 0.96, green: 0.43, blue: 0.47, alpha: 1)
        remainingValueLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        remainingValueLabel.textAlignment = .center
        remainingValueLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = "Diamonds can be used to post city\nexploration moments and purchase live\nstream gifts."
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            MyProfileCoinPackageCollectionViewCell.self,
            forCellWithReuseIdentifier: MyProfileCoinPackageCollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(largeCoinImageView)
        view.addSubview(remainingTitleLabel)
        view.addSubview(remainingValueLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(collectionView)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 180),
            titleLabel.heightAnchor.constraint(equalToConstant: 42),

            largeCoinImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 26),
            largeCoinImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            largeCoinImageView.widthAnchor.constraint(equalToConstant: 109),
            largeCoinImageView.heightAnchor.constraint(equalTo: largeCoinImageView.widthAnchor),

            remainingTitleLabel.topAnchor.constraint(equalTo: largeCoinImageView.topAnchor, constant: 18),
            remainingTitleLabel.leadingAnchor.constraint(equalTo: largeCoinImageView.trailingAnchor, constant: 36),
            remainingTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            remainingTitleLabel.heightAnchor.constraint(equalToConstant: 34),

            remainingValueLabel.topAnchor.constraint(equalTo: remainingTitleLabel.bottomAnchor, constant: 9),
            remainingValueLabel.leadingAnchor.constraint(equalTo: remainingTitleLabel.leadingAnchor),
            remainingValueLabel.trailingAnchor.constraint(equalTo: remainingTitleLabel.trailingAnchor),
            remainingValueLabel.heightAnchor.constraint(equalToConstant: 34),

            descriptionLabel.topAnchor.constraint(equalTo: largeCoinImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 70),

            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.bringSubviewToFront(backButton)
    }

    @objc private func didTapBack() {
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension MyProfileCoinShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        packages.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyProfileCoinPackageCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! MyProfileCoinPackageCollectionViewCell
        cell.configure(with: packages[indexPath.item])
        return cell
    }
}

extension MyProfileCoinShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPackage(at: indexPath.item)
        confirmPayment(for: indexPath.item)
    }

    private func selectPackage(at index: Int) {
        guard packages.indices.contains(index) else { return }
        let previousIndex = selectedPackageIndex
        selectedPackageIndex = index
        packages = packages.enumerated().map { index, package in
            MyProfileCoinPackage(
                diamonds: package.diamonds,
                price: package.price,
                productIdentifier: package.productIdentifier,
                isSelected: index == selectedPackageIndex
            )
        }

        let changedIndexPaths = Set([
            IndexPath(item: previousIndex, section: 0),
            IndexPath(item: selectedPackageIndex, section: 0)
        ]).filter { packages.indices.contains($0.item) }
        collectionView.reloadItems(at: Array(changedIndexPaths))
    }

    private func confirmPayment(for index: Int) {
        guard packages.indices.contains(index), !isProcessingPayment, presentedViewController == nil else { return }
        let package = packages[index]
        let alertController = UIAlertController(
            title: "Confirm purchase",
            message: "Buy \(package.diamonds) diamonds for \(package.price)?",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(
            UIAlertAction(title: "Pay", style: .default) { [weak self] _ in
                self?.processPayment(for: package)
            }
        )
        present(alertController, animated: true)
    }

    private func processPayment(for package: MyProfileCoinPackage) {
        guard !isProcessingPayment else { return }
        isProcessingPayment = true
        collectionView.isUserInteractionEnabled = false
        showPaymentLoading()

        Task { [weak self] in
            guard let self else { return }
            await self.purchase(package)
        }
    }

    private func purchase(_ package: MyProfileCoinPackage) async {
        do {
            let products = try await Product.products(for: [package.productIdentifier])
            guard let product = products.first else {
                finishPaymentProcessing()
                showPaymentFailure(message: "This product is unavailable.")
                return
            }

            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                let transaction = try verifiedTransaction(from: verificationResult)
                await transaction.finish()
                finishPaymentProcessing()
                GoldCoinStore.addCoins(package.diamonds)
                updateRemainingBalance()
                showPaymentSuccess()
            case .userCancelled:
                finishPaymentProcessing()
            case .pending:
                finishPaymentProcessing()
                showPaymentFailure(message: "Your purchase is pending approval.")
            @unknown default:
                finishPaymentProcessing()
                showPaymentFailure(message: "Purchase failed. Please try again.")
            }
        } catch {
            finishPaymentProcessing()
            showPaymentFailure(message: "Purchase failed. Please try again.")
        }
    }

    private func verifiedTransaction(from result: VerificationResult<Transaction>) throws -> Transaction {
        switch result {
        case .verified(let transaction):
            return transaction
        case .unverified(_, let error):
            throw error
        }
    }

    private func finishPaymentProcessing() {
        isProcessingPayment = false
        collectionView.isUserInteractionEnabled = true
        hidePaymentLoading()
    }

    private func showPaymentLoading() {
        paymentLoadingOverlayView?.removeFromSuperview()

        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        overlayView.alpha = 0
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(red: 0.30, green: 0.64, blue: 0.98, alpha: 1)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(overlayView)
        overlayView.addSubview(cardView)
        cardView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cardView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 96),
            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])

        paymentLoadingOverlayView = overlayView

        UIView.animate(withDuration: 0.18) {
            overlayView.alpha = 1
        }
    }

    private func hidePaymentLoading() {
        guard let overlayView = paymentLoadingOverlayView else { return }
        paymentLoadingOverlayView = nil

        UIView.animate(withDuration: 0.15) {
            overlayView.alpha = 0
        } completion: { _ in
            overlayView.removeFromSuperview()
        }
    }

    private func updateRemainingBalance(animated: Bool = true) {
        let update = {
            self.remainingValueLabel.text = "\(GoldCoinStore.balance)"
        }
        guard animated else {
            update()
            return
        }

        UIView.transition(with: remainingValueLabel, duration: 0.2, options: .transitionCrossDissolve) {
            update()
        }
    }

    private func showPaymentSuccess() {
        let alertController = UIAlertController(title: "Payment successful", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func showPaymentFailure(message: String) {
        let alertController = UIAlertController(title: "Purchase unavailable", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInset: CGFloat = 18
        let spacing: CGFloat = 20
        let width = floor((collectionView.bounds.width - horizontalInset * 2 - spacing * 2) / 3)
        return CGSize(width: width, height: 150)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 18, bottom: 28, right: 18)
    }
}
