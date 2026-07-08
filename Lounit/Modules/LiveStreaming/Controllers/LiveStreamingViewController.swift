//
//  LiveStreamingViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class LiveStreamingViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()

    private var rooms: [LiveRoom] = [
        LiveRoom(
            title: "Lisbon alley finds before sunset",
            imageName: "ExploreCityLisbon",
            videoFileName: "live_room_video_01",
            hostName: "Mia",
            hostAvatarImageName: "UserAvatar01",
            category: "Lisbon",
            viewerCountText: "12",
            viewerAvatarImageNames: ["UserAvatar07", "UserAvatar08"]
        ),
        LiveRoom(
            title: "Night walk through the city lights",
            imageName: "ExploreCityBarcelona",
            videoFileName: "live_room_video_02",
            hostName: "Noah",
            hostAvatarImageName: "UserAvatar02",
            category: "Night",
            viewerCountText: "10",
            viewerAvatarImageNames: ["UserAvatar09", "UserAvatar10"]
        ),
        LiveRoom(
            title: "Street food route with local tips",
            imageName: "ExploreCityBusan",
            videoFileName: "live_room_video_03",
            hostName: "Ava",
            hostAvatarImageName: "UserAvatar03",
            category: "Food",
            viewerCountText: "14",
            viewerAvatarImageNames: ["UserAvatar01", "UserAvatar04"]
        ),
        LiveRoom(
            title: "Seaside morning route and cafes",
            imageName: "ExploreCityVancouver",
            videoFileName: "live_room_video_04",
            hostName: "Leo",
            hostAvatarImageName: "UserAvatar04",
            category: "Coast",
            viewerCountText: "11",
            viewerAvatarImageNames: ["UserAvatar02", "UserAvatar05"]
        ),
        LiveRoom(
            title: "Hidden photo spots downtown",
            imageName: "ExploreCityDaNang",
            videoFileName: "live_room_video_05",
            hostName: "Ivy",
            hostAvatarImageName: "UserAvatar05",
            category: "Photo",
            viewerCountText: "9",
            viewerAvatarImageNames: ["UserAvatar03", "UserAvatar06"]
        ),
        LiveRoom(
            title: "Rainy day market and music walk",
            imageName: "ExploreCityChiangMai",
            videoFileName: "live_room_video_06",
            hostName: "Kai",
            hostAvatarImageName: "UserAvatar06",
            category: "Market",
            viewerCountText: "13",
            viewerAvatarImageNames: ["UserAvatar07", "UserAvatar10"]
        )
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 26
        layout.minimumInteritemSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 34, right: 20)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 348)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(LiveRoomCollectionViewCell.self, forCellWithReuseIdentifier: LiveRoomCollectionViewCell.reuseIdentifier)
        collectionView.register(
            LiveStreamingHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LiveStreamingHeaderReusableView.reuseIdentifier
        )
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 348)
        }
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.48, 0.9]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupLayout() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension LiveStreamingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rooms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LiveRoomCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! LiveRoomCollectionViewCell
        cell.configure(with: rooms[indexPath.item])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LiveStreamingHeaderReusableView.reuseIdentifier,
            for: indexPath
        ) as! LiveStreamingHeaderReusableView
        headerView.createTapHandler = { [weak self] in
            let viewController = LiveComposerViewController()
            viewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        return headerView
    }
}

extension LiveStreamingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = rooms[indexPath.item]
        let viewController = LiveRoomViewController(room: room)
        viewController.hidesBottomBarWhenPushed = true
        viewController.blockRoomHandler = { [weak self] blockedRoom in
            self?.removeLiveRoom(blockedRoom)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalPadding: CGFloat = 20 * 2
        let spacing: CGFloat = 14
        let width = (collectionView.bounds.width - horizontalPadding - spacing) / 2
        return CGSize(width: width, height: 219)
    }

    private func removeLiveRoom(_ room: LiveRoom) {
        guard let index = rooms.firstIndex(where: { $0.videoFileName == room.videoFileName }) else { return }
        rooms.remove(at: index)
        collectionView.reloadData()
    }
}
