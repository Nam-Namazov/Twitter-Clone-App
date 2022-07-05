//
//  UploadTweetController.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/5/22.
//

import UIKit

final class UploadTweetController: UIViewController {
    // MARK: - Properties
    private let user: User
    
    private lazy var uploadTweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()

    // MARK: - Lifecycle

    init (user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureUI()
        setupNavBar()
        tweetUploadButtonTapped()
    }

    // MARK: - API
    // MARK: - Helpers

    private func style() {
        view.backgroundColor = .white
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadTweetButton)
    }
    
    private func configureUI() {
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                left: view.leftAnchor,
                                paddingTop: 16,
                                paddingLeft: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    }

    // MARK: - Selectors

    private func tweetUploadButtonTapped() {
        uploadTweetButton.addTarget(self,
                                    action: #selector(handleUploadTweet),
                                    for: .touchUpInside)
    }

    @objc private func handleUploadTweet() {
        print("DEBUG: Upload tweet here..")
    }

    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

