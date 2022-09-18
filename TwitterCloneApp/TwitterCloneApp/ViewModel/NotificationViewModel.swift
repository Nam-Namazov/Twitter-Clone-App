//
//  NotificationViewModel.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/16/22.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    private var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,
                                  .minute,
                                  .hour,
                                  .day,
                                  .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(
            from: notification.timestamp,
            to: now) ?? "2m"
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow:
            return " started following you"
        case .like:
            return " liked your tweet"
        case .reply:
            return " replied to your tweet"
        case .retweet:
            return " retweeted your tweet"
        case .mention:
            return " mentioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestampString = timestampString else { return nil }
        let attributedtext = NSMutableAttributedString(
            string: user.username,
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        )
        attributedtext.append(NSAttributedString(
            string: notificationMessage,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        )
        attributedtext.append(NSAttributedString(
            string: " \(timestampString)",
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                         NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        )
        return attributedtext
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
