//
//  ShareDetailViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class ShareDetailViewController: UIViewController {
    private let post: SharePost
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let commentInputBar = UIView()
    private let commentTextField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private var inputBarBottomConstraint: NSLayoutConstraint?

    private var comments: [ShareComment] = [
        ShareComment(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "I went on an outdoor trip with my best friend and we pitched a tent for the night."
        ),
        ShareComment(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "I went on an outdoor trip with my best friend and we pitched a tent for the night."
        ),
        ShareComment(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "I went on an outdoor trip with my best friend and we pitched a tent for the night."
        )
    ]

    init(post: SharePost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        post = SharePost(
            author: "Esme",
            avatarImageName: "BadgeCurrentExplorer",
            text: "A fresh perspective on the familiar city: the clash between old alleys and new buildings.",
            postImageName: "AuthCityBackground",
            likeCount: "123"
        )
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

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
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(commentInputBar)

        commentInputBar.addSubview(commentTextField)
        commentInputBar.addSubview(sendButton)

        let inputBarBottomConstraint = commentInputBar.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -10
        )
        self.inputBarBottomConstraint = inputBarBottomConstraint

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
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
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
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

        comments.append(
            ShareComment(
                author: "Esme",
                avatarImageName: "BadgeCurrentExplorer",
                text: text
            )
        )
        commentTextField.text = nil

        let indexPath = IndexPath(row: comments.count, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
        return cell
    }
}

extension ShareDetailViewController: UITableViewDelegate {}

private extension ShareDetailViewController {
    func showUserCenter() {
        let viewController = UserCenterViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ShareDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return false
    }
}
