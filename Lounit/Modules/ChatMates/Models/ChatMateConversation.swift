//
//  ChatMateConversation.swift
//  Lounit
//
//  Created by Codex on 2026/6/8.
//

struct ChatMateConversation: Codable {
    let name: String
    let date: String
    let message: String
    let avatarImageName: String?
    let avatarStyle: ChatMateAvatarStyle
    let requiresMutualFollow: Bool
    let isMutualFollowing: Bool

    init(
        name: String,
        date: String,
        message: String,
        avatarImageName: String? = nil,
        avatarStyle: ChatMateAvatarStyle,
        requiresMutualFollow: Bool = false,
        isMutualFollowing: Bool = true
    ) {
        self.name = name
        self.date = date
        self.message = message
        self.avatarImageName = avatarImageName
        self.avatarStyle = avatarStyle
        self.requiresMutualFollow = requiresMutualFollow
        self.isMutualFollowing = isMutualFollowing
    }
}

enum ChatMateAvatarStyle: String, Codable {
    case person
    case ai
}
