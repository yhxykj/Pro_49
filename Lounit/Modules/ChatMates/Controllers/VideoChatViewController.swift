//
//  VideoChatViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class VideoChatViewController: UIViewController {
    private let backgroundImageView = UIImageView()
    private let backButton = UIButton(type: .custom)
    private let remotePreviewView = UIView()
    private let remoteLoadingIndicator = UIActivityIndicatorView(style: .large)
    private let controlsPanelView = UIView()
    private let controlsStackView = UIStackView()
    private let flipButton = UIButton(type: .custom)
    private let cameraButton = UIButton(type: .custom)
    private let micButton = UIButton(type: .custom)
    private let hangupButton = UIButton(type: .custom)

    private var isMicEnabled = true
    private var isCameraEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        updateToggleButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controlsPanelView.layer.cornerRadius = 34
        remotePreviewView.layer.cornerRadius = 24
    }

    private func setupView() {
        view.backgroundColor = .black

        backgroundImageView.image = UIImage(named: "ExploreHeroImage")?.withRenderingMode(.alwaysOriginal)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        backButton.setImage(UIImage(named: "VideoChatBackButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        remotePreviewView.backgroundColor = .black
        remotePreviewView.clipsToBounds = true
        remotePreviewView.translatesAutoresizingMaskIntoConstraints = false

        remoteLoadingIndicator.color = .white
        remoteLoadingIndicator.hidesWhenStopped = false
        remoteLoadingIndicator.startAnimating()
        remoteLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        [cameraButton, micButton].forEach {
            $0.imageView?.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        cameraButton.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
        micButton.addTarget(self, action: #selector(didTapMic), for: .touchUpInside)

        controlsPanelView.backgroundColor = .white
        controlsPanelView.clipsToBounds = true
        controlsPanelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        controlsPanelView.translatesAutoresizingMaskIntoConstraints = false

        controlsStackView.axis = .horizontal
        controlsStackView.alignment = .center
        controlsStackView.distribution = .equalSpacing
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false

        flipButton.setImage(UIImage(named: "VideoChatFlipButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        flipButton.imageView?.contentMode = .scaleAspectFit
        flipButton.translatesAutoresizingMaskIntoConstraints = false

        hangupButton.setImage(UIImage(named: "VideoChatHangupButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        hangupButton.imageView?.contentMode = .scaleAspectFit
        hangupButton.translatesAutoresizingMaskIntoConstraints = false
        hangupButton.addTarget(self, action: #selector(didTapHangup), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(backgroundImageView)
        view.addSubview(backButton)
        view.addSubview(remotePreviewView)
        remotePreviewView.addSubview(remoteLoadingIndicator)
        view.addSubview(controlsPanelView)

        controlsPanelView.addSubview(controlsStackView)
        controlsStackView.addArrangedSubview(flipButton)
        controlsStackView.addArrangedSubview(cameraButton)
        controlsStackView.addArrangedSubview(micButton)
        controlsStackView.addArrangedSubview(hangupButton)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            remotePreviewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            remotePreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            remotePreviewView.widthAnchor.constraint(equalToConstant: 178),
            remotePreviewView.heightAnchor.constraint(equalTo: remotePreviewView.widthAnchor),

            remoteLoadingIndicator.centerXAnchor.constraint(equalTo: remotePreviewView.centerXAnchor),
            remoteLoadingIndicator.centerYAnchor.constraint(equalTo: remotePreviewView.centerYAnchor),

            controlsPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlsPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlsPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlsPanelView.heightAnchor.constraint(equalToConstant: 176),

            controlsStackView.leadingAnchor.constraint(equalTo: controlsPanelView.leadingAnchor, constant: 62),
            controlsStackView.trailingAnchor.constraint(equalTo: controlsPanelView.trailingAnchor, constant: -62),
            controlsStackView.topAnchor.constraint(equalTo: controlsPanelView.topAnchor, constant: 48),
            controlsStackView.heightAnchor.constraint(equalToConstant: 52),

            flipButton.widthAnchor.constraint(equalToConstant: 52),
            flipButton.heightAnchor.constraint(equalTo: flipButton.widthAnchor),

            cameraButton.widthAnchor.constraint(equalToConstant: 52),
            cameraButton.heightAnchor.constraint(equalTo: cameraButton.widthAnchor),

            micButton.widthAnchor.constraint(equalToConstant: 52),
            micButton.heightAnchor.constraint(equalTo: micButton.widthAnchor),

            hangupButton.widthAnchor.constraint(equalToConstant: 52),
            hangupButton.heightAnchor.constraint(equalTo: hangupButton.widthAnchor)
        ])
    }

    private func updateToggleButtons() {
        let micImageName = isMicEnabled ? "VideoChatMicButton" : "VideoChatMicMutedButton"
        let cameraImageName = isCameraEnabled ? "VideoChatCameraButton" : "VideoChatCameraOffButton"

        let micImage = UIImage(named: micImageName)?.withRenderingMode(.alwaysOriginal)
        let cameraImage = UIImage(named: cameraImageName)?.withRenderingMode(.alwaysOriginal)

        micButton.setImage(micImage, for: .normal)
        cameraButton.setImage(cameraImage, for: .normal)
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapHangup() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapMic() {
        isMicEnabled.toggle()
        updateToggleButtons()
    }

    @objc private func didTapCamera() {
        isCameraEnabled.toggle()
        updateToggleButtons()
    }
}
