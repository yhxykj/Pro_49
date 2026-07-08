//
//  ShareDetailViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ShareDetailViewController: UIViewController {
    private static let localCommentsKeyPrefix = "lounit.share.localComments."

    private var post: SharePost
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let commentInputBar = UIView()
    private let commentTextField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private var inputBarBottomConstraint: NSLayoutConstraint?
    private var reportedCommentIDs: Set<String> {
        get {
            Set(UserDefaults.standard.stringArray(forKey: reportedCommentIDsKey) ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: reportedCommentIDsKey)
        }
    }
    private var reportedCommentIDsKey: String {
        "lounit.share.reportedCommentIDs.\(post.id)"
    }

    private var comments: [ShareComment]

    init(post: SharePost) {
        let post = SharePostActionStore.applyingSavedLikeState(to: post)
        self.post = post
        self.comments = Self.defaultComments(for: post.id) + Self.localComments(for: post.id)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let post = SharePost(
            id: "dynamic-post-old-new-city",
            author: "Esme",
            avatarImageName: "UserAvatar01",
            text: "A fresh perspective on the familiar city: the clash between old alleys and new buildings.",
            postImageName: "DynamicPostImage02",
            likeCount: 123
        )
        self.post = post
        self.comments = Self.defaultComments(for: post.id) + Self.localComments(for: post.id)
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private static func defaultComments(for postID: String) -> [ShareComment] {
        switch postID {
        case "dynamic-post-old-new-city":
            return [
                ShareComment(
                    id: "old-new-city-comment-01",
                    author: "Mira",
                    avatarImageName: "UserAvatar05",
                    text: "The mural makes the old block feel alive next to those new buildings."
                ),
                ShareComment(
                    id: "old-new-city-comment-02",
                    author: "Leo",
                    avatarImageName: "UserAvatar07",
                    text: "Love that contrast between quiet alleys and the bright city wall."
                )
            ]
        case "dynamic-post-city-fun":
            return [
                ShareComment(
                    id: "city-fun-comment-01",
                    author: "Nina",
                    avatarImageName: "UserAvatar08",
                    text: "Rainy streets make wandering feel calmer and more cinematic."
                )
            ]
        default:
            return []
        }
    }

    private static func localComments(for postID: String) -> [ShareComment] {
        let key = localCommentsKeyPrefix + postID
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([ShareComment].self, from: data)) ?? []
    }

    private static func saveLocalComments(_ comments: [ShareComment], for postID: String) {
        let key = localCommentsKeyPrefix + postID
        let localComments = comments.filter(\.isMine)
        guard !localComments.isEmpty else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }

        if let data = try? JSONEncoder().encode(localComments) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
        removeReportedComments()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        view.bringSubviewToFront(backButton)
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.28, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.50, 0.92]
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

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .interactive
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            ShareDetailPostTableViewCell.self,
            forCellReuseIdentifier: ShareDetailPostTableViewCell.reuseIdentifier
        )
        tableView.register(
            ShareCommentTableViewCell.self,
            forCellReuseIdentifier: ShareCommentTableViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false

        commentInputBar.backgroundColor = UIColor(white: 1, alpha: 0.96)
        commentInputBar.layer.cornerRadius = 25
        commentInputBar.clipsToBounds = true
        commentInputBar.translatesAutoresizingMaskIntoConstraints = false

        commentTextField.textColor = UIColor(white: 0.18, alpha: 1)
        commentTextField.font = .systemFont(ofSize: 16, weight: .regular)
        commentTextField.attributedPlaceholder = NSAttributedString(
            string: "Say something",
            attributes: [.foregroundColor: UIColor(white: 0.58, alpha: 1)]
        )
        commentTextField.returnKeyType = .send
        commentTextField.delegate = self
        commentTextField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setImage(UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        sendButton.tintColor = UIColor(red: 0.30, green: 0.64, blue: 0.98, alpha: 1)
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(commentInputBar)
        view.addSubview(backButton)

        commentInputBar.addSubview(commentTextField)
        commentInputBar.addSubview(sendButton)

        let inputBarBottomConstraint = commentInputBar.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -10
        )
        self.inputBarBottomConstraint = inputBarBottomConstraint

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 66),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentInputBar.topAnchor, constant: -10),

            commentInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            commentInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            inputBarBottomConstraint,
            commentInputBar.heightAnchor.constraint(equalToConstant: 50),

            sendButton.trailingAnchor.constraint(equalTo: commentInputBar.trailingAnchor, constant: -14),
            sendButton.centerYAnchor.constraint(equalTo: commentInputBar.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 26),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor),

            commentTextField.leadingAnchor.constraint(equalTo: commentInputBar.leadingAnchor, constant: 18),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            commentTextField.topAnchor.constraint(equalTo: commentInputBar.topAnchor),
            commentTextField.bottomAnchor.constraint(equalTo: commentInputBar.bottomAnchor)
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

    @objc private func didTapSend() {
        sendComment()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY - view.safeAreaInsets.bottom)
        inputBarBottomConstraint?.constant = -(overlap + 10)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        inputBarBottomConstraint?.constant = -10

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func sendComment() {
        let text = commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else {
            commentTextField.resignFirstResponder()
            return
        }

        let profile = UserProfileStore.currentProfile
        comments.append(
            ShareComment(
                id: UUID().uuidString,
                author: profile.name,
                avatarImageName: profile.avatarImageName,
                text: text,
                isMine: true
            )
        )
        commentTextField.text = nil
        persistLocalComments()

        let indexPath = IndexPath(row: comments.count, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    private func removeReportedComments() {
        comments = comments.filter { !reportedCommentIDs.contains($0.id) }
    }

    private func persistLocalComments() {
        Self.saveLocalComments(comments, for: post.id)
    }
}

extension ShareDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 + comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ShareDetailPostTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ShareDetailPostTableViewCell
            cell.configure(with: post)
            cell.avatarTapHandler = { [weak self] in
                self?.showUserCenter()
            }
            cell.likeTapHandler = { [weak self] in
                self?.togglePostLike()
            }
            cell.moreTapHandler = { [weak self] in
                self?.showPostActions()
            }
            return cell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShareCommentTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ShareCommentTableViewCell
        cell.configure(with: comments[indexPath.row - 1])
        cell.avatarTapHandler = { [weak self] in
            self?.showUserCenter()
        }
        let comment = comments[indexPath.row - 1]
        cell.moreTapHandler = { [weak self] in
            if comment.isMine {
                self?.deleteComment(comment.id)
            } else {
                self?.showCommentActions(for: comment.id)
            }
        }
        return cell
    }
}

