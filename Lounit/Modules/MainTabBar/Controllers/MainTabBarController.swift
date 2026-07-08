//
//  MainTabBarController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
    }

    private func setupTabs() {
        viewControllers = MainTabItem.allCases.map { item in
            let rootViewController = item.makeViewController()
            let navigationController = UINavigationController(rootViewController: rootViewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.tabBarItem = UITabBarItem(
                title: nil,
                image: item.image,
                selectedImage: item.selectedImage
            )
            navigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
            navigationController.tabBarItem.accessibilityLabel = item.accessibilityLabel
            return navigationController
        }
        selectedIndex = 0
    }
}

private enum MainTabItem: CaseIterable {
    case explore
    case compass
    case share
    case more
    case profile

    var image: UIImage? {
        UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    }

    var selectedImage: UIImage? {
        UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
    }

    var accessibilityLabel: String {
        switch self {
        case .explore:
            return "Explore"
        case .compass:
            return "Compass"
        case .share:
            return "Share"
        case .more:
            return "More"
        case .profile:
            return "Profile"
        }
    }

    func makeViewController() -> UIViewController {
        switch self {
        case .explore:
            return HomeViewController()
        case .compass:
            return LiveStreamingViewController()
        case .share:
            return ShareViewController()
        case .more:
            return ChatMatesViewController()
        case .profile:
            return MyProfileViewController()
        }
    }

    private var imageName: String {
        switch self {
        case .explore:
            return "MainTabExplore"
        case .compass:
            return "MainTabCompass"
        case .share:
            return "MainTabBadge"
        case .more:
            return "MainTabMore"
        case .profile:
            return "MainTabProfile"
        }
    }

    private var selectedImageName: String {
        switch self {
        case .explore:
            return "MainTabExploreSelected"
        case .compass:
            return "MainTabCompassSelected"
        case .share:
            return "MainTabBadgeSelected"
        case .more:
            return "MainTabMoreSelected"
        case .profile:
            return "MainTabProfileSelected"
        }
    }
}
