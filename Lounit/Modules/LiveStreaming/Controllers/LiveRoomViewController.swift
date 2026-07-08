//
//  LiveRoomViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import AVFoundation
import UIKit

private struct LiveChatMessage {
    let id: String
    let name: String
    let message: String
    let avatarImageName: String
}

final class LiveRoomViewController: UIViewController {
    private let room: LiveRoom
    var blockRoomHandler: ((LiveRoom) -> Void)?
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
    private let moderationBackdropButton = UIButton(type: .custom)
    private let moderationCardView = UIView()
    private let reportActionButton = UIButton(type: .system)
    private let blockActionButton = UIButton(type: .system)
    private let moderationSeparatorView = UIView()
    private let noticeLabel = LiveNoticeLabel()
    private let chatMessagesTableView = UITableView(frame: .zero, style: .plain)
    private let bottomInputContainerView = UIView()
    private let giftButton = UIButton(type: .custom)
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private let giftPanelView = LiveGiftPanelView()
    private let maxStoredChatMessages = 100
    private weak var giftCoinNoticeOverlayView: UIView?
    private var reportedMessageIDs: Set<String> = []
    private var chatMessages: [LiveChatMessage] = []
    private var bottomInputBottomConstraint: NSLayoutConstraint?
    private var giftPanelBottomConstraint: NSLayoutConstraint?
    private var addButtonStoreKey: String {
        "LiveRoomAddButtonSelected.\(room.videoFileName)"
    }
    private var reportedMessagesStoreKey: String {
        "LiveRoomReportedMessages.\(room.videoFileName)"
    }

