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

struct EditProfileViewModel {
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != nil 
    }
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname: return user.fullName
        case .bio: return user.bio
        }
    }
    
    let option: EditProfileOptions
    private let user: User
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
