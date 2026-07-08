//
//  ChatDetailViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class ChatDetailViewController: UIViewController {
    private let conversation: ChatMateConversation
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let avatarView = ChatMateAvatarBadgeView()
    private let titleLabel = UILabel()
    private let videoButton = UIButton(type: .custom)
    private let menuButton = UIButton(type: .custom)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let inputContainerView = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private var inputContainerBottomConstraint: NSLayoutConstraint?

    private var messages: [ChatMessage] = []

    init(conversation: ChatMateConversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.conversation = ChatMateConversation(
            name: "Beach",
            date: "August 14, 2024",
            message: "Hello.",
            avatarStyle: .person
        )
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        messages = ChatMessageStore.messages(for: conversation)
        setupBackground()
        setupView()
        setupLayout()
        setupKeyboard()
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
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.50, 0.88]
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

        avatarView.configure(
            style: conversation.avatarStyle,
            title: conversation.name,
            imageName: conversation.avatarImageName
        )
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = conversation.avatarStyle == .ai ? "AI Partner" : conversation.name
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        videoButton.setImage(UIImage(named: "ChatDetailVideoButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        videoButton.imageView?.contentMode = .scaleAspectFit
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.addTarget(self, action: #selector(didTapVideo), for: .touchUpInside)

        menuButton.setImage(UIImage(named: "ChatDetailMenuButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 92
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatBubbleTableViewCell.self, forCellReuseIdentifier: ChatBubbleTableViewCell.reuseIdentifier)

        inputContainerView.translatesAutoresizingMaskIntoConstraints = false

        textField.backgroundColor = UIColor(white: 0.78, alpha: 1)
        textField.layer.cornerRadius = 11
        textField.layer.masksToBounds = true
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter what you want to send",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.72),
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always
        textField.returnKeyType = .send
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setImage(UIImage(named: "ChatDetailSendButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(avatarView)
        view.addSubview(titleLabel)
        view.addSubview(videoButton)
        view.addSubview(menuButton)
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(textField)
        inputContainerView.addSubview(sendButton)

        inputContainerBottomConstraint = inputContainerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -28
        )
        inputContainerBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 78),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 22),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),

            menuButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            menuButton.widthAnchor.constraint(equalToConstant: 36),
            menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor),

            videoButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            videoButton.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -18),
            videoButton.widthAnchor.constraint(equalToConstant: 36),
            videoButton.heightAnchor.constraint(equalTo: videoButton.widthAnchor),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -20),

            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputContainerView.heightAnchor.constraint(equalToConstant: 65),

            textField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -14),
            textField.heightAnchor.constraint(equalToConstant: 65),

            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 65),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
    }

    private func setupKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardChange),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func sendCurrentText() {
        let trimmedText = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        guard canStartDirectChat else {
            showMutualFollowRequiredAlert()
            return
        }

        let profile = UserProfileStore.currentProfile
        let message = ChatMessage(
            text: trimmedText,
            isOutgoing: true,
            avatarStyle: .person,
            avatarTitle: profile.name,
            avatarImageName: profile.avatarImageName
        )
        messages.append(message)
        ChatMessageStore.save(messages, for: conversation)
        ChatMessageStore.upsertConversation(conversation, latestMessage: trimmedText)
        textField.text = nil
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    private var canStartDirectChat: Bool {
        !conversation.requiresMutualFollow || conversation.isMutualFollowing
    }

    private func showMutualFollowRequiredAlert() {
        let alertController = UIAlertController(
            title: "Mutual follow required",
            message: "You and \(conversation.name) need to follow each other before starting a chat.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSend() {
        sendCurrentText()
    }

    @objc private func didTapVideo() {
        guard canStartDirectChat else {
            showMutualFollowRequiredAlert()
            return
        }

        let viewController = VideoChatViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func didTapBackground() {
        view.endEditing(true)
    }

    @objc private func handleKeyboardChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY - view.safeAreaInsets.bottom)
        inputContainerBottomConstraint?.constant = overlap > 0 ? -overlap - 10 : -28

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        let curveRawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 7
        let options = UIView.AnimationOptions(rawValue: curveRawValue << 16)

        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatBubbleTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ChatBubbleTableViewCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

extension ChatDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCurrentText()
        return true
    }
}
