//
//  UserProfileStore.swift
//  Lounit
//
//  Created by Codex on 2026/6/11.
//

import UIKit

struct UserProfile {
    let name: String
    let avatarImageName: String
}

enum UserProfileStore {
    private static let nameKeyPrefix = "lounit.profile.name."
    private static let avatarKeyPrefix = "lounit.profile.avatar."
    private static let localAvatarPrefix = "local-avatar:"
    private static let avatarDirectoryName = "ProfileAvatars"
    private static let testAccountProfile = UserProfile(name: "Luca", avatarImageName: "UserAvatar09")
    private static let guestProfile = UserProfile(name: "Traveler", avatarImageName: "UserAvatar02")

    static var currentProfile: UserProfile {
        profile(for: currentOwnerMail)
    }

    static func updateCurrentProfile(name: String? = nil, avatarImageName: String? = nil) {
        let currentProfile = currentProfile
        let trimmedName = name?.trimmingCharacters(in: .whitespacesAndNewlines)
        let nextName = trimmedName?.isEmpty == false ? trimmedName! : currentProfile.name
        let nextAvatar = avatarImageName?.isEmpty == false ? avatarImageName! : currentProfile.avatarImageName

        UserDefaults.standard.set(nextName, forKey: nameKey(for: currentOwnerMail))
        UserDefaults.standard.set(nextAvatar, forKey: avatarKey(for: currentOwnerMail))
    }

    static func saveCurrentAvatarImage(_ image: UIImage) throws -> String {
        try FileManager.default.createDirectory(
            at: avatarDirectoryURL,
            withIntermediateDirectories: true
        )

        let fileName = "\(UUID().uuidString).jpg"
        guard let imageData = image.jpegData(compressionQuality: 0.86) else {
            throw NSError(
                domain: "UserProfileStore",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to encode avatar image."]
            )
        }

        try imageData.write(to: avatarDirectoryURL.appendingPathComponent(fileName), options: .atomic)
        let identifier = localAvatarPrefix + fileName
        updateCurrentProfile(avatarImageName: identifier)
        return identifier
    }

    static func avatarImage(for identifier: String) -> UIImage? {
        if identifier.hasPrefix(localAvatarPrefix) {
            let fileName = String(identifier.dropFirst(localAvatarPrefix.count))
            return UIImage(contentsOfFile: avatarDirectoryURL.appendingPathComponent(fileName).path)
        }

        return UIImage(named: identifier)?.withRenderingMode(.alwaysOriginal)
    }

    private static func profile(for mail: String) -> UserProfile {
        let fallbackProfile = defaultProfile(for: mail)
        let storedName = UserDefaults.standard.string(forKey: nameKey(for: mail))
        let storedAvatar = UserDefaults.standard.string(forKey: avatarKey(for: mail))

        return UserProfile(
            name: storedName?.isEmpty == false ? storedName! : fallbackProfile.name,
            avatarImageName: storedAvatar?.isEmpty == false ? storedAvatar! : fallbackProfile.avatarImageName
        )
    }

    private static var currentOwnerMail: String {
        AuthSession.currentMail ?? "guest"
    }

    private static func defaultProfile(for mail: String) -> UserProfile {
        mail == AuthSession.testMail ? testAccountProfile : guestProfile
    }

    private static var avatarDirectoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(avatarDirectoryName, isDirectory: true)
    }

    private static func nameKey(for mail: String) -> String {
        nameKeyPrefix + mail
    }

    private static func avatarKey(for mail: String) -> String {
        avatarKeyPrefix + mail
    }
}
