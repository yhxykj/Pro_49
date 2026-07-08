//
//  UserCenterViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

private struct UserCenterStats {
    let followCount: Int
    let fansCount: Int
    let likesCount: Int
}

final class UserCenterViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UserCenterHeaderView()
    private let backButton = UIButton(type: .custom)
    private let moderationButton = UIButton(type: .custom)
    private let profilePost: SharePost

    private var posts: [SharePost]

    init(post: SharePost) {
        let profilePost = SharePostActionStore.applyingSavedLikeState(to: post)
        self.profilePost = profilePost
        self.posts = SharePostActionStore.visiblePosts(from: [profilePost])
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let profilePost = SharePost(
            id: "dynamic-post-urban-fabric",
            author: "Noah",
            avatarImageName: "UserAvatar03",
            text: "Wandering through the urban fabric, the wind carries the smoke and fire.",
            postImageName: "DynamicPostImage03",
            likeCount: 123
        )
        self.profilePost = profilePost
        self.posts = SharePostActionStore.visiblePosts(from: [profilePost])
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        let stats = Self.stats(for: profilePost)
        headerView.configure(
            name: profilePost.author,
            avatarImageName: profilePost.avatarImageName,
            backgroundImageName: profilePost.postImageName,
            followCount: stats.followCount,
            fansCount: stats.fansCount,
            likesCount: stats.likesCount,
            isFollowing: SharePostActionStore.isFollowing(author: profilePost.author)
        )
        headerView.followStateChangeHandler = { [weak self] isFollowing in
            guard let self else { return }
            SharePostActionStore.setFollowing(isFollowing, for: self.profilePost.author)
        }
        headerView.messageTapHandler = { [weak self] in
            self?.showFriendChat()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderFrame()
        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(moderationButton)
    }

    private func setupView() {
        view.backgroundColor = UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1)

        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        moderationButton.setImage(UIImage(named: "UserCenterModerationIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        moderationButton.imageView?.contentMode = .scaleAspectFit
        moderationButton.translatesAutoresizingMaskIntoConstraints = false
        moderationButton.addTarget(self, action: #selector(didTapModeration), for: .touchUpInside)

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
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(moderationButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            moderationButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            moderationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            moderationButton.widthAnchor.constraint(equalToConstant: 44),
            moderationButton.heightAnchor.constraint(equalTo: moderationButton.widthAnchor)
        ])

        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(moderationButton)
    }

    private func updateHeaderFrame() {
        let headerHeight: CGFloat = 372 + 58 + 92
        let headerWidth = tableView.bounds.width
        guard headerWidth > 0 else { return }

        let headerFrame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)
        guard tableView.tableHeaderView?.frame != headerFrame else { return }
        headerView.frame = headerFrame
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        tableView.tableHeaderView = headerView
    }

    private static func stats(for post: SharePost) -> UserCenterStats {
        let seed = stableSeed(from: post.author + post.id)
        let followCount = 5 + seed % 11
        var fansCount = 8 + (seed / 5) % 16
        var likesCount = 12 + (seed / 11) % 24

        if fansCount == followCount {
            fansCount = min(23, fansCount + 3)
        }
        if likesCount == followCount || likesCount == fansCount {
            likesCount = min(35, likesCount + 5)
        }
        return UserCenterStats(followCount: followCount, fansCount: fansCount, likesCount: likesCount)
    }

    private static func stableSeed(from value: String) -> Int {
        value.unicodeScalars.reduce(0) { partialResult, scalar in
            (partialResult * 31 + Int(scalar.value)) & 0x7fffffff
        }
    }

    private func showUserActions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "Report", style: .destructive) { [weak self] _ in
                self?.reportUser()
            }
        )
        actionSheet.addAction(
            UIAlertAction(title: "Block", style: .destructive) { [weak self] _ in
                self?.blockUser()
            }
        )
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.popoverPresentationController?.sourceView = moderationButton
        actionSheet.popoverPresentationController?.sourceRect = moderationButton.bounds
        present(actionSheet, animated: true)
    }

    private func reportUser() {
        SharePostActionStore.report(author: profilePost.author)
        showActionSuccess(
            title: "Report submitted",
            message: "We will review this user within 24 hours."
        )
    }

    private func blockUser() {
        SharePostActionStore.block(author: profilePost.author)
        showActionSuccess(
            title: "Blocked",
            message: "Posts from \(profilePost.author) have been hidden from your feed."
        ) { [weak self] in
            self?.didTapBack()
        }
    }

    private func showFriendChat() {
        let conversation = ChatMateConversation(
            name: profilePost.author,
            date: "Today",
            message: "Started from \(profilePost.author)'s profile.",
            avatarImageName: profilePost.avatarImageName,
            avatarStyle: .person,
            requiresMutualFollow: true,
            isMutualFollowing: SharePostActionStore.isMutualFollowing(author: profilePost.author)
        )
        let viewController = ChatDetailViewController(conversation: conversation)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func didTapBack() {
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func didTapModeration() {
        showUserActions()
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
        cell.likeTapHandler = { [weak self] in
            self?.toggleLike(for: post.id)
        }
        cell.moreTapHandler = { [weak self] in
            self?.showReportConfirmation(for: post.id)
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

    private func toggleLike(for postID: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likeCount = max(0, posts[index].likeCount + (posts[index].isLiked ? 1 : -1))
        SharePostActionStore.setLiked(posts[index].isLiked, for: postID)
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }

    private func showReportConfirmation(for postID: String) {
        ModerationCardOverlayView.present(
            in: view,
            title: "Report this post?",
            message: "We will review this post within 24 hours.",
            actions: [
                ModerationCardAction(
                    title: "Report post",
                    message: "Submit this post for review.",
                    systemImageName: "flag.fill",
                    tintColor: UIColor(red: 0.94, green: 0.28, blue: 0.22, alpha: 1)
                ) { [weak self] in
                    self?.reportPost(postID)
                }
            ]
        )
    }

    private func reportPost(_ postID: String) {
        SharePostActionStore.report(postID: postID)
        showActionSuccess(
            title: "Report submitted",
            message: "We will review this post within 24 hours."
        )
    }

    private func showActionSuccess(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            }
        )
        present(alertController, animated: true)
    }
}