extension ShareDetailViewController: UITableViewDelegate {}

private extension ShareDetailViewController {
    func showUserCenter() {
        let viewController = UserCenterViewController(post: post)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    func togglePostLike() {
        post.isLiked.toggle()
        post.likeCount = max(0, post.likeCount + (post.isLiked ? 1 : -1))
        SharePostActionStore.setLiked(post.isLiked, for: post.id)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }

    func showPostActions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "Report", style: .destructive) { [weak self] _ in
                self?.reportPost()
            }
        )
        actionSheet.addAction(
            UIAlertAction(title: "Block", style: .destructive) { [weak self] _ in
                self?.blockAuthor()
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

    func showCommentActions(for commentID: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(
            UIAlertAction(title: "Report", style: .destructive) { [weak self] _ in
                self?.reportComment(commentID)
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

    func reportPost() {
        SharePostActionStore.report(postID: post.id)
        showActionSuccess(
            title: "Report submitted",
            message: "We will review this post within 24 hours."
        )
    }

    func blockAuthor() {
        SharePostActionStore.block(author: post.author)
        showActionSuccess(
            title: "Blocked",
            message: "Posts from \(post.author) have been hidden from your feed."
        ) { [weak self] in
            self?.didTapBack()
        }
    }

    func reportComment(_ commentID: String) {
        guard let index = comments.firstIndex(where: { $0.id == commentID }) else { return }
        var ids = reportedCommentIDs
        ids.insert(commentID)
        reportedCommentIDs = ids

        let removedComment = comments.remove(at: index)
        if removedComment.isMine {
            persistLocalComments()
        }
        tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
    }

    func deleteComment(_ commentID: String) {
        guard let index = comments.firstIndex(where: { $0.id == commentID }) else { return }
        comments.remove(at: index)
        persistLocalComments()
        tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
    }

    func showActionSuccess(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            }
        )
        present(alertController, animated: true)
    }
}

extension ShareDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return false
    }
}
