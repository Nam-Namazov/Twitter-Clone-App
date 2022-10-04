//
//  User.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/3/22.
//

import Foundation
import Firebase

struct User {
    let email: String
    let uid: String
    var fullName: String
    var username: String
    var profileImageUrl: URL?
    var isFollowed = false
    var stats: UserRelationStats?
    var bio: String?
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }

    init(uid: String,
         dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }

        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
