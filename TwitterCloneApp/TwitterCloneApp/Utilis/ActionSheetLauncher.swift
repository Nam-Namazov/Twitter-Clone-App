//
//  ActionSheetLauncher.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/12/22.
//

import Foundation

final class ActionSheetLauncher: NSObject {
    private let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    func show() {
        print("DEBUG: show action sheet for user \(user.username)")
    }
}
