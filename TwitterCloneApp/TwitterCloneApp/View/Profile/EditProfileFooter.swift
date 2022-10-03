//
//  EditProfileFooter.swift
//  TwitterCloneApp
//
//  Created by Намик on 10/3/22.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func handleLogout()
}

final class EditProfileFooter: UIView {
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(
            self,
            action: #selector(handleLogout),
            for: .touchUpInside
        )
        button.layer.cornerRadius = 5
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    weak var delegate: EditProfileFooterDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(logoutButton)
        logoutButton.anchor(
            left: leftAnchor,
            right: rightAnchor,
            paddingLeft: 16,
            paddingRight: 16
        )
        logoutButton.heightAnchor.constraint(
            equalToConstant: 50
        ).isActive = true
        logoutButton.centerY(inView: self)
    }
    
    @objc
    private func handleLogout() {
        delegate?.handleLogout()
    }
}
