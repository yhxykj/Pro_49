//
//  MyProfileEditViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class MyProfileEditViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let titleImageView = UIImageView()
    private let avatarImageView = UIImageView()
    private let avatarSwitchButton = UIButton(type: .custom)
    private let currentNameLabel = UILabel()
    private let nameTextField = UITextField()
    private let reviseButton = UIButton(type: .custom)
    private let toastLabel = UILabel()
    private var selectedAvatarImageName = UserProfileStore.currentProfile.avatarImageName

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
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        view.bringSubviewToFront(backButton)
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
        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .white
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        titleImageView.image = UIImage(named: "MyProfileEditTitle")?.withRenderingMode(.alwaysOriginal)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        let currentProfile = UserProfileStore.currentProfile
        selectedAvatarImageName = currentProfile.avatarImageName

        avatarImageView.image = UserProfileStore.avatarImage(for: currentProfile.avatarImageName)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapAvatarSwitch))
        )

        avatarSwitchButton.setImage(UIImage(named: "MyProfileAvatarSwitchIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        avatarSwitchButton.imageView?.contentMode = .scaleAspectFit
        avatarSwitchButton.contentHorizontalAlignment = .fill
        avatarSwitchButton.contentVerticalAlignment = .fill
        avatarSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        avatarSwitchButton.addTarget(self, action: #selector(didTapAvatarSwitch), for: .touchUpInside)

        currentNameLabel.text = currentProfile.name
        currentNameLabel.textColor = .black
        currentNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        currentNameLabel.translatesAutoresizingMaskIntoConstraints = false

        nameTextField.backgroundColor = .white
        nameTextField.layer.cornerRadius = 27
        nameTextField.layer.borderWidth = 2
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.clipsToBounds = true
        nameTextField.textColor = .black
        nameTextField.font = .systemFont(ofSize: 18, weight: .regular)
        nameTextField.clearButtonMode = .never
        nameTextField.returnKeyType = .done
        nameTextField.delegate = self
        nameTextField.text = currentProfile.name
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [
                .foregroundColor: UIColor(white: 0.78, alpha: 1),
                .font: UIFont.systemFont(ofSize: 18, weight: .regular)
            ]
        )
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        nameTextField.leftViewMode = .always
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        reviseButton.setImage(UIImage(named: "MyProfileReviseButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        reviseButton.imageView?.contentMode = .scaleAspectFit
        reviseButton.contentHorizontalAlignment = .fill
        reviseButton.contentVerticalAlignment = .fill
        reviseButton.translatesAutoresizingMaskIntoConstraints = false
        reviseButton.addTarget(self, action: #selector(didTapRevise), for: .touchUpInside)

        toastLabel.backgroundColor = UIColor(white: 0.08, alpha: 0.86)
        toastLabel.text = "Profile updated"
        toastLabel.textColor = .white
        toastLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 20
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 0
        toastLabel.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(titleImageView)
        view.addSubview(avatarImageView)
        view.addSubview(avatarSwitchButton)
        view.addSubview(currentNameLabel)
        view.addSubview(nameTextField)
        view.addSubview(reviseButton)
        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            titleImageView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 134),
            titleImageView.heightAnchor.constraint(equalToConstant: 26),

            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 122),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            avatarSwitchButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 2),
            avatarSwitchButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 2),
            avatarSwitchButton.widthAnchor.constraint(equalToConstant: 32),
            avatarSwitchButton.heightAnchor.constraint(equalTo: avatarSwitchButton.widthAnchor),

            currentNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            currentNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            currentNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            currentNameLabel.heightAnchor.constraint(equalToConstant: 30),

            nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 34),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 54),

            reviseButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 70),
            reviseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviseButton.widthAnchor.constraint(equalToConstant: 267),
            reviseButton.heightAnchor.constraint(equalToConstant: 64),

            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            toastLabel.widthAnchor.constraint(equalToConstant: 170),
            toastLabel.heightAnchor.constraint(equalToConstant: 40)
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

    @objc private func didTapRevise() {
        view.endEditing(true)
        UserProfileStore.updateCurrentProfile(name: nameTextField.text, avatarImageName: selectedAvatarImageName)
        let profile = UserProfileStore.currentProfile
        currentNameLabel.text = profile.name
        avatarImageView.image = UserProfileStore.avatarImage(for: profile.avatarImageName)
        nameTextField.text = profile.name
        showUpdatedToast()
    }

    @objc private func didTapAvatarSwitch() {
        view.endEditing(true)
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(message: "Photo library is unavailable.")
            return
        }

        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func showUpdatedToast() {
        toastLabel.layer.removeAllAnimations()
        toastLabel.alpha = 0
        UIView.animate(withDuration: 0.18) {
            self.toastLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.22, delay: 1.1, options: [.curveEaseInOut]) {
                self.toastLabel.alpha = 0
            }
        }
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension MyProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MyProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let selectedImage = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        picker.dismiss(animated: true)

        guard let selectedImage else { return }

        do {
            selectedAvatarImageName = try UserProfileStore.saveCurrentAvatarImage(selectedImage)
            avatarImageView.image = selectedImage
            showUpdatedToast()
        } catch {
            showAlert(message: "Failed to save avatar. Please try again.")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
