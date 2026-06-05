//
//  ShareViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ShareViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let titleImageView = UIImageView()
    private let addButton = UIButton(type: .custom)
    private let tableView = UITableView(frame: .zero, style: .plain)

    private let posts: [SharePost] = [
        SharePost(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "Wander through the city and find your own fun.",
            postImageName: "AuthCityBackground",
            likeCount: "123"
        ),
        SharePost(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "Keep moving and explore the four seasons of a city.",
            postImageName: "ExploreHeroImage",
            likeCount: "123"
        )
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
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.28, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.54, 0.94]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        titleImageView.image = UIImage(named: "ShareTitle")?.withRenderingMode(.alwaysOriginal)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        addButton.setImage(UIImage(named: "NotesAddButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 22, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SharePostTableViewCell.self,
            forCellReuseIdentifier: SharePostTableViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(titleImageView)
        view.addSubview(addButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleImageView.widthAnchor.constraint(equalToConstant: 80),
            titleImageView.heightAnchor.constraint(equalToConstant: 31),

            addButton.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),

            tableView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 26),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func didTapAdd() {
        let viewController = ShareComposerViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SharePostTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! SharePostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        cell.commentTapHandler = { [weak self] in
            self?.showDetail(for: post)
        }
        cell.avatarTapHandler = { [weak self] in
            self?.showUserCenter()
        }
        return cell
    }
}

extension ShareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: posts[indexPath.row])
    }

    fileprivate func showDetail(for post: SharePost) {
        let viewController = ShareDetailViewController(post: post)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    fileprivate func showUserCenter() {
        let viewController = UserCenterViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
