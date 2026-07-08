//
//  SharePostTableViewCell.swift
//  Lounit
//
//  Created by Codex on 2026/6/5.
//

import UIKit

struct SharePost {
    let id: String
    let author: String
    let avatarImageName: String
    let text: String
    let postImageName: String
    var likeCount: Int
    var isLiked: Bool = false
}

struct ShareAuthorProfile {
    let name: String
    let avatarImageName: String
}

enum SharePostActionStore {
    private static let likedPostIDsKey = "lounit.share.likedPostIDs"
    private static let reportedPostIDsKey = "lounit.share.reportedPostIDs"
    private static let reportedAuthorNamesKey = "lounit.share.reportedAuthorNames"
    private static let blockedAuthorNamesKey = "lounit.share.blockedAuthorNames"
    private static let followedAuthorNamesKey = "lounit.userCenter.followedAuthorNames"
    private static let fanAuthorNamesKey = "lounit.userCenter.fanAuthorNames"
    private static let reportedCommentIDsKeyPrefix = "lounit.share.reportedCommentIDs."
    private static let moderationResetKey = "lounit.share.didResetModerationData.20260609"
    private static let fourPostFeedResetKey = "lounit.share.didResetFourPostFeedAuthors.20260609"

    static let defaultPosts: [SharePost] = [
        SharePost(
            id: "dynamic-post-old-new-city",
            author: "Esme",
            avatarImageName: "UserAvatar01",
            text: "A fresh perspective on the familiar city: the clash between old alleys and new buildings.",
            postImageName: "DynamicPostImage02",
            likeCount: 123
        ),
        SharePost(
            id: "dynamic-post-city-fun",
            author: "Kai",
            avatarImageName: "UserAvatar06",
            text: "Wander through the city and find your own fun.",
            postImageName: "DynamicPostImage04",
            likeCount: 123
        ),
        SharePost(
            id: "dynamic-post-urban-fabric",
            author: "Noah",
            avatarImageName: "UserAvatar03",
            text: "Wandering through the urban fabric, the wind carries the smoke and fire.",
            postImageName: "DynamicPostImage03",
            likeCount: 123
        ),
        SharePost(
            id: "dynamic-post-four-seasons",
            author: "Ava",
            avatarImageName: "UserAvatar04",
            text: "Keep moving and explore the four seasons of a city.",
            postImageName: "DynamicPostImage01",
            likeCount: 123
        )
    ]

    private static let knownAuthorProfiles = [
        ShareAuthorProfile(name: "Esme", avatarImageName: "UserAvatar01"),
        ShareAuthorProfile(name: "Kai", avatarImageName: "UserAvatar06"),
        ShareAuthorProfile(name: "Noah", avatarImageName: "UserAvatar03"),
        ShareAuthorProfile(name: "Ava", avatarImageName: "UserAvatar04"),
        ShareAuthorProfile(name: "Mira", avatarImageName: "UserAvatar05"),
        ShareAuthorProfile(name: "Leo", avatarImageName: "UserAvatar07"),
        ShareAuthorProfile(name: "Nina", avatarImageName: "UserAvatar08"),
        ShareAuthorProfile(name: "Ivy", avatarImageName: "UserAvatar09")
    ]

    static var fanProfiles: [ShareAuthorProfile] {
        profiles(for: allFanAuthorNames)
    }

