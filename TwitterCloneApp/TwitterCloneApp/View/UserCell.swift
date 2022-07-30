//
//  UserCell.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/30/22.
//

import UIKit

final class UserCell: UITableViewCell {
    static let identifier = "UserCell"
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 40, height: 40)
        imageView.layer.cornerRadius = 40 / 2
        imageView.backgroundColor = .twitterBlue
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,
                                 leftAnchor: leftAnchor,
                                 paddingLeft: 12)
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel,
                                                       fullnameLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        addSubview(stackView)
        stackView.centerY(inView: profileImageView,
                          leftAnchor: profileImageView.rightAnchor,
                          paddingLeft: 12)
    }
    
    private func configure() {
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullName
    }
}
