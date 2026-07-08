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

    private var posts: [SharePost] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
        reloadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadPosts()
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

    private func reloadPosts() {
        SharePostActionStore.resetModerationDataOnceIfNeeded()
        SharePostActionStore.resetFourPostFeedDataOnceIfNeeded()
        posts = SharePostActionStore.visiblePosts(from: SharePostActionStore.defaultPosts)
        tableView.reloadData()
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
            self?.showUserCenter(for: post)
        }
        cell.likeTapHandler = { [weak self] in
            self?.toggleLike(for: post.id)
        }
        cell.moreTapHandler = { [weak self] in
            self?.showPostActions(for: post)
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

    fileprivate func showUserCenter(for post: SharePost) {
        let viewController = UserCenterViewController(post: post)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func toggleLike(for postID: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likeCount = max(0, posts[index].likeCount + (posts[index].isLiked ? 1 : -1))
        SharePostActionStore.setLiked(posts[index].isLiked, for: postID)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }

    private func showPostActions(for post: SharePost) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "Report", style: .destructive) { [weak self] _ in
                self?.reportPost(post.id)
            }
        )
        actionSheet.addAction(
            UIAlertAction(title: "Block", style: .destructive) { [weak self] _ in
                self?.blockAuthor(post.author)
            }
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.maxY,
            width: 1,
            height: 1
        )
        present(actionSheet, animated: true)
    }

    private func reportPost(_ postID: String) {
        SharePostActionStore.report(postID: postID)
        showActionSuccess(
            title: "Report submitted",
            message: "We will review this post within 24 hours."
        )
    }

    private func blockAuthor(_ author: String) {
        SharePostActionStore.block(author: author)
        let removedIndexPaths = posts.enumerated()
            .filter { $0.element.author == author }
            .map { IndexPath(row: $0.offset, section: 0) }

        posts.removeAll { $0.author == author }
        guard !removedIndexPaths.isEmpty else {
            reloadPosts()
            showActionSuccess(
                title: "Blocked",
                message: "Posts from \(author) have been hidden from your feed."
            )
            return
        }
        tableView.deleteRows(at: removedIndexPaths, with: .automatic)
        showActionSuccess(
            title: "Blocked",
            message: "Posts from \(author) have been hidden from your feed."
        )
    }

    private func showActionSuccess(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
