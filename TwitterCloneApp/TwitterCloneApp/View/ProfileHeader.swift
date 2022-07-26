//
//  ProfileHeader.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/18/22.
//

import UIKit

final class ProfileHeader: UICollectionReusableView {
    static let identifier = "ProfileHeader"

    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        if let image = UIImage(named: "baseline_arrow_back_white_24dp") {
            button.setImage(image.withRenderingMode(.alwaysOriginal),
                            for: .normal)
        }
        button.addTarget(self,
                         action: #selector(handleDismissal),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.layer.cornerRadius = 36 / 2
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self,
                         action: #selector(handleEditProfileFollow),
                         for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.cornerRadius = 80 / 2
        return profileImageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Namik Namazov"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "@yungnvm"
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more then one line for test purposes"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(containerView)
        containerView.addSubview(backButton)
        addSubview(profileImageView)
        addSubview(editProfileFollowButton)
    
        containerView.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             height: 108)
        
        backButton.anchor(top: containerView.topAnchor,
                          left: containerView.leftAnchor,
                          paddingTop: 42,
                          paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        
        profileImageView.anchor(top: containerView.bottomAnchor,
                                left: leftAnchor,
                                paddingTop: -24,
                                paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        
        editProfileFollowButton.anchor(top: containerView.bottomAnchor,
                                       right: rightAnchor,
                                       paddingTop: 12,
                                       paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        
        let userDetailsStack = UIStackView(arrangedSubviews: [fullNameLabel,
                                                              usernameLabel,
                                                              bioLabel])
        addSubview(userDetailsStack)
        userDetailsStack.anchor(top: profileImageView.bottomAnchor,
                                left: leftAnchor,
                                right: rightAnchor,
                                paddingTop: 8,
                                paddingLeft: 12,
                                paddingRight: 12)
        userDetailsStack.axis = .vertical
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.spacing = 4
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         height: 50)
    }
    
    @objc private func handleDismissal() {
        
    }
    
    @objc private func handleEditProfileFollow() {
        
    }
}
