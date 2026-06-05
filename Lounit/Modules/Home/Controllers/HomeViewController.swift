//
//  HomeViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

struct HomeCity {
    let name: String
}

final class HomeViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let recommendedCities: [HomeCity] = [
        HomeCity(name: "New York, USA"),
        HomeCity(name: "New York, USA"),
        HomeCity(name: "New York, USA"),
        HomeCity(name: "New York, USA"),
        HomeCity(name: "New York, USA"),
        HomeCity(name: "New York, USA")
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 34, right: 24)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 522)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeCityCollectionViewCell.self, forCellWithReuseIdentifier: HomeCityCollectionViewCell.reuseIdentifier)
        collectionView.register(
            HomeHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderReusableView.reuseIdentifier
        )
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 522)
        }
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.46, 0.83]
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recommendedCities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCityCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! HomeCityCollectionViewCell
        cell.configure(with: recommendedCities[indexPath.item])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomeHeaderReusableView.reuseIdentifier,
            for: indexPath
        ) as! HomeHeaderReusableView
        headerView.exploreTapHandler = { [weak self] in
            let viewController = ExploreViewController()
            viewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        headerView.notesTapHandler = { [weak self] in
            let viewController = NotesViewController()
            viewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        headerView.badgeTapHandler = { [weak self] in
            let viewController = BadgeViewController()
            viewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        return headerView
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalPadding: CGFloat = 24 * 2
        let itemSpacing: CGFloat = 16
        let width = (collectionView.bounds.width - horizontalPadding - itemSpacing) / 2
        return CGSize(width: width, height: 138)
    }
}
