//
//  LiveComposerViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import AVFoundation
import UIKit

final class LiveComposerViewController: UIViewController {
    private static let creationCost = 10

    private let backgroundGradient = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let introTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let addPhotosLabel = UILabel()
    private let addPhotoContainerView = UIView()
    private let selectedPhotoImageView = UIImageView()
    private let addPhotoButton = UIButton(type: .custom)
    private let costLabel = UILabel()
    private let releaseButton = UIButton(type: .custom)
    private var selectedPhoto: UIImage?
    private var isCreatingLiveRoom = false
    private weak var coinNoticeOverlayView: UIView?

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
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.78, green: 0.91, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.46, 0.84]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false

        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        titleLabel.text = "Let me introduce it."
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 27, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        introTextView.backgroundColor = UIColor(white: 0.96, alpha: 0.96)
        introTextView.layer.cornerRadius = 14
        introTextView.clipsToBounds = true
        introTextView.textColor = UIColor(white: 0.22, alpha: 1)
        introTextView.font = .systemFont(ofSize: 21, weight: .regular)
        introTextView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        introTextView.textContainer.lineFragmentPadding = 0
        introTextView.delegate = self
        introTextView.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.text = "Say something"
        placeholderLabel.textColor = UIColor(white: 0.6, alpha: 1)
        placeholderLabel.font = .systemFont(ofSize: 21, weight: .regular)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        addPhotosLabel.text = "Add photos"
        addPhotosLabel.textColor = .white
        addPhotosLabel.font = .systemFont(ofSize: 27, weight: .semibold)
        addPhotosLabel.translatesAutoresizingMaskIntoConstraints = false

        addPhotoContainerView.backgroundColor = .white
        addPhotoContainerView.layer.cornerRadius = 16
        addPhotoContainerView.clipsToBounds = true
        addPhotoContainerView.isUserInteractionEnabled = true
        addPhotoContainerView.translatesAutoresizingMaskIntoConstraints = false
        addPhotoContainerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapAddPhoto))
        )

        selectedPhotoImageView.contentMode = .scaleAspectFill
        selectedPhotoImageView.clipsToBounds = true
        selectedPhotoImageView.isHidden = true
        selectedPhotoImageView.translatesAutoresizingMaskIntoConstraints = false

        addPhotoButton.setImage(UIImage(named: "NotePhotoAddButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.imageView?.contentMode = .scaleAspectFit
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)

        costLabel.text = "Creating a live room costs\n10 gold coins."
        costLabel.textColor = UIColor(white: 0.42, alpha: 1)
        costLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        costLabel.textAlignment = .center
        costLabel.numberOfLines = 0
        costLabel.translatesAutoresizingMaskIntoConstraints = false

        releaseButton.setImage(UIImage(named: "NoteReleaseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        releaseButton.imageView?.contentMode = .scaleAspectFit
        releaseButton.translatesAutoresizingMaskIntoConstraints = false
        releaseButton.addTarget(self, action: #selector(didTapRelease), for: .touchUpInside)

        let dismissKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTapGesture.cancelsTouchesInView = false
        dismissKeyboardTapGesture.delegate = self
        view.addGestureRecognizer(dismissKeyboardTapGesture)
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(backButton)

        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(introTextView)
        contentView.addSubview(addPhotosLabel)
        contentView.addSubview(addPhotoContainerView)
        contentView.addSubview(costLabel)
        contentView.addSubview(releaseButton)

        addPhotoContainerView.addSubview(selectedPhotoImageView)
        addPhotoContainerView.addSubview(addPhotoButton)
        introTextView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            titleLabel.heightAnchor.constraint(equalToConstant: 38),

            introTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            introTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            introTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            introTextView.heightAnchor.constraint(equalToConstant: 180),

            placeholderLabel.topAnchor.constraint(equalTo: introTextView.topAnchor, constant: 20),
            placeholderLabel.leadingAnchor.constraint(equalTo: introTextView.leadingAnchor, constant: 18),
            placeholderLabel.trailingAnchor.constraint(equalTo: introTextView.trailingAnchor, constant: -18),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 30),

            addPhotosLabel.topAnchor.constraint(equalTo: introTextView.bottomAnchor, constant: 18),
            addPhotosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            addPhotosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            addPhotosLabel.heightAnchor.constraint(equalToConstant: 38),

            addPhotoContainerView.topAnchor.constraint(equalTo: addPhotosLabel.bottomAnchor, constant: 24),
            addPhotoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            addPhotoContainerView.widthAnchor.constraint(equalToConstant: 132),
            addPhotoContainerView.heightAnchor.constraint(equalToConstant: 132),

            selectedPhotoImageView.topAnchor.constraint(equalTo: addPhotoContainerView.topAnchor),
            selectedPhotoImageView.leadingAnchor.constraint(equalTo: addPhotoContainerView.leadingAnchor),
            selectedPhotoImageView.trailingAnchor.constraint(equalTo: addPhotoContainerView.trailingAnchor),
            selectedPhotoImageView.bottomAnchor.constraint(equalTo: addPhotoContainerView.bottomAnchor),

            addPhotoButton.centerXAnchor.constraint(equalTo: addPhotoContainerView.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: addPhotoContainerView.centerYAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 96),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 96),

            costLabel.topAnchor.constraint(equalTo: addPhotoContainerView.bottomAnchor, constant: 72),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            costLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            releaseButton.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 26),
            releaseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            releaseButton.widthAnchor.constraint(equalToConstant: 267),
            releaseButton.heightAnchor.constraint(equalToConstant: 64),
            releaseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -52)
        ])
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func didTapAddPhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(message: "Photo library is unavailable.")
            return
        }

        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true)
    }

    @objc private func didTapRelease() {
        guard !isCreatingLiveRoom else { return }
        view.endEditing(true)

        let introText = introTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !introText.isEmpty else {
            showAlert(message: "Please say something.")
            return
        }

        guard selectedPhoto != nil else {
            showAlert(message: "Please add a cover photo.")
            return
        }

        guard GoldCoinStore.hasEnoughCoins(Self.creationCost) else {
            showInsufficientCoinsCard(requiredCoins: Self.creationCost, currentCoins: GoldCoinStore.balance)
            return
        }

        isCreatingLiveRoom = true
        requestLivePermissions { [weak self] isGranted in
            DispatchQueue.main.async {
                guard let self else { return }
                guard isGranted else {
                    self.isCreatingLiveRoom = false
                    self.showAlert(message: "Camera and microphone access are required to create a live room.")
                    return
                }
                self.completeLiveRoomCreation()
            }
        }
    }

    private func completeLiveRoomCreation() {
        guard GoldCoinStore.spendCoins(Self.creationCost) else {
            isCreatingLiveRoom = false
            showInsufficientCoinsCard(requiredCoins: Self.creationCost, currentCoins: GoldCoinStore.balance)
            return
        }

        let alertController = UIAlertController(
            title: "Live room created successfully",
            message: "Your live room is under review.",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        present(alertController, animated: true)
    }

    private func requestLivePermissions(completion: @escaping (Bool) -> Void) {
        requestAccessIfNeeded(for: .video) { [weak self] isVideoGranted in
            guard isVideoGranted else {
                completion(false)
                return
            }
            self?.requestAccessIfNeeded(for: .audio, completion: completion)
        }
    }

    private func requestAccessIfNeeded(for mediaType: AVMediaType, completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: completion)
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func showInsufficientCoinsCard(requiredCoins: Int, currentCoins: Int) {
        coinNoticeOverlayView?.removeFromSuperview()
        view.endEditing(true)

        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.28)
        overlayView.alpha = 0
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        let overlayTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCoinNoticeCard))
        overlayTapGesture.delegate = self
        overlayView.addGestureRecognizer(overlayTapGesture)

        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.18
        cardView.layer.shadowRadius = 22
        cardView.layer.shadowOffset = CGSize(width: 0, height: 12)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let coinBackgroundView = UIView()
        coinBackgroundView.backgroundColor = UIColor(red: 1.0, green: 0.94, blue: 0.78, alpha: 1)
        coinBackgroundView.layer.cornerRadius = 36
        coinBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        let coinImageView = UIImageView(image: UIImage(named: "MyProfileShopCoinLarge")?.withRenderingMode(.alwaysOriginal))
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Not enough gold coins"
        titleLabel.textColor = UIColor(white: 0.12, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = "Creating a live room costs \(requiredCoins) gold coins. Your current balance is \(currentCoins)."
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
        shopButton.addTarget(self, action: #selector(didTapCoinShop), for: .touchUpInside)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Not now", for: .normal)
        closeButton.setTitleColor(UIColor(white: 0.38, alpha: 1), for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissCoinNoticeCard), for: .touchUpInside)

        view.addSubview(overlayView)
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

            cardView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 32),
            cardView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -32),

            coinBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 26),
            coinBackgroundView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            coinBackgroundView.widthAnchor.constraint(equalToConstant: 72),
            coinBackgroundView.heightAnchor.constraint(equalTo: coinBackgroundView.widthAnchor),

            coinImageView.centerXAnchor.constraint(equalTo: coinBackgroundView.centerXAnchor),
            coinImageView.centerYAnchor.constraint(equalTo: coinBackgroundView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 46),
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

        coinNoticeOverlayView = overlayView
        cardView.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseOut]) {
            overlayView.alpha = 1
            cardView.transform = .identity
        }
    }

    @objc private func dismissCoinNoticeCard() {
        guard let overlayView = coinNoticeOverlayView else { return }
        coinNoticeOverlayView = nil
        UIView.animate(withDuration: 0.18, animations: {
            overlayView.alpha = 0
        }, completion: { _ in
            overlayView.removeFromSuperview()
        })
    }

    @objc private func didTapCoinShop() {
        dismissCoinNoticeCard()
        let viewController = MyProfileCoinShopViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LiveComposerViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension LiveComposerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        selectedPhoto = image
        selectedPhotoImageView.image = image
        selectedPhotoImageView.isHidden = false
        addPhotoButton.isHidden = true
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension LiveComposerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else { return true }
        if gestureRecognizer.view === coinNoticeOverlayView {
            return touchedView === gestureRecognizer.view
        }
        return !(touchedView is UIControl)
    }
}
