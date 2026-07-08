//
//  MyProfileBlacklistViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileBlacklistViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyStateImageView = UIImageView(
        image: UIImage(named: "HomeEmptyState")?.withRenderingMode(.alwaysOriginal)
    )

    private var users: [MyProfileBlacklistUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadUsers()
        setupBackground()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadUsers()
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

        titleLabel.text = "Blacklist"
        titleLabel.textColor = .white
        titleLabel.font = .myProfilePageTitleFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 104
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            MyProfileBlacklistTableViewCell.self,
            forCellReuseIdentifier: MyProfileBlacklistTableViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false

        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.isHidden = true
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyStateImageView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 180),
            titleLabel.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 6),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 212),
            emptyStateImageView.heightAnchor.constraint(equalTo: emptyStateImageView.widthAnchor)
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

    private func removeUser(at indexPath: IndexPath) {
        guard users.indices.contains(indexPath.row) else { return }
        let user = users.remove(at: indexPath.row)
        SharePostActionStore.unblock(author: user.name)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        emptyStateImageView.isHidden = !users.isEmpty
    }

    private func reloadUsers() {
        users = SharePostActionStore.blockedAuthorProfiles.map {
            MyProfileBlacklistUser(name: $0.name, avatarImageName: $0.avatarImageName)
        }
        tableView.reloadData()
        emptyStateImageView.isHidden = !users.isEmpty
    }
}

extension MyProfileBlacklistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MyProfileBlacklistTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! MyProfileBlacklistTableViewCell
        cell.configure(with: users[indexPath.row])
        cell.removeTapHandler = { [weak self, weak cell] in
            guard
                let self,
                let cell,
                let currentIndexPath = self.tableView.indexPath(for: cell)
            else { return }
            self.removeUser(at: currentIndexPath)
        }
        return cell
    }
}

extension MyProfileBlacklistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let profile = ShareAuthorProfile(name: user.name, avatarImageName: user.avatarImageName)
        let viewController = UserCenterViewController(post: SharePostActionStore.profilePost(for: profile))
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
