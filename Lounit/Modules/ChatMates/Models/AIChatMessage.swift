//
//  AIChatMessage.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

import Foundation

struct AIChatMessage: Codable {
    let text: String
    let isOutgoing: Bool
}

enum AIChatMessageStore {
    private static let storageKey = "lounit.ai.chat.messages"
    private static let defaultMessages = [
        AIChatMessage(text: "Hi Hello", isOutgoing: false)
    ]

    static func messages() -> [AIChatMessage] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let messages = try? JSONDecoder().decode([AIChatMessage].self, from: data),
            !messages.isEmpty
        else {
            return defaultMessages
        }

        return messages
    }

    static func save(_ messages: [AIChatMessage]) {
        guard let data = try? JSONEncoder().encode(messages) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
