//
//  MyProfileViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileViewController: UIViewController {
    private let contactEmail = "support@lounit.com"
    private let backgroundGradient = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = MyProfileHeaderView()
    private let actionButtonsView = MyProfileActionButtonsView()
    private let settingsPanelView = MyProfileSettingsPanelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
        bindActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        updateProfileHeader()
        updateProfileStats()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.74, green: 0.88, blue: 1.0, alpha: 1).cgColor,
            UIColor(red: 0.86, green: 0.94, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.56, 1]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(headerView)
        contentView.addSubview(actionButtonsView)
        contentView.addSubview(settingsPanelView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            actionButtonsView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            actionButtonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionButtonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actionButtonsView.heightAnchor.constraint(equalToConstant: 68),

            settingsPanelView.topAnchor.constraint(equalTo: actionButtonsView.bottomAnchor, constant: 28),
            settingsPanelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            settingsPanelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            settingsPanelView.heightAnchor.constraint(equalToConstant: 205),
            settingsPanelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28)
        ])
    }

    private func bindActions() {
        headerView.followTapHandler = { [weak self] in
            self?.showRelationship(kind: .follow)
        }
        headerView.fansTapHandler = { [weak self] in
            self?.showRelationship(kind: .fans)
        }
        headerView.likesTapHandler = { [weak self] in
            self?.showLikes()
        }
        actionButtonsView.editTapHandler = { [weak self] in
            self?.showEditProfile()
        }
        actionButtonsView.walletTapHandler = { [weak self] in
            self?.showCoinShop()
        }
        settingsPanelView.actionHandler = { [weak self] action in
            self?.handleSettingAction(action)
        }
    }

    private func updateProfileStats() {
        headerView.configureStats(
            followCount: SharePostActionStore.followedAuthorProfiles.count,
            fansCount: SharePostActionStore.fanProfiles.count,
            likesCount: SharePostActionStore.likedPostCount
        )
    }

    private func updateProfileHeader() {
        headerView.configure(profile: UserProfileStore.currentProfile)
    }

    private func handleSettingAction(_ action: MyProfileSettingAction) {
        switch action {
        case .contact:
            showContactEmail()
        case .privacy:
            showWebPage(.privacy)
        case .community:
            showWebPage(.community)
        case .blacklist:
            showBlacklist()
        case .logout:
            showConfirmation(title: "Log out", message: "Are you sure you want to log out?") { [weak self] in
                self?.logOut()
            }
        case .deleteAccount:
            showConfirmation(title: "Delete account", message: "Are you sure you want to delete this account?") { [weak self] in
                self?.deleteAccount()
            }
        }
    }

    private func showEditProfile() {
        let viewController = MyProfileEditViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showBlacklist() {
        let viewController = MyProfileBlacklistViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showRelationship(kind: MyProfileRelationshipKind) {
        let viewController = MyProfileRelationshipViewController(kind: kind)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showLikes() {
        let viewController = MyProfileLikesViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showWebPage(_ page: MyProfileWebPage) {
        let viewController = MyProfileWebViewController(page: page)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showCoinShop() {
        let viewController = MyProfileCoinShopViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func showContactEmail() {
        let alertController = UIAlertController(
            title: "Contact Us",
            message: "Email: \(contactEmail)",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(title: "Copy Email", style: .default) { [weak self] _ in
                guard let self else { return }
                UIPasteboard.general.string = self.contactEmail
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.showCopySuccess()
                }
            }
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }

    private func showCopySuccess() {
        let alertController = UIAlertController(title: "Copied", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func showConfirmation(title: String, message: String, confirmHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(
            UIAlertAction(title: title, style: .destructive) { _ in
                confirmHandler?()
            }
        )
        present(alertController, animated: true)
    }

    private func logOut() {
        AuthSession.end()
        showLoginFlow()
    }

    private func deleteAccount() {
        AuthLocalDataStore.clearAll()
        showLoginFlow()
    }

    private func showLoginFlow() {
        let navigationController = UINavigationController(rootViewController: ViewController())
        navigationController.setNavigationBarHidden(true, animated: false)
        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
}
