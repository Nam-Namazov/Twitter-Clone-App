//
//  User.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/3/22.
//

import Foundation

struct User {
    let fullName: String
    let email: String
    let username: String
    let profileImageUrl: String
    let uid: String

    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid

        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
