//
//  ProfileSetupViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ProfileSetupViewController: UIViewController {
    private let backgroundView = AuthBackgroundView()
    private let profileSetupView = ProfileSetupCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupView() {
        view.backgroundColor = .white

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        profileSetupView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        view.addSubview(profileSetupView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            profileSetupView.topAnchor.constraint(equalTo: view.topAnchor),
            profileSetupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileSetupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileSetupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        profileSetupView.backHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        profileSetupView.completeHandler = { [weak self] in
            guard let self else { return }
            UserProfileStore.updateCurrentProfile(name: self.profileSetupView.enteredName)
            self.navigationController?.setViewControllers([MainTabBarController()], animated: true)
        }
    }
}
