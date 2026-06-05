//
//  AuthAccountViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/4.
//

import UIKit

final class AuthAccountViewController: UIViewController {
    private let backgroundView = AuthBackgroundView()
    private let formCardView: AuthFormCardView

    init(mode: AuthFormMode) {
        self.formCardView = AuthFormCardView(mode: mode)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.formCardView = AuthFormCardView(mode: .login)
        super.init(coder: coder)
    }

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
        formCardView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        view.addSubview(formCardView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            formCardView.topAnchor.constraint(equalTo: view.topAnchor),
            formCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        formCardView.backHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        formCardView.createAccountHandler = { [weak self] in
            self?.navigationController?.pushViewController(AuthAccountViewController(mode: .register), animated: true)
        }

        formCardView.registrationCompleteHandler = { [weak self] in
            self?.navigationController?.pushViewController(ProfileSetupViewController(), animated: true)
        }

        formCardView.agreementMissingHandler = { [weak self] in
            self?.showAgreementAlert()
        }
    }

    private func showAgreementAlert() {
        let alertController = UIAlertController(
            title: "Notice",
            message: "Please agree to the User Agreement and Privacy Policy first.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
