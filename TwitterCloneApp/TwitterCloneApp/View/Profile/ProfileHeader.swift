//
//  ProfileHeader.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/18/22.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOptions)
}

final class ProfileHeader: UICollectionReusableView {
    static let identifier = "ProfileHeader"
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?

    private let filterBar = ProfileFilterView()
    private lazy var containerView = UIView()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        if let image = UIImage(named: "baseline_arrow_back_white_24dp") {
            button.setImage(image.withRenderingMode(.alwaysOriginal),
                            for: .normal)
        }
        return button
    }()
    
    private lazy var editProfileFollowButton = Utilities().standardButton(
        title: "Loading",
        color: .twitterBlue,
        layerBorderColor: UIColor.twitterBlue.cgColor,
        layerCornerRadius: 36 / 2,
        layerBorderWidth: 1.25,
        font: UIFont.boldSystemFont(ofSize: 14)
    )

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
    
    private let fullNameLabel = Utilities().standardLabel(
        textColor: .black,
        numberOfLines: 1,
        font: UIFont.boldSystemFont(ofSize: 20)
    )
    
    private let usernameLabel = Utilities().standardLabel(
        textColor: .lightGray,
        numberOfLines: 1,
        font: UIFont.systemFont(ofSize: 16)
    )

    private let bioLabel = Utilities().standardLabel(
        textColor: .black,
        numberOfLines: 3,
        font: UIFont.systemFont(ofSize: 16)
    )
    
    private lazy var followingLabel = UILabel()
    private lazy var followersLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configureFilterBarDelegate()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFilterBarDelegate() {
        filterBar.delegate = self
    }
    
    private func setup() {
        containerView.backgroundColor = .twitterBlue
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
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel,
                                                         followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userDetailsStack.bottomAnchor,
                           left: leftAnchor,
                           paddingTop: 8,
                           paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         height: 50)
    }
    
    private func configure() {
        guard let user = user else {
            return
        }
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullNameLabel.text = user.fullName
        usernameLabel.text = viewModel.userNameText
    }
    
    private func addTargets() {
        editProfileFollowButton.addTarget(self,
                         action: #selector(handleEditProfileFollow),
                         for: .touchUpInside
        )
        
        backButton.addTarget(
            self,
            action: #selector(handleDismissal),
            for: .touchUpInside)
    }
    
    @objc private func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc private func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
}
// MARK: - ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView,
                    didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}
