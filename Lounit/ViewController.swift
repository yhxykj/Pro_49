//
//  ViewController.swift
//  Lounit
//
//  Created by 上包666 on 2026/6/4.
//

import UIKit

final class ViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLoginMethodView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }

    private func setupBackground() {
        backgroundGradient.colors = [
            UIColor(red: 0.25, green: 0.62, blue: 0.96, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.56, 0.76]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupLoginMethodView() {
        let mascotImageView = UIImageView(image: UIImage(named: "LoginMascot"))
        mascotImageView.contentMode = .scaleAspectFit
        mascotImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Choose your login\nmethod"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let createAccountButton = makeLoginButton(title: "Create Account")
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)

        let signInButton = makeLoginButton(title: "Sign in")
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [createAccountButton, signInButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mascotImageView)
        view.addSubview(titleLabel)
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            mascotImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 130),
            mascotImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mascotImageView.widthAnchor.constraint(equalToConstant: 156),
            mascotImageView.heightAnchor.constraint(equalTo: mascotImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: mascotImageView.bottomAnchor, constant: 58),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            buttonStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44)
        ])
    }

    private func makeLoginButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 34
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 68).isActive = true
        return button
    }

    @objc private func didTapCreateAccount() {
        navigationController?.pushViewController(AuthAccountViewController(mode: .register), animated: true)
    }

    @objc private func didTapSignIn() {
        navigationController?.pushViewController(AuthAccountViewController(mode: .login), animated: true)
    }
}
