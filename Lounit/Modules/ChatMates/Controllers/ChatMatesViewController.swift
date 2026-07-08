//
//  ChatMatesViewController.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import UIKit

final class ChatMatesViewController: UIViewController {
    private let backgroundGradient = CAGradientLayer()
    private let titleImageView = UIImageView()
    private let aiPartnersButton = UIButton(type: .custom)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let emptyStateImageView = UIImageView(
        image: UIImage(named: "HomeEmptyState")?.withRenderingMode(.alwaysOriginal)
    )

    private var conversations: [ChatMateConversation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupView()
        setupLayout()
        reloadConversations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadConversations()
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
        backgroundGradient.locations = [0, 0.48, 0.9]
        backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0)
        backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }

    private func setupView() {
        titleImageView.image = UIImage(named: "ChatMatesTitle")?.withRenderingMode(.alwaysOriginal)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        aiPartnersButton.setImage(UIImage(named: "ChatMatesAIPartnersFilter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        aiPartnersButton.imageView?.contentMode = .scaleAspectFit
        aiPartnersButton.translatesAutoresizingMaskIntoConstraints = false
        aiPartnersButton.addTarget(self, action: #selector(didTapAIPartners), for: .touchUpInside)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 106
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 112, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatMateMessageCell.self, forCellReuseIdentifier: ChatMateMessageCell.reuseIdentifier)

        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.isHidden = true
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {
        view.addSubview(titleImageView)
        view.addSubview(tableView)
        view.addSubview(emptyStateImageView)
        view.addSubview(aiPartnersButton)

        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            titleImageView.widthAnchor.constraint(equalToConstant: 166),
            titleImageView.heightAnchor.constraint(equalToConstant: 31),

            tableView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -12),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 212),
            emptyStateImageView.heightAnchor.constraint(equalTo: emptyStateImageView.widthAnchor),

            aiPartnersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            aiPartnersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -21),
            aiPartnersButton.widthAnchor.constraint(equalToConstant: 167),
            aiPartnersButton.heightAnchor.constraint(equalToConstant: 66)
        ])
    }

    private func reloadConversations() {
        conversations = ChatMessageStore.conversations()
        tableView.reloadData()
        emptyStateImageView.isHidden = !conversations.isEmpty
    }

    @objc private func didTapAIPartners() {
        let viewController = AIChatViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ChatMatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatMateMessageCell.reuseIdentifier,
            for: indexPath
        ) as! ChatMateMessageCell
        cell.configure(with: conversations[indexPath.row])
        return cell
    }
}

extension ChatMatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ChatDetailViewController(conversation: conversations[indexPath.row])
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }
            let conversation = self.conversations[indexPath.row]
            ChatMessageStore.deleteConversation(conversation)
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.emptyStateImageView.isHidden = !self.conversations.isEmpty
            completion(true)
        }
        action.backgroundColor = UIColor(red: 1.0, green: 0.32, blue: 0.33, alpha: 1)
        action.image = UIImage(named: "ChatMatesDeleteIcon")?.withRenderingMode(.alwaysOriginal)

        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
