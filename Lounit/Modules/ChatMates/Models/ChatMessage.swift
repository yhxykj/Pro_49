//
//  ChatMessage.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct ChatMessage: Codable {
    let text: String
    let isOutgoing: Bool
    let avatarStyle: ChatMateAvatarStyle
    let avatarTitle: String
    let avatarImageName: String?

    init(
        text: String,
        isOutgoing: Bool,
        avatarStyle: ChatMateAvatarStyle,
        avatarTitle: String = "Me",
        avatarImageName: String? = nil
    ) {
        self.text = text
        self.isOutgoing = isOutgoing
        self.avatarStyle = avatarStyle
        self.avatarTitle = avatarTitle
        self.avatarImageName = avatarImageName
    }
}

enum ChatMessageStore {
    private struct StoredConversation: Codable {
        let id: String
        let updatedAt: TimeInterval
        let conversation: ChatMateConversation
    }

    private static let keyPrefix = "lounit.chat.messages."
    private static let conversationListKeyPrefix = "lounit.chat.conversations."

    static func messages(for conversation: ChatMateConversation) -> [ChatMessage] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey(for: conversation)),
            let messages = try? JSONDecoder().decode([ChatMessage].self, from: data)
        else {
            return []
        }
        return messages
    }

    static func save(_ messages: [ChatMessage], for conversation: ChatMateConversation) {
        let key = storageKey(for: conversation)
        guard !messages.isEmpty else {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }

        if let data = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func conversations() -> [ChatMateConversation] {
        storedConversations()
            .sorted { $0.updatedAt > $1.updatedAt }
            .map(\.conversation)
    }

    static func upsertConversation(_ conversation: ChatMateConversation, latestMessage: String) {
        let updatedConversation = ChatMateConversation(
            name: conversation.name,
            date: "Today",
            message: latestMessage,
            avatarImageName: conversation.avatarImageName,
            avatarStyle: conversation.avatarStyle,
            requiresMutualFollow: conversation.requiresMutualFollow,
            isMutualFollowing: conversation.isMutualFollowing
        )
        let conversationID = storageIdentifier(for: conversation)
        let storedConversation = StoredConversation(
            id: conversationID,
            updatedAt: Date().timeIntervalSince1970,
            conversation: updatedConversation
        )

        var conversations = storedConversations().filter { $0.id != conversationID }
        conversations.insert(storedConversation, at: 0)
        saveStoredConversations(conversations)
    }

    static func deleteConversation(_ conversation: ChatMateConversation) {
        let conversationID = storageIdentifier(for: conversation)
        let conversations = storedConversations().filter { $0.id != conversationID }
        saveStoredConversations(conversations)
        save([], for: conversation)
    }

    private static func storageKey(for conversation: ChatMateConversation) -> String {
        [
            keyPrefix,
            currentOwnerMail,
            storageIdentifier(for: conversation)
        ].joined(separator: ".")
    }

    private static func storageIdentifier(for conversation: ChatMateConversation) -> String {
        [
            conversation.avatarStyle.rawValue,
            conversation.name,
            conversation.avatarImageName ?? "default"
        ].joined(separator: ".")
    }

    private static var currentOwnerMail: String {
        AuthSession.currentMail ?? "guest"
    }

    private static var conversationListKey: String {
        conversationListKeyPrefix + currentOwnerMail
    }

    private static func storedConversations() -> [StoredConversation] {
        guard
            let data = UserDefaults.standard.data(forKey: conversationListKey),
            let conversations = try? JSONDecoder().decode([StoredConversation].self, from: data)
        else {
            return []
        }
        return conversations
    }

    private static func saveStoredConversations(_ conversations: [StoredConversation]) {
        guard !conversations.isEmpty else {
            UserDefaults.standard.removeObject(forKey: conversationListKey)
            return
        }

        if let data = try? JSONEncoder().encode(conversations) {
            UserDefaults.standard.set(data, forKey: conversationListKey)
        }
    }
}
