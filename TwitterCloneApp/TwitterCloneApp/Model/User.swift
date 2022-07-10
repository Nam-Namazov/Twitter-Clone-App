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
    var profileImageUrl: URL?
    let uid: String

    init(uid: String,
         dictionary: [String: AnyObject]) {
        self.uid = uid

        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""

        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}
