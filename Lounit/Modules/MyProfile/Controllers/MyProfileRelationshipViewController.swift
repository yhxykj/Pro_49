//
//  MyProfileRelationshipViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

enum MyProfileRelationshipKind {
    case follow
    case fans

    var title: String {
        switch self {
        case .follow:
            return "Follow"
        case .fans:
            return "Fans"
        }
    }

    var defaultFollowState: Bool {
        switch self {
        case .follow:
            return true
        case .fans:
            return false
        }
    }
}

final class MyProfileRelationshipViewController: UIViewController {
    private let kind: MyProfileRelationshipKind
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    private let emptyStateImageView = UIImageView(
        image: UIImage(named: "HomeEmptyState")?.withRenderingMode(.alwaysOriginal)
    )

    private var users: [MyProfileRelationshipUser]

    init(kind: MyProfileRelationshipKind) {
        self.kind = kind
        users = Self.makeUsers(for: kind)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 13
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        kind = .follow
        users = Self.makeUsers(for: .follow)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 13
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
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
        reloadUsers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
        view.bringSubviewToFront(backButton)
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.82, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.46, 0.90]
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

        titleLabel.text = kind.title
        titleLabel.textColor = .white
        titleLabel.font = .myProfilePageTitleFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            MyProfileRelationshipCollectionViewCell.self,
            forCellWithReuseIdentifier: MyProfileRelationshipCollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.isHidden = true
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(emptyStateImageView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 180),
            titleLabel.heightAnchor.constraint(equalToConstant: 36),

            collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 6),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 212),
            emptyStateImageView.heightAnchor.constraint(equalTo: emptyStateImageView.widthAnchor)
        ])

        view.bringSubviewToFront(backButton)
    }

    private func reloadUsers() {
        users = Self.makeUsers(for: kind)
        collectionView.reloadData()
        emptyStateImageView.isHidden = !users.isEmpty
    }

    private static func makeUsers(for kind: MyProfileRelationshipKind) -> [MyProfileRelationshipUser] {
        switch kind {
        case .follow:
            return SharePostActionStore.followedAuthorProfiles.map {
                MyProfileRelationshipUser(
                    name: $0.name,
                    avatarImageName: $0.avatarImageName,
                    isFollowed: true
                )
            }
        case .fans:
            return SharePostActionStore.fanProfiles.map {
                MyProfileRelationshipUser(
                    name: $0.name,
                    avatarImageName: $0.avatarImageName,
                    isFollowed: SharePostActionStore.isFollowing(author: $0.name)
                )
            }
        }
    }

    @objc private func didTapBack() {
        if let navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension MyProfileRelationshipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyProfileRelationshipCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! MyProfileRelationshipCollectionViewCell
        cell.configure(with: users[indexPath.item])
        cell.followTapHandler = { [weak self, weak cell] in
            guard
                let self,
                let cell,
                let currentIndexPath = self.collectionView.indexPath(for: cell)
            else { return }
            let user = self.users[currentIndexPath.item]
            let isNowFollowed = !user.isFollowed
            SharePostActionStore.setFollowing(isNowFollowed, for: user.name)

            if self.kind == .follow, !isNowFollowed {
                self.users.remove(at: currentIndexPath.item)
                self.collectionView.deleteItems(at: [currentIndexPath])
                self.emptyStateImageView.isHidden = !self.users.isEmpty
            } else {
                self.users[currentIndexPath.item].isFollowed = isNowFollowed
                self.collectionView.reloadItems(at: [currentIndexPath])
            }
        }
        return cell
    }
}

extension MyProfileRelationshipViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        let profile = ShareAuthorProfile(name: user.name, avatarImageName: user.avatarImageName)
        let viewController = UserCenterViewController(post: SharePostActionStore.profilePost(for: profile))
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInset: CGFloat = 16
        let spacing: CGFloat = 13
        let width = floor((collectionView.bounds.width - horizontalInset * 2 - spacing) / 2)
        return CGSize(width: width, height: 148)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 16)
    }
}
