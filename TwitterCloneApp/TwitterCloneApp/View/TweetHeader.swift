//
//  TweetHeader.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/4/22.
//

import UIKit

final class TweetHeader: UICollectionReusableView {
    static let identifier = "TweetHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
