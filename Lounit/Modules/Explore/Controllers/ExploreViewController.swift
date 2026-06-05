//
//  ExploreViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

struct ExploreCity {
    let name: String
    let subtitle: String
    let rating: String
}

final class ExploreViewController: UIViewController {
    private let heroImageView = UIImageView()
    private let backButton = UIButton(type: .custom)
    private let heroTitleImageView = UIImageView()
    private let sheetView = UIView()
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)

    private let cities: [ExploreCity] = [
        ExploreCity(name: "New York, USA", subtitle: "The city that never sleeps", rating: "4.8"),
        ExploreCity(name: "New York, USA", subtitle: "The city that never sleeps", rating: "4.8"),
        ExploreCity(name: "New York, USA", subtitle: "The city that never sleeps", rating: "4.8"),
        ExploreCity(name: "New York, USA", subtitle: "The city that never sleeps", rating: "4.8"),
        ExploreCity(name: "New York, USA", subtitle: "The city that never sleeps", rating: "4.8")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupView() {
        view.backgroundColor = .white

        heroImageView.image = UIImage(named: "ExploreHeroImage")?.withRenderingMode(.alwaysOriginal)
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.translatesAutoresizingMaskIntoConstraints = false

        backButton.setImage(UIImage(named: "AuthBackIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        heroTitleImageView.image = UIImage(named: "ExploreHeroTitle")?.withRenderingMode(.alwaysOriginal)
        heroTitleImageView.contentMode = .scaleAspectFit
        heroTitleImageView.translatesAutoresizingMaskIntoConstraints = false

        sheetView.backgroundColor = .white
        sheetView.layer.cornerRadius = 24
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.clipsToBounds = true
        sheetView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "Popular Cities"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 138
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExploreCityTableViewCell.self, forCellReuseIdentifier: ExploreCityTableViewCell.reuseIdentifier)
    }

    private func setupLayout() {
        view.addSubview(heroImageView)
        view.addSubview(backButton)
        view.addSubview(heroTitleImageView)
        view.addSubview(sheetView)

        sheetView.addSubview(titleLabel)
        sheetView.addSubview(tableView)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: view.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 360),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            heroTitleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 138),
            heroTitleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            heroTitleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            heroTitleImageView.heightAnchor.constraint(equalToConstant: 67),

            sheetView.topAnchor.constraint(equalTo: heroTitleImageView.bottomAnchor, constant: 14),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 26),
            titleLabel.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -26),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor)
        ])
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension ExploreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ExploreCityTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ExploreCityTableViewCell
        cell.configure(with: cities[indexPath.row])
        return cell
    }
}

extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = CityDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
