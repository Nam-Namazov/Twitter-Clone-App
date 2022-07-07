//
//  TweetCell.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/7/22.
//

import UIKit

class TweetCell: UICollectionViewCell {
    static let identifier = "cellid"

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
