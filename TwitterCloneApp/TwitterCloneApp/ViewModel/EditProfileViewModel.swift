//
//  EditProfileViewModel.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/29/22.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname, username, bio
    
    var description: String {
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .bio: return "Bio"
        }
    }
}
