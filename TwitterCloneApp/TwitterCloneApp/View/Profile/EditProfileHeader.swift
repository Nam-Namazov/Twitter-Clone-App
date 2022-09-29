//
//  EditProfileHeader.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/29/22.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangeProfilePhoto()
}

final class EditProfileHeader: UIView {
    weak var delegate: EditProfileHeaderDelegate?
    
    private let user: User
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        imageView.layer.cornerRadius = 100 / 2
        return imageView
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        style()
        targets()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        backgroundColor = .twitterBlue
    }
    
    private func targets() {
        changePhotoButton.addTarget(
            self,
            action: #selector(handleChangeProfilePhoto),
            for: .touchUpInside
        )
    }
    
    @objc
    private func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    private func layout() {
        addSubview(profileImageView)
        addSubview(changePhotoButton)
        
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        
        changePhotoButton.centerX(
            inView: self,
            topAnchor: profileImageView.bottomAnchor,
            paddingTop: 8
        )
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
}
