//
//  UserService.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/3/22.
//

import Firebase

struct UserService {
    static let shared = UserService()

    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            print("DEBUG: Dictionary is \(dictionary)")
        }
    }
}
