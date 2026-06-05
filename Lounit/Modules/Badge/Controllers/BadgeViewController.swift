//
//  BadgeViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

private struct BadgeLevel {
    let imageName: String
    let value: String
    let title: String
}

private struct BadgeTask {
    let title: String
    let count: String
    let progress: CGFloat
}

final class BadgeViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let profileCardView = UIView()
    private let avatarImageView = UIImageView()
    private let followLabel = UILabel()
    private let currentBadgeImageView = UIImageView()
    private let profileCountLabel = UILabel()
    private let profileProgressView = BadgeProgressView()
    private let badgeGridStackView = UIStackView()
    private let energyTitleLabel = UILabel()
    private let taskStackView = UIStackView()

    private let levels: [BadgeLevel] = [
        BadgeLevel(imageName: "BadgeExplorerOne", value: "10", title: "Energy"),
        BadgeLevel(imageName: "BadgeExplorerTwo", value: "20", title: "Energy"),
        BadgeLevel(imageName: "BadgeExplorerThree", value: "30", title: "Energy"),
        BadgeLevel(imageName: "BadgeExplorerFour", value: "70", title: "Energy"),
        BadgeLevel(imageName: "BadgeExplorerFive", value: "140", title: "Energy"),
        BadgeLevel(imageName: "BadgeExplorerSix", value: "200", title: "Energy")
    ]

    private let tasks: [BadgeTask] = [
        BadgeTask(title: "Publish 10 works", count: "1/10", progress: 0.1),
        BadgeTask(title: "Make 10 notes", count: "1/10", progress: 0.1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.82, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.52, 0.86]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false

        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        titleLabel.text = "Badge"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = makeItalicFont(size: 26, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        profileCardView.backgroundColor = UIColor(red: 0.52, green: 0.79, blue: 0.96, alpha: 1)
        profileCardView.layer.cornerRadius = 50
        profileCardView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.image = UIImage(named: "LoginMascot")?.withRenderingMode(.alwaysOriginal)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        followLabel.text = "Follow"
        followLabel.textColor = .white
        followLabel.font = .systemFont(ofSize: 23, weight: .medium)
        followLabel.translatesAutoresizingMaskIntoConstraints = false

        currentBadgeImageView.image = UIImage(named: "BadgeCurrentExplorer")?.withRenderingMode(.alwaysOriginal)
        currentBadgeImageView.contentMode = .scaleAspectFit
        currentBadgeImageView.translatesAutoresizingMaskIntoConstraints = false

        profileCountLabel.text = "300/200"
        profileCountLabel.textColor = .white
        profileCountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        profileCountLabel.textAlignment = .center
        profileCountLabel.translatesAutoresizingMaskIntoConstraints = false

        profileProgressView.setProgress(0.32)
        profileProgressView.translatesAutoresizingMaskIntoConstraints = false

        badgeGridStackView.axis = .vertical
        badgeGridStackView.spacing = 28
        badgeGridStackView.translatesAutoresizingMaskIntoConstraints = false
        setupBadgeGrid()

        energyTitleLabel.text = "energy"
        energyTitleLabel.textColor = .black
        energyTitleLabel.font = .systemFont(ofSize: 23, weight: .bold)
        energyTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        taskStackView.axis = .vertical
        taskStackView.spacing = 16
        taskStackView.translatesAutoresizingMaskIntoConstraints = false
        setupTasks()
    }

    private func setupBadgeGrid() {
        stride(from: 0, to: levels.count, by: 3).forEach { startIndex in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .top
            rowStackView.distribution = .equalSpacing
            rowStackView.translatesAutoresizingMaskIntoConstraints = false

            levels[startIndex..<min(startIndex + 3, levels.count)].forEach { level in
                let levelView = BadgeLevelView()
                levelView.configure(imageName: level.imageName, value: level.value, title: level.title)
                levelView.translatesAutoresizingMaskIntoConstraints = false
                rowStackView.addArrangedSubview(levelView)
                NSLayoutConstraint.activate([
                    levelView.widthAnchor.constraint(equalToConstant: 104),
                    levelView.heightAnchor.constraint(equalToConstant: 130)
                ])
            }

            badgeGridStackView.addArrangedSubview(rowStackView)
            rowStackView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        }
    }

    private func setupTasks() {
        tasks.forEach { task in
            let taskView = BadgeTaskView()
            taskView.configure(title: task.title, count: task.count, progress: task.progress)
            taskView.translatesAutoresizingMaskIntoConstraints = false
            taskStackView.addArrangedSubview(taskView)
            taskView.heightAnchor.constraint(equalToConstant: 84).isActive = true
        }
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)

        scrollView.addSubview(contentView)
        contentView.addSubview(profileCardView)
        contentView.addSubview(badgeGridStackView)
        contentView.addSubview(energyTitleLabel)
        contentView.addSubview(taskStackView)

        profileCardView.addSubview(avatarImageView)
        profileCardView.addSubview(followLabel)
        profileCardView.addSubview(currentBadgeImageView)
        profileCardView.addSubview(profileCountLabel)
        profileCardView.addSubview(profileProgressView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 140),
            titleLabel.heightAnchor.constraint(equalToConstant: 38),

            profileCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            profileCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            profileCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            profileCardView.heightAnchor.constraint(equalToConstant: 190),

            avatarImageView.topAnchor.constraint(equalTo: profileCardView.topAnchor, constant: 28),
            avatarImageView.leadingAnchor.constraint(equalTo: profileCardView.leadingAnchor, constant: 44),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            followLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 14),
            followLabel.topAnchor.constraint(equalTo: profileCardView.topAnchor, constant: 62),
            followLabel.heightAnchor.constraint(equalToConstant: 32),

            currentBadgeImageView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            currentBadgeImageView.trailingAnchor.constraint(equalTo: profileCardView.trailingAnchor, constant: -38),
            currentBadgeImageView.widthAnchor.constraint(equalToConstant: 78),
            currentBadgeImageView.heightAnchor.constraint(equalTo: currentBadgeImageView.widthAnchor),

            profileCountLabel.topAnchor.constraint(equalTo: followLabel.bottomAnchor, constant: 24),
            profileCountLabel.leadingAnchor.constraint(equalTo: followLabel.leadingAnchor),
            profileCountLabel.widthAnchor.constraint(equalToConstant: 114),
            profileCountLabel.heightAnchor.constraint(equalToConstant: 20),

            profileProgressView.topAnchor.constraint(equalTo: profileCountLabel.bottomAnchor, constant: 6),
            profileProgressView.leadingAnchor.constraint(equalTo: profileCountLabel.leadingAnchor),
            profileProgressView.widthAnchor.constraint(equalToConstant: 114),
            profileProgressView.heightAnchor.constraint(equalToConstant: 13),

            badgeGridStackView.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: 28),
            badgeGridStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            badgeGridStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            energyTitleLabel.topAnchor.constraint(equalTo: badgeGridStackView.bottomAnchor, constant: 28),
            energyTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            energyTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            energyTitleLabel.heightAnchor.constraint(equalToConstant: 32),

            taskStackView.topAnchor.constraint(equalTo: energyTitleLabel.bottomAnchor, constant: 18),
            taskStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            taskStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            taskStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -48)
        ])
    }

    private func makeItalicFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = font.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            return font
        }
        return UIFont(descriptor: descriptor, size: size)
    }

    @objc private func didTapBack() {
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
            return
        }

        tabBarController?.selectedIndex = 0
    }
}
