//
//  ProfileFilterCell.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/26/22.
//

import UIKit

final class ProfileFilterCell: UICollectionViewCell {
    var option: ProfileFilterOptions? {
        didSet { titleLabel.text = option?.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        backgroundColor = .white
    }
    
    private func setup() {
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
}
