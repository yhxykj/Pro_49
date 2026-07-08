//
//  NotesViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

final class NotesViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let backButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .custom)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var entries: [NotesEntry] = []

    private var defaultEntries: [NotesEntry] {
        if AuthSession.currentMail == AuthSession.testMail {
            return [
                NotesEntry(
                    date: "June 8, 2026",
                    text: "Test account note: keep today's travel ideas together, compare favorite city routes, and save the moments worth sharing.",
                    imageNames: ["ExploreCityLisbon", "ExploreCityBarcelona", "ExploreCityVancouver"]
                )
            ]
        }

        return [
            NotesEntry(
                date: "October 3, 2026",
                text: "Step into Santorini, see the blue and white cliffside huts, and savor the island's unique seafood.",
                imageNames: ["AuthCityBackground", "ExploreHeroImage", "HomeExplorePromptCard"]
            ),
            NotesEntry(
                date: "October 3, 2026",
                text: "Stroll through Florence, explore Renaissance architecture, and wander through the Tuscan countryside.",
                imageNames: ["ExploreHeroImage", "AuthCityBackground", "HomeExplorePromptCard"]
            )
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
        reloadEntries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadEntries()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }

    private func setupBackground() {
        view.backgroundColor = .white
        backgroundGradient.colors = [
            UIColor(red: 0.27, green: 0.64, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        backgroundGradient.locations = [0, 0.46, 0.86]
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

        titleLabel.text = "Notes"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = makeItalicFont(size: 29, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addButton.setImage(UIImage(named: "NotesAddButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 336
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotesEntryTableViewCell.self, forCellReuseIdentifier: NotesEntryTableViewCell.reuseIdentifier)
    }

    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 130),
            titleLabel.heightAnchor.constraint(equalToConstant: 38),

            addButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeItalicFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = font.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            return font
        }
        return UIFont(descriptor: descriptor, size: size)
    }

    private func reloadEntries() {
        entries = LocalNotesStore.entries() + defaultEntries
        tableView.reloadData()
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapAdd() {
        let viewController = NoteComposerViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NotesEntryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! NotesEntryTableViewCell
        cell.configure(with: entries[indexPath.row])
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {}
