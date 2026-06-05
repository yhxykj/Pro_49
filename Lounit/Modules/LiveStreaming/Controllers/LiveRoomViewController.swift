//
//  LiveRoomViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import AVFoundation
import UIKit

private struct LiveChatMessage {
    let name: String
    let message: String
    let avatarImageName: String
}

final class LiveRoomViewController: UIViewController {
    private let fallbackImageView = UIImageView()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    private let topBarView = UIView()
    private let hostAvatarImageView = UIImageView()
    private let hostNameLabel = UILabel()
    private let addButton = UIButton(type: .custom)
    private let viewerAvatarOneImageView = UIImageView()
    private let viewerAvatarTwoImageView = UIImageView()
    private let viewerCountLabel = UILabel()
    private let menuButton = UIButton(type: .custom)
    private let exitButton = UIButton(type: .custom)
    private let noticeLabel = LiveNoticeLabel()
    private let chatMessagesTableView = UITableView(frame: .zero, style: .plain)
    private let bottomInputContainerView = UIView()
    private let giftButton = UIButton(type: .custom)
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private let giftPanelView = LiveGiftPanelView()
    private let maxStoredChatMessages = 100
    private var chatMessages: [LiveChatMessage] = []
    private var bottomInputBottomConstraint: NSLayoutConstraint?
    private var giftPanelBottomConstraint: NSLayoutConstraint?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoBackground()
        setupView()
        setupLayout()
        appendChatMessage(
            name: "please",
            message: "What games are you all playing?\nShare!",
            animated: false
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        player?.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
        [hostAvatarImageView, viewerAvatarOneImageView, viewerAvatarTwoImageView].forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
        }
    }

    private func setupVideoBackground() {
        view.backgroundColor = .black

        fallbackImageView.image = UIImage(named: "AuthCityBackground")?.withRenderingMode(.alwaysOriginal)
        fallbackImageView.contentMode = .scaleAspectFill
        fallbackImageView.clipsToBounds = true
        fallbackImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fallbackImageView)

        guard let videoURL = Bundle.main.url(forResource: "LiveRoomVideo", withExtension: "mp4") else {
            return
        }

        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(playerLayer, at: 0)
        fallbackImageView.isHidden = true
        self.player = player
        self.playerLayer = playerLayer

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(replayVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }

    private func setupView() {
        topBarView.backgroundColor = UIColor(red: 0.30, green: 0.39, blue: 0.44, alpha: 0.48)
        topBarView.layer.cornerRadius = 26
        topBarView.clipsToBounds = true
        topBarView.translatesAutoresizingMaskIntoConstraints = false

        hostAvatarImageView.image = UIImage(named: "LoginMascot")?.withRenderingMode(.alwaysOriginal)
        hostAvatarImageView.contentMode = .scaleAspectFill
        hostAvatarImageView.clipsToBounds = true
        hostAvatarImageView.translatesAutoresizingMaskIntoConstraints = false

        hostNameLabel.text = "release"
        hostNameLabel.textColor = .white
        hostNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        hostNameLabel.translatesAutoresizingMaskIntoConstraints = false

        addButton.setImage(UIImage(named: "LiveRoomAddButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.translatesAutoresizingMaskIntoConstraints = false

        viewerAvatarOneImageView.image = UIImage(named: "AuthCityBackground")?.withRenderingMode(.alwaysOriginal)
        viewerAvatarOneImageView.contentMode = .scaleAspectFill
        viewerAvatarOneImageView.clipsToBounds = true
        viewerAvatarOneImageView.translatesAutoresizingMaskIntoConstraints = false

        viewerAvatarTwoImageView.image = UIImage(named: "LoginMascot")?.withRenderingMode(.alwaysOriginal)
        viewerAvatarTwoImageView.contentMode = .scaleAspectFill
        viewerAvatarTwoImageView.clipsToBounds = true
        viewerAvatarTwoImageView.translatesAutoresizingMaskIntoConstraints = false

        viewerCountLabel.text = "12"
        viewerCountLabel.textColor = .white
        viewerCountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        viewerCountLabel.translatesAutoresizingMaskIntoConstraints = false

        menuButton.setImage(UIImage(named: "LiveRoomMenuButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.translatesAutoresizingMaskIntoConstraints = false

        exitButton.setImage(UIImage(named: "LiveRoomExitButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFit
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(didTapExit), for: .touchUpInside)

        noticeLabel.text = "please use the civilizedlanguage,\nrelease any vulgar, fraudulent,illegal\ninformation will be banned account."
        noticeLabel.textColor = .white
        noticeLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        noticeLabel.numberOfLines = 0
        noticeLabel.backgroundColor = UIColor(white: 0.25, alpha: 0.24)
        noticeLabel.layer.cornerRadius = 6
        noticeLabel.clipsToBounds = true
        noticeLabel.translatesAutoresizingMaskIntoConstraints = false

        chatMessagesTableView.backgroundColor = .clear
        chatMessagesTableView.separatorStyle = .none
        chatMessagesTableView.showsVerticalScrollIndicator = false
        chatMessagesTableView.contentInsetAdjustmentBehavior = .never
        chatMessagesTableView.rowHeight = UITableView.automaticDimension
        chatMessagesTableView.estimatedRowHeight = 72
        chatMessagesTableView.dataSource = self
        chatMessagesTableView.register(
            LiveChatMessageCell.self,
            forCellReuseIdentifier: LiveChatMessageCell.reuseIdentifier
        )
        chatMessagesTableView.translatesAutoresizingMaskIntoConstraints = false

        bottomInputContainerView.backgroundColor = .clear
        bottomInputContainerView.translatesAutoresizingMaskIntoConstraints = false

        giftButton.setImage(UIImage(named: "LiveRoomGiftButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        giftButton.imageView?.contentMode = .scaleAspectFit
        giftButton.translatesAutoresizingMaskIntoConstraints = false
        giftButton.addTarget(self, action: #selector(didTapGift), for: .touchUpInside)

        messageTextField.backgroundColor = UIColor(white: 0.94, alpha: 0.94)
        messageTextField.layer.cornerRadius = 14
        messageTextField.clipsToBounds = true
        messageTextField.textColor = UIColor(white: 0.2, alpha: 1)
        messageTextField.font = .systemFont(ofSize: 16, weight: .regular)
        messageTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter what you want to send",
            attributes: [.foregroundColor: UIColor(white: 0.58, alpha: 1)]
        )
        messageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 1))
        messageTextField.leftViewMode = .always
        messageTextField.returnKeyType = .send
        messageTextField.delegate = self
        messageTextField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setImage(UIImage(named: "LiveRoomSendButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)

        giftPanelView.isHidden = true
        giftPanelView.sendGiftHandler = { [weak self] imageName, quantity in
            self?.sendGift(imageName: imageName, quantity: quantity)
        }

        let dismissKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGesture.cancelsTouchesInView = false
        dismissKeyboardTapGesture.delegate = self
        view.addGestureRecognizer(dismissKeyboardTapGesture)

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
        view.addSubview(topBarView)
        view.addSubview(noticeLabel)
        view.addSubview(chatMessagesTableView)
        view.addSubview(bottomInputContainerView)
        view.addSubview(giftPanelView)

        topBarView.addSubview(hostAvatarImageView)
        topBarView.addSubview(hostNameLabel)
        topBarView.addSubview(addButton)
        topBarView.addSubview(viewerAvatarOneImageView)
        topBarView.addSubview(viewerAvatarTwoImageView)
        topBarView.addSubview(viewerCountLabel)
        topBarView.addSubview(menuButton)
        topBarView.addSubview(exitButton)

        bottomInputContainerView.addSubview(giftButton)
        bottomInputContainerView.addSubview(messageTextField)
        bottomInputContainerView.addSubview(sendButton)

        let bottomInputBottomConstraint = bottomInputContainerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -18
        )
        self.bottomInputBottomConstraint = bottomInputBottomConstraint
        let giftPanelBottomConstraint = giftPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 392)
        self.giftPanelBottomConstraint = giftPanelBottomConstraint

        NSLayoutConstraint.activate([
            fallbackImageView.topAnchor.constraint(equalTo: view.topAnchor),
            fallbackImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fallbackImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fallbackImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topBarView.heightAnchor.constraint(equalToConstant: 104),

            hostAvatarImageView.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: 14),
            hostAvatarImageView.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 18),
            hostAvatarImageView.widthAnchor.constraint(equalToConstant: 32),
            hostAvatarImageView.heightAnchor.constraint(equalTo: hostAvatarImageView.widthAnchor),

            hostNameLabel.leadingAnchor.constraint(equalTo: hostAvatarImageView.trailingAnchor, constant: 8),
            hostNameLabel.centerYAnchor.constraint(equalTo: hostAvatarImageView.centerYAnchor),
            hostNameLabel.heightAnchor.constraint(equalToConstant: 24),

            addButton.leadingAnchor.constraint(equalTo: hostNameLabel.trailingAnchor, constant: 6),
            addButton.centerYAnchor.constraint(equalTo: hostAvatarImageView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),

            viewerAvatarOneImageView.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 24),
            viewerAvatarOneImageView.bottomAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: -16),
            viewerAvatarOneImageView.widthAnchor.constraint(equalToConstant: 25),
            viewerAvatarOneImageView.heightAnchor.constraint(equalTo: viewerAvatarOneImageView.widthAnchor),

            viewerAvatarTwoImageView.leadingAnchor.constraint(equalTo: viewerAvatarOneImageView.trailingAnchor, constant: -7),
            viewerAvatarTwoImageView.centerYAnchor.constraint(equalTo: viewerAvatarOneImageView.centerYAnchor),
            viewerAvatarTwoImageView.widthAnchor.constraint(equalTo: viewerAvatarOneImageView.widthAnchor),
            viewerAvatarTwoImageView.heightAnchor.constraint(equalTo: viewerAvatarOneImageView.heightAnchor),

            viewerCountLabel.leadingAnchor.constraint(equalTo: viewerAvatarTwoImageView.trailingAnchor, constant: 12),
            viewerCountLabel.centerYAnchor.constraint(equalTo: viewerAvatarOneImageView.centerYAnchor),
            viewerCountLabel.heightAnchor.constraint(equalToConstant: 26),

            menuButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: exitButton.leadingAnchor, constant: -12),
            menuButton.widthAnchor.constraint(equalToConstant: 58),
            menuButton.heightAnchor.constraint(equalToConstant: 62),

            exitButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalToConstant: 58),
            exitButton.heightAnchor.constraint(equalToConstant: 62),

            noticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            noticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            noticeLabel.bottomAnchor.constraint(equalTo: chatMessagesTableView.topAnchor, constant: -12),
            noticeLabel.heightAnchor.constraint(equalToConstant: 74),

            chatMessagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            chatMessagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -68),
            chatMessagesTableView.bottomAnchor.constraint(equalTo: bottomInputContainerView.topAnchor, constant: -10),
            chatMessagesTableView.heightAnchor.constraint(equalToConstant: 200),

            bottomInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            bottomInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            bottomInputBottomConstraint,
            bottomInputContainerView.heightAnchor.constraint(equalToConstant: 58),

            giftButton.leadingAnchor.constraint(equalTo: bottomInputContainerView.leadingAnchor),
            giftButton.centerYAnchor.constraint(equalTo: bottomInputContainerView.centerYAnchor),
            giftButton.widthAnchor.constraint(equalToConstant: 52),
            giftButton.heightAnchor.constraint(equalTo: giftButton.widthAnchor),

            sendButton.trailingAnchor.constraint(equalTo: bottomInputContainerView.trailingAnchor),
            sendButton.centerYAnchor.constraint(equalTo: bottomInputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 52),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor),

            messageTextField.leadingAnchor.constraint(equalTo: giftButton.trailingAnchor, constant: 12),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            messageTextField.centerYAnchor.constraint(equalTo: bottomInputContainerView.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 52),

            giftPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            giftPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            giftPanelView.heightAnchor.constraint(equalToConstant: 392),
            giftPanelBottomConstraint
        ])
    }

    @objc private func replayVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    @objc private func didTapExit() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapSend() {
        sendCurrentMessage()
    }

    @objc private func didTapGift() {
        if giftPanelView.isHidden {
            showGiftPanel()
        } else {
            hideGiftPanel()
        }
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        hideGiftPanel(animated: false)
        guard
            let frameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY - view.safeAreaInsets.bottom)
        bottomInputBottomConstraint?.constant = -(overlap + 12)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        bottomInputBottomConstraint?.constant = -18

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    private func sendCurrentMessage() {
        let message = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !message.isEmpty else {
            messageTextField.resignFirstResponder()
            return
        }

        appendChatMessage(name: "me", message: message)
        messageTextField.text = nil
        messageTextField.resignFirstResponder()
    }

    private func appendChatMessage(
        name: String,
        message: String,
        avatarImageName: String = "LoginMascot",
        animated: Bool = true
    ) {
        chatMessages.append(
            LiveChatMessage(name: name, message: message, avatarImageName: avatarImageName)
        )

        if chatMessages.count > maxStoredChatMessages {
            chatMessages.removeFirst(chatMessages.count - maxStoredChatMessages)
        }

        chatMessagesTableView.reloadData()
        chatMessagesTableView.layoutIfNeeded()
        view.layoutIfNeeded()

        scrollChatToBottom(animated: animated)
    }

    private func scrollChatToBottom(animated: Bool) {
        guard !chatMessages.isEmpty else { return }
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        chatMessagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
        hideGiftPanel()
    }

    private func showGiftPanel() {
        view.endEditing(true)
        bottomInputContainerView.isHidden = true
        giftPanelView.isHidden = false
        giftPanelBottomConstraint?.constant = 0

        UIView.animate(withDuration: 0.24) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideGiftPanel(animated: Bool = true) {
        guard !giftPanelView.isHidden else { return }
        giftPanelBottomConstraint?.constant = 392

        let changes = {
            self.view.layoutIfNeeded()
        }

        let completion: (Bool) -> Void = { _ in
            self.giftPanelView.isHidden = true
            self.bottomInputContainerView.isHidden = false
        }

        if animated {
            UIView.animate(withDuration: 0.22, animations: changes, completion: completion)
        } else {
            changes()
            completion(true)
        }
    }

    private func sendGift(imageName: String, quantity: Int) {
        appendChatMessage(name: "me", message: "Sent a gift x\(quantity)")
        hideGiftPanel()
        animateGift(imageName: imageName, quantity: quantity)
    }

    private func animateGift(imageName: String, quantity: Int) {
        let animationView = UIView()
        animationView.backgroundColor = UIColor(white: 0.05, alpha: 0.42)
        animationView.layer.cornerRadius = 54
        animationView.alpha = 0
        animationView.translatesAutoresizingMaskIntoConstraints = false

        let giftImageView = UIImageView(image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal))
        giftImageView.contentMode = .scaleAspectFit
        giftImageView.translatesAutoresizingMaskIntoConstraints = false

        let quantityLabel = UILabel()
        quantityLabel.text = "x\(quantity)"
        quantityLabel.textColor = .white
        quantityLabel.font = .systemFont(ofSize: 22, weight: .bold)
        quantityLabel.textAlignment = .center
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(animationView)
        animationView.addSubview(giftImageView)
        animationView.addSubview(quantityLabel)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            animationView.widthAnchor.constraint(equalToConstant: 132),
            animationView.heightAnchor.constraint(equalToConstant: 132),

            giftImageView.topAnchor.constraint(equalTo: animationView.topAnchor, constant: 16),
            giftImageView.centerXAnchor.constraint(equalTo: animationView.centerXAnchor),
            giftImageView.widthAnchor.constraint(equalToConstant: 78),
            giftImageView.heightAnchor.constraint(equalTo: giftImageView.widthAnchor),

            quantityLabel.topAnchor.constraint(equalTo: giftImageView.bottomAnchor, constant: 4),
            quantityLabel.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: 10),
            quantityLabel.trailingAnchor.constraint(equalTo: animationView.trailingAnchor, constant: -10),
            quantityLabel.heightAnchor.constraint(equalToConstant: 28)
        ])

        animationView.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)

        UIView.animateKeyframes(
            withDuration: 1.25,
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.24) {
                    animationView.alpha = 1
                    animationView.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
                }

                UIView.addKeyframe(withRelativeStartTime: 0.24, relativeDuration: 0.18) {
                    animationView.transform = .identity
                }

                UIView.addKeyframe(withRelativeStartTime: 0.42, relativeDuration: 0.34) {
                    animationView.transform = CGAffineTransform(translationX: 0, y: -72)
                }

                UIView.addKeyframe(withRelativeStartTime: 0.76, relativeDuration: 0.24) {
                    animationView.alpha = 0
                    animationView.transform = CGAffineTransform(translationX: 0, y: -112).scaledBy(x: 0.82, y: 0.82)
                }
            },
            completion: { _ in
                animationView.removeFromSuperview()
            }
        )
    }
}

extension LiveRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendCurrentMessage()
        return false
    }
}

extension LiveRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatMessages.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LiveChatMessageCell.reuseIdentifier,
            for: indexPath
        ) as? LiveChatMessageCell else {
            return UITableViewCell()
        }

        let message = chatMessages[indexPath.row]
        cell.configure(
            name: message.name,
            message: message.message,
            avatarImageName: message.avatarImageName
        )
        return cell
    }
}

extension LiveRoomViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else { return true }
        if touchedView is UIControl {
            return false
        }
        return !touchedView.isDescendant(of: bottomInputContainerView)
            && !touchedView.isDescendant(of: giftPanelView)
    }
}