    init(room: LiveRoom) {
        self.room = room
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.room = LiveRoom(
            title: "Lisbon alley finds before sunset",
            imageName: "ExploreCityLisbon",
            videoFileName: "live_room_video_01",
            hostName: "Mia",
            hostAvatarImageName: "UserAvatar01",
            category: "Lisbon",
            viewerCountText: "12",
            viewerAvatarImageNames: ["UserAvatar07", "UserAvatar08"]
        )
        super.init(coder: coder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoBackground()
        setupView()
        setupLayout()
        loadReportedMessages()
        appendChatMessage(
            id: openingCommentID(for: room),
            name: "Lina",
            message: openingComment(for: room),
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

        fallbackImageView.image = UIImage(named: room.imageName)?.withRenderingMode(.alwaysOriginal)
        fallbackImageView.contentMode = .scaleAspectFill
        fallbackImageView.clipsToBounds = true
        fallbackImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fallbackImageView)

        guard let videoURL = Bundle.main.url(forResource: room.videoFileName, withExtension: "mp4")
            ?? Bundle.main.url(forResource: room.videoFileName, withExtension: "mp4", subdirectory: "Video")
        else {
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

        hostAvatarImageView.image = UIImage(named: room.hostAvatarImageName)?.withRenderingMode(.alwaysOriginal)
        hostAvatarImageView.contentMode = .scaleAspectFill
        hostAvatarImageView.clipsToBounds = true
        hostAvatarImageView.translatesAutoresizingMaskIntoConstraints = false

        hostNameLabel.text = room.hostName
        hostNameLabel.textColor = .white
        hostNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        hostNameLabel.translatesAutoresizingMaskIntoConstraints = false

        addButton.setImage(UIImage(named: "LiveRoomAddButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.setImage(UIImage(named: "select_add")?.withRenderingMode(.alwaysOriginal), for: .selected)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.isSelected = UserDefaults.standard.bool(forKey: addButtonStoreKey)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)

        viewerAvatarOneImageView.image = UIImage(named: viewerAvatarImageName(at: 0))?.withRenderingMode(.alwaysOriginal)
        viewerAvatarOneImageView.contentMode = .scaleAspectFill
        viewerAvatarOneImageView.clipsToBounds = true
        viewerAvatarOneImageView.translatesAutoresizingMaskIntoConstraints = false

        viewerAvatarTwoImageView.image = UIImage(named: viewerAvatarImageName(at: 1))?.withRenderingMode(.alwaysOriginal)
        viewerAvatarTwoImageView.contentMode = .scaleAspectFill
        viewerAvatarTwoImageView.clipsToBounds = true
        viewerAvatarTwoImageView.translatesAutoresizingMaskIntoConstraints = false

        viewerCountLabel.text = room.viewerCountText
        viewerCountLabel.textColor = .white
        viewerCountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        viewerCountLabel.translatesAutoresizingMaskIntoConstraints = false

        menuButton.setImage(UIImage(named: "LiveRoomMenuButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)

        exitButton.setImage(UIImage(named: "LiveRoomExitButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFit
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(didTapExit), for: .touchUpInside)

        moderationBackdropButton.backgroundColor = .clear
        moderationBackdropButton.isHidden = true
        moderationBackdropButton.translatesAutoresizingMaskIntoConstraints = false
        moderationBackdropButton.addTarget(self, action: #selector(didTapModerationBackdrop), for: .touchUpInside)

        moderationCardView.backgroundColor = UIColor(white: 1, alpha: 0.96)
        moderationCardView.layer.cornerRadius = 16
        moderationCardView.layer.shadowColor = UIColor.black.cgColor
        moderationCardView.layer.shadowOpacity = 0.18
        moderationCardView.layer.shadowRadius = 18
        moderationCardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        moderationCardView.alpha = 0
        moderationCardView.isHidden = true
        moderationCardView.translatesAutoresizingMaskIntoConstraints = false

        configureModerationActionButton(
            reportActionButton,
            title: "Report",
            systemImageName: "exclamationmark.triangle.fill",
            color: UIColor(red: 0.95, green: 0.42, blue: 0.20, alpha: 1)
        )
        reportActionButton.addTarget(self, action: #selector(didTapReportAction), for: .touchUpInside)

        configureModerationActionButton(
            blockActionButton,
            title: "Block",
            systemImageName: "person.crop.circle.badge.xmark",
            color: UIColor(red: 0.90, green: 0.20, blue: 0.22, alpha: 1)
        )
        blockActionButton.addTarget(self, action: #selector(didTapBlockAction), for: .touchUpInside)

        moderationSeparatorView.backgroundColor = UIColor(white: 0.88, alpha: 1)
        moderationSeparatorView.translatesAutoresizingMaskIntoConstraints = false

        noticeLabel.text = "please use the civilizedlanguage,release any vulgar, fraudulent,illegal information will be banned account."
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
        giftPanelView.sendGiftHandler = { [weak self] imageName, quantity, totalCost in
            self?.sendGift(imageName: imageName, quantity: quantity, totalCost: totalCost)
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

    private func viewerAvatarImageName(at index: Int) -> String {
        guard room.viewerAvatarImageNames.indices.contains(index) else {
            return room.hostAvatarImageName
        }
        return room.viewerAvatarImageNames[index]
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        view.addSubview(noticeLabel)
        view.addSubview(chatMessagesTableView)
        view.addSubview(bottomInputContainerView)
        view.addSubview(giftPanelView)
        view.addSubview(moderationBackdropButton)
        view.addSubview(moderationCardView)

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
        moderationCardView.addSubview(reportActionButton)
        moderationCardView.addSubview(moderationSeparatorView)
        moderationCardView.addSubview(blockActionButton)

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
            noticeLabel.bottomAnchor.constraint(equalTo: chatMessagesTableView.topAnchor, constant: -12),
            noticeLabel.widthAnchor.constraint(equalToConstant: 282),
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
            giftPanelBottomConstraint,

            moderationBackdropButton.topAnchor.constraint(equalTo: view.topAnchor),
            moderationBackdropButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moderationBackdropButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moderationBackdropButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            moderationCardView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 8),
            moderationCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            moderationCardView.widthAnchor.constraint(equalToConstant: 152),
            moderationCardView.heightAnchor.constraint(equalToConstant: 108),

            reportActionButton.topAnchor.constraint(equalTo: moderationCardView.topAnchor, constant: 4),
            reportActionButton.leadingAnchor.constraint(equalTo: moderationCardView.leadingAnchor),
            reportActionButton.trailingAnchor.constraint(equalTo: moderationCardView.trailingAnchor),
            reportActionButton.heightAnchor.constraint(equalToConstant: 50),

            moderationSeparatorView.topAnchor.constraint(equalTo: reportActionButton.bottomAnchor),
            moderationSeparatorView.leadingAnchor.constraint(equalTo: moderationCardView.leadingAnchor, constant: 16),
            moderationSeparatorView.trailingAnchor.constraint(equalTo: moderationCardView.trailingAnchor, constant: -16),
            moderationSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            blockActionButton.topAnchor.constraint(equalTo: moderationSeparatorView.bottomAnchor),
            blockActionButton.leadingAnchor.constraint(equalTo: moderationCardView.leadingAnchor),
            blockActionButton.trailingAnchor.constraint(equalTo: moderationCardView.trailingAnchor),
            blockActionButton.bottomAnchor.constraint(equalTo: moderationCardView.bottomAnchor, constant: -4)
        ])
    }

    private func configureModerationActionButton(
        _ button: UIButton,
        title: String,
        systemImageName: String,
        color: UIColor
    ) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setImage(UIImage(systemName: systemImageName), for: .normal)
        button.tintColor = color
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc private func replayVideo() {
        player?.seek(to: .zero)
        player?.play()
    }

    @objc private func didTapMenu() {
        showLiveModerationCard()
    }

    @objc private func didTapExit() {
        navigateBack()
    }

    @objc private func didTapAdd() {
        addButton.isSelected = true
        UserDefaults.standard.set(true, forKey: addButtonStoreKey)
    }

    @objc private func didTapModerationBackdrop() {
        hideModerationActions()
    }

    @objc private func didTapReportAction() {
        hideModerationActions()
        showModerationResult(
            title: "Report submitted",
            message: "Thanks for helping keep live rooms safe."
        )
    }

    @objc private func didTapBlockAction() {
        hideModerationActions()
        blockRoomHandler?(room)
        showModerationResult(
            title: "Blocked",
            message: "This live room has been removed from your list."
        )
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
        hideModerationActions(animated: false)
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

        let profile = UserProfileStore.currentProfile
        appendChatMessage(name: profile.name, message: message, avatarImageName: profile.avatarImageName)
        messageTextField.text = nil
        messageTextField.resignFirstResponder()
    }

    private func openingComment(for room: LiveRoom) -> String {
        switch room.videoFileName {
        case "live_room_video_01":
            return "That sunset over Lisbon makes the alley feel so warm and quiet."
        case "live_room_video_02":
            return "The city lights look perfect for a slow night walk."
        case "live_room_video_03":
            return "Save that street food stop, it looks like the best local tip."
        case "live_room_video_04":
            return "This seaside route feels calm, especially with those morning cafes."
        case "live_room_video_05":
            return "That downtown angle would make such a clean photo spot."
        case "live_room_video_06":
            return "Rainy market walks always make the music feel closer."
        default:
            return "This route fits the city so well, I want to save it for later."
        }
    }

    private func openingCommentID(for room: LiveRoom) -> String {
        "\(room.videoFileName).openingComment"
    }

    private func appendChatMessage(
        id: String? = nil,
        name: String,
        message: String,
        avatarImageName: String = "UserAvatar10",
        animated: Bool = true
    ) {
        let messageID = id ?? UUID().uuidString
        guard !reportedMessageIDs.contains(messageID) else { return }

        chatMessages.append(
            LiveChatMessage(id: messageID, name: name, message: message, avatarImageName: avatarImageName)
        )

        if chatMessages.count > maxStoredChatMessages {
            chatMessages.removeFirst(chatMessages.count - maxStoredChatMessages)
        }

        chatMessagesTableView.reloadData()
        chatMessagesTableView.layoutIfNeeded()
        view.layoutIfNeeded()

        scrollChatToBottom(animated: animated)
    }

    private func loadReportedMessages() {
        let storedIDs = UserDefaults.standard.stringArray(forKey: reportedMessagesStoreKey) ?? []
        reportedMessageIDs = Set(storedIDs)
    }

    private func persistReportedMessages() {
        UserDefaults.standard.set(Array(reportedMessageIDs), forKey: reportedMessagesStoreKey)
    }

    private func showReportConfirmation(for messageID: String) {
        view.endEditing(true)
        hideGiftPanel()
        hideModerationActions()

        ModerationCardOverlayView.present(
            in: view,
            title: "Report this message?",
            message: "We will hide this message for you and send it for review.",
            actions: [
                ModerationCardAction(
                    title: "Report message",
                    message: "Remove it from this live chat.",
                    systemImageName: "flag.fill",
                    tintColor: UIColor(red: 0.94, green: 0.28, blue: 0.22, alpha: 1)
                ) { [weak self] in
                    self?.reportChatMessage(withID: messageID)
                }
            ]
        )
    }

    private func reportChatMessage(withID messageID: String) {
        guard let index = chatMessages.firstIndex(where: { $0.id == messageID }) else { return }
        reportedMessageIDs.insert(messageID)
        persistReportedMessages()

        chatMessages.remove(at: index)
        chatMessagesTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    private func scrollChatToBottom(animated: Bool) {
        guard !chatMessages.isEmpty else { return }
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        chatMessagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
        hideGiftPanel()
        hideModerationActions()
    }

    private func showGiftPanel() {
        view.endEditing(true)
        hideModerationActions()
        giftPanelView.refreshBalance()
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

    private func showModerationActions() {
        view.endEditing(true)
        hideGiftPanel()
        moderationBackdropButton.isHidden = false
        moderationCardView.isHidden = false
        moderationCardView.alpha = 0
        moderationCardView.transform = CGAffineTransform(translationX: 0, y: -8).scaledBy(x: 0.96, y: 0.96)
        view.bringSubviewToFront(moderationBackdropButton)
        view.bringSubviewToFront(moderationCardView)

        UIView.animate(withDuration: 0.18) {
            self.moderationCardView.alpha = 1
            self.moderationCardView.transform = .identity
        }
    }

    private func showLiveModerationCard() {
        view.endEditing(true)
        hideGiftPanel()
        hideModerationActions(animated: false)

        ModerationCardOverlayView.present(
            in: view,
            title: "Live room options",
            message: "Choose how you want to handle this live room.",
            actions: [
                ModerationCardAction(
                    title: "Report live room",
                    message: "Send this room to our review team.",
                    systemImageName: "exclamationmark.triangle.fill",
                    tintColor: UIColor(red: 0.95, green: 0.48, blue: 0.18, alpha: 1)
                ) { [weak self] in
                    self?.showModerationResult(
                        title: "Report submitted",
                        message: "Thanks for helping keep live rooms safe."
                    )
                },
                ModerationCardAction(
                    title: "Block host",
                    message: "Remove this live room from your list.",
                    systemImageName: "person.crop.circle.badge.xmark",
                    tintColor: UIColor(red: 0.90, green: 0.18, blue: 0.22, alpha: 1)
                ) { [weak self] in
                    guard let self else { return }
                    blockRoomHandler?(room)
                    showModerationResult(
                        title: "Blocked",
                        message: "This live room has been removed from your list."
                    )
                }
            ],
            cancelTitle: "Not now"
        )
    }

    private func hideModerationActions(animated: Bool = true) {
        guard !moderationCardView.isHidden else { return }

        let changes = {
            self.moderationCardView.alpha = 0
            self.moderationCardView.transform = CGAffineTransform(translationX: 0, y: -8).scaledBy(x: 0.96, y: 0.96)
        }
        let completion: (Bool) -> Void = { _ in
            self.moderationBackdropButton.isHidden = true
            self.moderationCardView.isHidden = true
            self.moderationCardView.transform = .identity
        }

        if animated {
            UIView.animate(withDuration: 0.16, animations: changes, completion: completion)
        } else {
            changes()
            completion(true)
        }
    }

    private func showModerationResult(title: String, message: String) {
        ModerationCardOverlayView.present(
            in: view,
            title: title,
            message: message,
            actions: [
                ModerationCardAction(
                    title: "Done",
                    message: "Return to the live list.",
                    systemImageName: "checkmark.circle.fill",
                    tintColor: UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1)
                ) { [weak self] in
                    self?.navigateBack()
                }
            ],
            cancelTitle: nil
        )
    }

    private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }

    private func sendGift(imageName: String, quantity: Int, totalCost: Int) {
        guard GoldCoinStore.spendCoins(totalCost) else {
            showInsufficientGiftCoins(requiredCoins: totalCost, currentCoins: GoldCoinStore.balance)
            return
        }

        giftPanelView.refreshBalance()
        let profile = UserProfileStore.currentProfile
        appendChatMessage(name: profile.name, message: "Sent a gift x\(quantity)", avatarImageName: profile.avatarImageName)
        hideGiftPanel()
        animateGift(imageName: imageName, quantity: quantity)
    }

    private func showInsufficientGiftCoins(requiredCoins: Int, currentCoins: Int) {
        giftCoinNoticeOverlayView?.removeFromSuperview()
        view.endEditing(true)

        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.34)
        overlayView.alpha = 0
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        let backdropButton = UIButton(type: .custom)
        backdropButton.backgroundColor = .clear
        backdropButton.translatesAutoresizingMaskIntoConstraints = false
        backdropButton.addTarget(self, action: #selector(dismissGiftCoinNoticeCard), for: .touchUpInside)

        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.24
        cardView.layer.shadowRadius = 24
        cardView.layer.shadowOffset = CGSize(width: 0, height: 14)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let coinBackgroundView = UIView()
        coinBackgroundView.backgroundColor = UIColor(red: 1.0, green: 0.93, blue: 0.74, alpha: 1)
        coinBackgroundView.layer.cornerRadius = 38
        coinBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        let coinImageView = UIImageView(image: UIImage(named: "MyProfileShopCoinLarge")?.withRenderingMode(.alwaysOriginal))
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Not enough gold coins"
        titleLabel.textColor = UIColor(white: 0.10, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = "This gift costs \(requiredCoins) gold coins. Your current balance is \(currentCoins)."
        messageLabel.textColor = UIColor(white: 0.36, alpha: 1)
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        let shopButton = UIButton(type: .system)
        shopButton.setTitle("Go to shop", for: .normal)
        shopButton.setTitleColor(.white, for: .normal)
        shopButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        shopButton.backgroundColor = UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1)
        shopButton.layer.cornerRadius = 22
        shopButton.translatesAutoresizingMaskIntoConstraints = false
        shopButton.addTarget(self, action: #selector(didTapGiftCoinShop), for: .touchUpInside)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Not now", for: .normal)
        closeButton.setTitleColor(UIColor(white: 0.40, alpha: 1), for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissGiftCoinNoticeCard), for: .touchUpInside)

        view.addSubview(overlayView)
        overlayView.addSubview(backdropButton)
        overlayView.addSubview(cardView)
        cardView.addSubview(coinBackgroundView)
        coinBackgroundView.addSubview(coinImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(messageLabel)
        cardView.addSubview(shopButton)
        cardView.addSubview(closeButton)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backdropButton.topAnchor.constraint(equalTo: overlayView.topAnchor),
            backdropButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            backdropButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            backdropButton.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),

            cardView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor, constant: -24),
            cardView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 32),
            cardView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -32),

            coinBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 26),
            coinBackgroundView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            coinBackgroundView.widthAnchor.constraint(equalToConstant: 76),
            coinBackgroundView.heightAnchor.constraint(equalTo: coinBackgroundView.widthAnchor),

            coinImageView.centerXAnchor.constraint(equalTo: coinBackgroundView.centerXAnchor),
            coinImageView.centerYAnchor.constraint(equalTo: coinBackgroundView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 48),
            coinImageView.heightAnchor.constraint(equalTo: coinImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: coinBackgroundView.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            shopButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            shopButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            shopButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            shopButton.heightAnchor.constraint(equalToConstant: 44),

            closeButton.topAnchor.constraint(equalTo: shopButton.bottomAnchor, constant: 12),
            closeButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])

        giftCoinNoticeOverlayView = overlayView
        cardView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseOut]) {
            overlayView.alpha = 1
            cardView.transform = .identity
        }
    }

    @objc private func dismissGiftCoinNoticeCard() {
        guard let overlayView = giftCoinNoticeOverlayView else { return }
        giftCoinNoticeOverlayView = nil
        UIView.animate(withDuration: 0.18, animations: {
            overlayView.alpha = 0
        }, completion: { _ in
            overlayView.removeFromSuperview()
        })
    }

    @objc private func didTapGiftCoinShop() {
        dismissGiftCoinNoticeCard()
        hideGiftPanel()
        let viewController = MyProfileCoinShopViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
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
        cell.reportTapHandler = { [weak self] in
            self?.showReportConfirmation(for: message.id)
        }
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
