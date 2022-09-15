//
//  NotificationService.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/15/22.
//

import Firebase

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else {
            
        }
    }
}
