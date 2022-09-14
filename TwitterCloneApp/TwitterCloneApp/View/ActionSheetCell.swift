//
//  ActionSheetCell.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/13/22.
//

import UIKit

final class ActionSheetCell: UITableViewCell {
    static let identifier = "ActionSheetCell"
    
    var option: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "twitter_logo_blue")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        titleLabel.text = option?.description
    }
    
    private func layout() {
        contentView.addSubview(optionImageView)
        contentView.addSubview(titleLabel)
        
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor,
                          paddingLeft: 12)
        
    }
    
}