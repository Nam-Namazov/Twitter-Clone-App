//
//  ProfileHeader.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/18/22.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        backgroundColor = .red
    }
    
}
