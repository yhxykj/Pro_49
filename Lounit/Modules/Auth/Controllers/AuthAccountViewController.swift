//
//  AuthAccountViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/4.
//

import UIKit

enum AuthSession {
    static let testMail = "lounitlooks@gmail.com"
    private static let testPassword = "123456"
    private static let loginStateKey = "lounit.auth.isLoggedIn"
    private static let currentMailKey = "lounit.auth.currentMail"

    static var isLoggedIn: Bool {
        UserDefaults.standard.bool(forKey: loginStateKey)
    }

    static var currentMail: String? {
        UserDefaults.standard.string(forKey: currentMailKey) ?? (isLoggedIn ? testMail : nil)
    }

    static func canUseTestAccount(mail: String, password: String) -> Bool {
        mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == testMail
            && password == testPassword
    }

    static func start(mail: String = testMail) {
        UserDefaults.standard.set(true, forKey: loginStateKey)
        UserDefaults.standard.set(mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), forKey: currentMailKey)
    }

    static func end() {
        UserDefaults.standard.removeObject(forKey: loginStateKey)
        UserDefaults.standard.removeObject(forKey: currentMailKey)
    }
}

enum AuthLocalDataStore {
    private static let userDefaultsKeyPrefixes = [
        "lounit.",
        "LiveRoomReportedMessages."
    ]
    private static let documentDirectoryNames = [
        "LocalNotes",
        "ProfileAvatars"
    ]

    static func clearAll() {
        let defaults = UserDefaults.standard
        defaults.dictionaryRepresentation().keys
            .filter { key in
                userDefaultsKeyPrefixes.contains { key.hasPrefix($0) }
            }
            .forEach { defaults.removeObject(forKey: $0) }

        clearDocumentDirectories()
        defaults.synchronize()
    }

    private static func clearDocumentDirectories() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        documentDirectoryNames
            .map { documentsURL.appendingPathComponent($0, isDirectory: true) }
            .forEach { url in
                guard FileManager.default.fileExists(atPath: url.path) else { return }
                try? FileManager.default.removeItem(at: url)
            }
    }
}

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
        setupKeyboardDismissal()
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

        formCardView.loginHandler = { [weak self] mail, password in
            self?.handleLogin(mail: mail, password: password)
        }

        formCardView.registrationCompleteHandler = { [weak self] mail, password in
            self?.handleRegistration(mail: mail, password: password)
        }

        formCardView.agreementMissingHandler = { [weak self] in
            self?.showAgreementAlert()
        }

        formCardView.agreementLinksHandler = { [weak self] in
            self?.showAgreementLinks()
        }

        formCardView.validationFailedHandler = { [weak self] message in
            self?.showAuthAlert(message: message)
        }
    }

    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func handleLogin(mail: String, password: String) {
        guard AuthSession.canUseTestAccount(mail: mail, password: password) else {
            showInvalidAccountAlert()
            return
        }

        AuthSession.start(mail: mail)
        enterMainApp()
    }

    private func handleRegistration(mail: String, password: String) {
        guard AuthSession.canUseTestAccount(mail: mail, password: password) else {
            showInvalidAccountAlert()
            return
        }

        AuthSession.start(mail: mail)
        navigationController?.pushViewController(ProfileSetupViewController(), animated: true)
    }

    private func enterMainApp() {
        navigationController?.setViewControllers([MainTabBarController()], animated: true)
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

    private func showInvalidAccountAlert() {
        showAuthAlert(message: "Invalid test account. Please use \(AuthSession.testMail).")
    }

    private func showAuthAlert(message: String) {
        let alertController = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func showAgreementLinks() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(
            UIAlertAction(title: "User Agreement", style: .default) { [weak self] _ in
                self?.showWebPage(.userAgreement)
            }
        )
        alertController.addAction(
            UIAlertAction(title: "Privacy Policy", style: .default) { [weak self] _ in
                self?.showWebPage(.privacy)
            }
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.maxY - 40,
            width: 1,
            height: 1
        )
        present(alertController, animated: true)
    }

    private func showWebPage(_ page: MyProfileWebPage) {
        let viewController = MyProfileWebViewController(page: page)
        if let navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
}