    static func resetModerationDataOnceIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: moderationResetKey) else { return }
        clearModerationData()
        UserDefaults.standard.set(true, forKey: moderationResetKey)
    }

    static func resetFourPostFeedDataOnceIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: fourPostFeedResetKey) else { return }
        clearModerationData()
        UserDefaults.standard.removeObject(forKey: likedPostIDsKey)
        UserDefaults.standard.set(true, forKey: fourPostFeedResetKey)
    }

    static func visiblePosts(from posts: [SharePost]) -> [SharePost] {
        posts
            .filter { !blockedAuthorNames.contains($0.author) }
            .map(applyingSavedLikeState)
    }

    static func applyingSavedLikeState(to post: SharePost) -> SharePost {
        var post = post
        if likedPostIDs.contains(post.id), !post.isLiked {
            post.isLiked = true
            post.likeCount += 1
        }
        return post
    }

    static func setLiked(_ liked: Bool, for postID: String) {
        var ids = likedPostIDs
        if liked {
            ids.insert(postID)
        } else {
            ids.remove(postID)
        }
        UserDefaults.standard.set(Array(ids), forKey: likedPostIDsKey)
    }

    static func isFollowing(author: String) -> Bool {
        followedAuthorNames.contains(author)
    }

    static func isFollowedBy(author: String) -> Bool {
        allFanAuthorNames.contains(author)
    }

    static func isMutualFollowing(author: String) -> Bool {
        isFollowing(author: author) && isFollowedBy(author: author)
    }

    static func setFollowing(_ isFollowing: Bool, for author: String) {
        var authorNames = followedAuthorNames
        if isFollowing {
            authorNames.insert(author)
        } else {
            authorNames.remove(author)
        }
        UserDefaults.standard.set(Array(authorNames), forKey: followedAuthorNamesKey)
    }

    static func setFan(_ isFan: Bool, for author: String) {
        var authorNames = fanAuthorNames
        if isFan {
            authorNames.insert(author)
        } else {
            authorNames.remove(author)
        }
        UserDefaults.standard.set(Array(authorNames), forKey: fanAuthorNamesKey)
    }

    static func report(postID: String) {
        var ids = reportedPostIDs
        ids.insert(postID)
        UserDefaults.standard.set(Array(ids), forKey: reportedPostIDsKey)
    }

    static func report(author: String) {
        var authorNames = reportedAuthorNames
        authorNames.insert(author)
        UserDefaults.standard.set(Array(authorNames), forKey: reportedAuthorNamesKey)
    }

    static func block(author: String) {
        var authorNames = blockedAuthorNames
        authorNames.insert(author)
        UserDefaults.standard.set(Array(authorNames), forKey: blockedAuthorNamesKey)
    }

    static func unblock(author: String) {
        var authorNames = blockedAuthorNames
        authorNames.remove(author)
        UserDefaults.standard.set(Array(authorNames), forKey: blockedAuthorNamesKey)
    }

    static var followedAuthorProfiles: [ShareAuthorProfile] {
        profiles(for: followedAuthorNames)
    }

    static var blockedAuthorProfiles: [ShareAuthorProfile] {
        profiles(for: blockedAuthorNames)
    }

    static func profilePost(for profile: ShareAuthorProfile) -> SharePost {
        if let post = defaultPosts.first(where: { $0.author == profile.name }) {
            return applyingSavedLikeState(to: post)
        }

        let identifier = profile.name
            .lowercased()
            .filter { $0.isLetter || $0.isNumber }

        return SharePost(
            id: "profile-post-\(identifier)",
            author: profile.name,
            avatarImageName: profile.avatarImageName,
            text: "Exploring city corners, bright moments, and stories worth sharing.",
            postImageName: "DynamicPostImage01",
            likeCount: 0
        )
    }

    static var likedPostCount: Int {
        likedPosts.count
    }

    static var likedPosts: [SharePost] {
        visiblePosts(from: defaultPosts)
            .filter { likedPostIDs.contains($0.id) }
    }

    static func clearModerationData() {
        UserDefaults.standard.removeObject(forKey: reportedPostIDsKey)
        UserDefaults.standard.removeObject(forKey: reportedAuthorNamesKey)
        UserDefaults.standard.removeObject(forKey: blockedAuthorNamesKey)

        UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.hasPrefix(reportedCommentIDsKeyPrefix) }
            .forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }

    private static var likedPostIDs: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: likedPostIDsKey) ?? [])
    }

    private static var followedAuthorNames: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: followedAuthorNamesKey) ?? [])
    }

    private static var fanAuthorNames: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: fanAuthorNamesKey) ?? [])
    }

    private static var defaultFanAuthorNames: Set<String> {
        AuthSession.currentMail == AuthSession.testMail ? ["Noah"] : []
    }

    private static var allFanAuthorNames: Set<String> {
        fanAuthorNames.union(defaultFanAuthorNames)
    }

    private static var reportedPostIDs: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: reportedPostIDsKey) ?? [])
    }

    private static var reportedAuthorNames: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: reportedAuthorNamesKey) ?? [])
    }

    private static var blockedAuthorNames: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: blockedAuthorNamesKey) ?? [])
    }

    private static func profiles(for authorNames: Set<String>) -> [ShareAuthorProfile] {
        let knownProfiles = knownAuthorProfiles.filter { authorNames.contains($0.name) }
        let knownNames = Set(knownProfiles.map(\.name))
        let customProfiles = authorNames
            .subtracting(knownNames)
            .sorted()
            .map { ShareAuthorProfile(name: $0, avatarImageName: "UserAvatar01") }
        return knownProfiles + customProfiles
    }
}

