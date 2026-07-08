//
//  MyProfileSettingsPanelView.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

enum MyProfileSettingAction {
    case contact
    case privacy
    case community
    case blacklist
    case logout
    case deleteAccount
}

final class MyProfileSettingsPanelView: UIView {
    var actionHandler: ((MyProfileSettingAction) -> Void)?

    private let items: [(imageName: String, action: MyProfileSettingAction)] = [
        ("MyProfileContactIcon", .contact),
        ("MyProfilePrivacyIcon", .privacy),
        ("MyProfileCommunityIcon", .community),
        ("MyProfileBlacklistIcon", .blacklist),
        ("MyProfileLogoutIcon", .logout),
        ("MyProfileDeleteIcon", .deleteAccount)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    private func setupView() {
        backgroundColor = UIColor(red: 0.68, green: 0.83, blue: 0.96, alpha: 0.88)
        layer.cornerRadius = 22
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        let gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.distribution = .fillEqually
        gridStackView.spacing = 26
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gridStackView)

        for rowIndex in 0..<2 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .center
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            gridStackView.addArrangedSubview(rowStackView)

            for columnIndex in 0..<3 {
                let item = items[rowIndex * 3 + columnIndex]
                rowStackView.addArrangedSubview(makeButton(imageName: item.imageName, action: item.action))
            }
        }

        NSLayoutConstraint.activate([
            gridStackView.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            gridStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            gridStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            gridStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        ])
    }

    private func makeButton(imageName: String, action: MyProfileSettingAction) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tag = tag(for: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapItem(_:)), for: .touchUpInside)
        return button
    }

    private func tag(for action: MyProfileSettingAction) -> Int {
        switch action {
        case .contact:
            return 0
        case .privacy:
            return 1
        case .community:
            return 2
        case .blacklist:
            return 3
        case .logout:
            return 4
        case .deleteAccount:
            return 5
        }
    }

    private func action(for tag: Int) -> MyProfileSettingAction {
        items[tag].action
    }

    @objc private func didTapItem(_ sender: UIButton) {
        actionHandler?(action(for: sender.tag))
    }
}
