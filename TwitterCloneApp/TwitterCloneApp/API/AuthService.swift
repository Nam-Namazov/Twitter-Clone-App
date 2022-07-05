//
//  AuthService.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/30/22.
//

import Foundation
import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String,
                   password: String,
                   completion: @escaping(Error?, AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            if let error = error {
                completion(error, nil)
                print("DEBUG: Error logging is \(error.localizedDescription)")
                return
            }
            completion(nil, result)
        }
    }

    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference?) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname

        guard let imageData = credentials.profileImage.jpegData(
            compressionQuality: 0.3) else { return }

        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)

        storageRef.putData(imageData,
                           metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }

                Auth.auth().createUser(withEmail: email,
                                       password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: error is \(error.localizedDescription)")
                        return
                    }

                    guard let uid = result?.user.uid else { return }

                    let values = ["email": email,
                                  "username": username,
                                  "fullname": fullname,
                                  "profileImageUrl": profileImageUrl]

                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
