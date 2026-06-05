//
//  NoteComposerViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class NoteComposerViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let noteTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let addPhotosLabel = UILabel()
    private let addPhotoContainerView = UIView()
    private let addPhotoButton = UIButton(type: .custom)
    private let costLabel = UILabel()
    private let releaseButton = UIButton(type: .custom)

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

        titleLabel.text = "Take notes"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 27, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        noteTextView.backgroundColor = UIColor(white: 0.96, alpha: 0.96)
        noteTextView.layer.cornerRadius = 14
        noteTextView.clipsToBounds = true
        noteTextView.textColor = UIColor(white: 0.22, alpha: 1)
        noteTextView.font = .systemFont(ofSize: 21, weight: .regular)
        noteTextView.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        noteTextView.textContainer.lineFragmentPadding = 0
        noteTextView.delegate = self
        noteTextView.translatesAutoresizingMaskIntoConstraints = false

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
        addPhotoContainerView.translatesAutoresizingMaskIntoConstraints = false

        addPhotoButton.setImage(UIImage(named: "NotePhotoAddButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.imageView?.contentMode = .scaleAspectFit
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        costLabel.text = "Unlocking dynamic posting costs\n10 gold coins."
        costLabel.textColor = UIColor(white: 0.42, alpha: 1)
        costLabel.font = .systemFont(ofSize: 25, weight: .semibold)
        costLabel.textAlignment = .center
        costLabel.numberOfLines = 0
        costLabel.translatesAutoresizingMaskIntoConstraints = false

        releaseButton.setImage(UIImage(named: "NoteReleaseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        releaseButton.imageView?.contentMode = .scaleAspectFit
        releaseButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(backButton)

        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(noteTextView)
        contentView.addSubview(addPhotosLabel)
        contentView.addSubview(addPhotoContainerView)
        contentView.addSubview(costLabel)
        contentView.addSubview(releaseButton)

        addPhotoContainerView.addSubview(addPhotoButton)
        noteTextView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 158),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            titleLabel.heightAnchor.constraint(equalToConstant: 38),

            noteTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22),
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            noteTextView.heightAnchor.constraint(equalToConstant: 180),

            placeholderLabel.topAnchor.constraint(equalTo: noteTextView.topAnchor, constant: 20),
            placeholderLabel.leadingAnchor.constraint(equalTo: noteTextView.leadingAnchor, constant: 18),
            placeholderLabel.trailingAnchor.constraint(equalTo: noteTextView.trailingAnchor, constant: -18),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 30),

            addPhotosLabel.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 18),
            addPhotosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            addPhotosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
            addPhotosLabel.heightAnchor.constraint(equalToConstant: 38),

            addPhotoContainerView.topAnchor.constraint(equalTo: addPhotosLabel.bottomAnchor, constant: 24),
            addPhotoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            addPhotoContainerView.widthAnchor.constraint(equalToConstant: 132),
            addPhotoContainerView.heightAnchor.constraint(equalToConstant: 132),

            addPhotoButton.centerXAnchor.constraint(equalTo: addPhotoContainerView.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: addPhotoContainerView.centerYAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 96),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 96),

            costLabel.topAnchor.constraint(equalTo: addPhotoContainerView.bottomAnchor, constant: 78),
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
}

extension NoteComposerViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
