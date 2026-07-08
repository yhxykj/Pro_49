//
//  MyProfileWebViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit
import WebKit

enum MyProfileWebPage {
    case privacy
    case userAgreement
    case community

    var title: String {
        switch self {
        case .privacy:
            return "Privacy Policy"
        case .userAgreement:
            return "User Agreement"
        case .community:
            return "Community"
        }
    }

    var url: URL {
        switch self {
        case .privacy:
            return URL(string: "https://docs.google.com/document/d/18Zb7ItbukPu58YrY8eNHVFUDRSXQh0yLG0KKTwBvmjc/edit?usp=sharing")!
        case .userAgreement:
            return URL(string: "https://docs.google.com/document/d/1QN0d8FRXiTmd8LZWi6krG5sO2uDbFt5rOuOPQ5yNDZI/edit?usp=sharing")!
        case .community:
            return URL(string: "https://docs.google.com/document/d/1hoGLK-kfRLv_r0-6pPociOh4RBZOEGS1i0FN1sCEwIc/edit?usp=sharing")!
        }
    }
}

final class MyProfileWebViewController: UIViewController {
    private let page: MyProfileWebPage
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let webView = WKWebView(frame: .zero)

    init(page: MyProfileWebPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        page = .privacy
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
        webView.load(URLRequest(url: page.url))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(titleLabel)
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.82, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.48, 0.90]
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

        titleLabel.text = page.title
        titleLabel.textColor = .white
        titleLabel.font = .myProfilePageTitleFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.scrollView.backgroundColor = .white
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.layer.cornerRadius = 18
        webView.clipsToBounds = true
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 220),
            titleLabel.heightAnchor.constraint(equalToConstant: 36),

            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 18),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    @objc private func didTapBack() {
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
