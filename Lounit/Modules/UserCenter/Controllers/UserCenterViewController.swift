//
//  UserCenterViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class UserCenterViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UserCenterHeaderView()

    private let posts: [SharePost] = [
        SharePost(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "Wander through the city and find your own fun.",
            postImageName: "AuthCityBackground",
            likeCount: "123"
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderFrame()
    }

    private func setupView() {
        view.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 440
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.register(
            SharePostTableViewCell.self,
            forCellReuseIdentifier: SharePostTableViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false

        headerView.backTapHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func setupLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func updateHeaderFrame() {
        let headerHeight: CGFloat = 372 + 58 + 92
        guard tableView.tableHeaderView?.frame.height != headerHeight else { return }
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight)
        tableView.tableHeaderView = headerView
    }
}

extension UserCenterViewController: UITableViewDataSource {
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
        return cell
    }
}

extension UserCenterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetail(for: posts[indexPath.row])
    }

    private func showDetail(for post: SharePost?) {
        guard let post else { return }
        let viewController = ShareDetailViewController(post: post)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
