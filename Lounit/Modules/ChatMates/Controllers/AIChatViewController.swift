//
//  AIChatViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class AIChatViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let introCardImageView = UIImageView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let typingIndicatorContainerView = UIView()
    private let typingAvatarImageView = UIImageView()
    private let typingBubbleView = UIView()
    private let typingActivityIndicator = UIActivityIndicatorView(style: .medium)
    private let inputContainerView = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private var inputContainerBottomConstraint: NSLayoutConstraint?
    private var typingIndicatorHeightConstraint: NSLayoutConstraint?
    private var replyWorkItem: DispatchWorkItem?
    private var isWaitingForAIReply = false

    private var messages: [AIChatMessage] = AIChatMessageStore.messages()

    deinit {
        replyWorkItem?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            UIColor(red: 0.82, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.45, 0.86]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        backButton.setImage(UIImage(named: "VideoChatBackButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        introCardImageView.image = UIImage(named: "AIChatIntroCard")?.withRenderingMode(.alwaysOriginal)
        introCardImageView.contentMode = .scaleAspectFit
        introCardImageView.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .interactive
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AIChatMessageTableViewCell.self, forCellReuseIdentifier: AIChatMessageTableViewCell.reuseIdentifier)

        typingIndicatorContainerView.alpha = 0
        typingIndicatorContainerView.isHidden = true
        typingIndicatorContainerView.translatesAutoresizingMaskIntoConstraints = false

        typingAvatarImageView.image = UIImage(named: "AIChatAvatar")?.withRenderingMode(.alwaysOriginal)
        typingAvatarImageView.contentMode = .scaleAspectFit
        typingAvatarImageView.translatesAutoresizingMaskIntoConstraints = false

        typingBubbleView.backgroundColor = UIColor(red: 0.88, green: 0.95, blue: 1.0, alpha: 1)
        typingBubbleView.layer.cornerRadius = 5
        typingBubbleView.layer.masksToBounds = true
        typingBubbleView.translatesAutoresizingMaskIntoConstraints = false

        typingActivityIndicator.color = UIColor(red: 0.31, green: 0.64, blue: 0.96, alpha: 1)
        typingActivityIndicator.hidesWhenStopped = true
        typingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false

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
        view.addSubview(introCardImageView)
        view.addSubview(tableView)
        view.addSubview(typingIndicatorContainerView)
        view.addSubview(inputContainerView)
        typingIndicatorContainerView.addSubview(typingAvatarImageView)
        typingIndicatorContainerView.addSubview(typingBubbleView)
        typingBubbleView.addSubview(typingActivityIndicator)
        inputContainerView.addSubview(textField)
        inputContainerView.addSubview(sendButton)

        inputContainerBottomConstraint = inputContainerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -28
        )
        inputContainerBottomConstraint?.isActive = true
        typingIndicatorHeightConstraint = typingIndicatorContainerView.heightAnchor.constraint(equalToConstant: 0)
        typingIndicatorHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            introCardImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            introCardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            introCardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            introCardImageView.heightAnchor.constraint(equalTo: introCardImageView.widthAnchor, multiplier: 588.0 / 1029.0),

            tableView.topAnchor.constraint(equalTo: introCardImageView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: typingIndicatorContainerView.topAnchor, constant: -8),

            typingIndicatorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            typingIndicatorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            typingIndicatorContainerView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -8),

            typingAvatarImageView.leadingAnchor.constraint(equalTo: typingIndicatorContainerView.leadingAnchor, constant: 18),
            typingAvatarImageView.topAnchor.constraint(equalTo: typingIndicatorContainerView.topAnchor, constant: 4),
            typingAvatarImageView.widthAnchor.constraint(equalToConstant: 35),
            typingAvatarImageView.heightAnchor.constraint(equalTo: typingAvatarImageView.widthAnchor),

            typingBubbleView.leadingAnchor.constraint(equalTo: typingAvatarImageView.trailingAnchor, constant: 14),
            typingBubbleView.centerYAnchor.constraint(equalTo: typingAvatarImageView.centerYAnchor),
            typingBubbleView.widthAnchor.constraint(equalToConstant: 54),
            typingBubbleView.heightAnchor.constraint(equalToConstant: 35),

            typingActivityIndicator.centerXAnchor.constraint(equalTo: typingBubbleView.centerXAnchor),
            typingActivityIndicator.centerYAnchor.constraint(equalTo: typingBubbleView.centerYAnchor),

            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
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
        guard !trimmedText.isEmpty, !isWaitingForAIReply else { return }

        appendMessage(AIChatMessage(text: trimmedText, isOutgoing: true))
        textField.text = nil
        scheduleAIReply(for: trimmedText)
    }

    private func appendMessage(_ message: AIChatMessage) {
        messages.append(message)
        AIChatMessageStore.save(messages)

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        scrollToBottom(animated: true)
    }

    private func scheduleAIReply(for question: String) {
        isWaitingForAIReply = true
        sendButton.isEnabled = false
        showTypingIndicator(true)

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.isWaitingForAIReply = false
            self.sendButton.isEnabled = true
            self.showTypingIndicator(false)
            self.appendMessage(AIChatMessage(text: self.replyText(for: question), isOutgoing: false))
        }

        replyWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: workItem)
    }

    private func showTypingIndicator(_ isVisible: Bool) {
        if isVisible {
            typingIndicatorContainerView.isHidden = false
            typingActivityIndicator.startAnimating()
        } else {
            typingActivityIndicator.stopAnimating()
        }

        typingIndicatorHeightConstraint?.constant = isVisible ? 44 : 0

        UIView.animate(withDuration: 0.2) {
            self.typingIndicatorContainerView.alpha = isVisible ? 1 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.typingIndicatorContainerView.isHidden = !isVisible
        }
    }

    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    private func replyText(for question: String) -> String {
        let lowercasedQuestion = question.lowercased()

        if lowercasedQuestion.contains("hello") || lowercasedQuestion.contains("hi") {
            return "Hi! I am here with you. Tell me what you want to explore next."
        }

        if lowercasedQuestion.contains("travel") || lowercasedQuestion.contains("city") {
            return "For this travel question, I would start with the city mood, your available time, and the kind of places you enjoy most."
        }

        if question.hasSuffix("?") {
            return "Here is a quick answer: focus on the goal first, then split it into small steps. If you share more details, I can make the answer more specific."
        }

        return "I understand: \(question). My suggestion is to start with the most important detail, then adjust the plan step by step."
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSend() {
        sendCurrentText()
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

extension AIChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AIChatMessageTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! AIChatMessageTableViewCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

extension AIChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCurrentText()
        return true
    }
}