final class SharePostTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SharePostTableViewCell"
    var commentTapHandler: (() -> Void)?
    var avatarTapHandler: (() -> Void)?
    var likeTapHandler: (() -> Void)?
    var moreTapHandler: (() -> Void)?

    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let moreButton = UIButton(type: .custom)
    private let bodyLabel = UILabel()
    private let postImageView = UIImageView()
    private let likeButton = UIButton(type: .custom)
    private let likeCountLabel = UILabel()
    private let commentButton = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = 21
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        commentTapHandler = nil
        avatarTapHandler = nil
        likeTapHandler = nil
        moreTapHandler = nil
    }

    func configure(with post: SharePost) {
        avatarImageView.image = UIImage(named: post.avatarImageName)?.withRenderingMode(.alwaysOriginal)
        nameLabel.text = post.author
        bodyLabel.text = post.text
        postImageView.image = UIImage(named: post.postImageName)?.withRenderingMode(.alwaysOriginal)
        likeCountLabel.text = "\(post.likeCount)"
        likeCountLabel.textColor = post.isLiked
            ? UIColor(red: 0.94, green: 0.28, blue: 0.38, alpha: 1)
            : UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        likeButton.isSelected = post.isLiked
        likeButton.alpha = 1
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 21
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        )

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        moreButton.setImage(UIImage(named: "ShareMoreButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)

        bodyLabel.textColor = .black
        bodyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.translatesAutoresizingMaskIntoConstraints = false

        likeButton.setImage(UIImage(named: "ShareHeartOutlineIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: "ShareLikeIcon")?.withRenderingMode(.alwaysOriginal), for: .selected)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)

        likeCountLabel.textColor = UIColor(red: 0.58, green: 0.58, blue: 0.58, alpha: 1)
        likeCountLabel.font = .systemFont(ofSize: 17, weight: .regular)
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false

        commentButton.setImage(UIImage(named: "ShareCommentIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        commentButton.imageView?.contentMode = .scaleAspectFit
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
    }

    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(moreButton)
        cardView.addSubview(bodyLabel)
        cardView.addSubview(postImageView)
        cardView.addSubview(likeButton)
        cardView.addSubview(likeCountLabel)
        cardView.addSubview(commentButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 9),
            avatarImageView.widthAnchor.constraint(equalToConstant: 42),
            avatarImageView.heightAnchor.constraint(equalToConstant: 42),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 14),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -12),

            moreButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            moreButton.widthAnchor.constraint(equalToConstant: 32),
            moreButton.heightAnchor.constraint(equalTo: moreButton.widthAnchor),

            bodyLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 18),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 9),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -9),

            postImageView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 34),
            postImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            postImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: 0.52),

            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            likeButton.widthAnchor.constraint(equalToConstant: 36),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),

            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 6),
            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),

            commentButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 32),
            commentButton.heightAnchor.constraint(equalTo: commentButton.widthAnchor),
            commentButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18)
        ])
    }

    @objc private func didTapComment() {
        commentTapHandler?()
    }

    @objc private func didTapAvatar() {
        avatarTapHandler?()
    }

    @objc private func didTapLike() {
        likeTapHandler?()
    }

    @objc private func didTapMore() {
        moreTapHandler?()
    }
}
