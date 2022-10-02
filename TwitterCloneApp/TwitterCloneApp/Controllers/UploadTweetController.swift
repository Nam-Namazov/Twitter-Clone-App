//
//  UploadTweetController.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/5/22.
//

import UIKit
import ActiveLabel

final class UploadTweetController: UIViewController {
    // MARK: - Properties

    private let user: User
    private let captionTextView = InputTextView()
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)

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
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        return label
    }()
    
    // MARK: - Lifecycle

    init (user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
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
        configureMention()
    }

    private func style() {
        view.backgroundColor = .white
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(handleCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: uploadTweetButton
        )
    }
    
    private func configureMention() {
        replyLabel.handleMentionTap { mention in
            print("mention is \(mention)")
        }
    }

    private func configureUI() {
        let imageCaptionStackView = UIStackView(
            arrangedSubviews: [profileImageView,
                               captionTextView]
        )
        
        imageCaptionStackView.axis = .horizontal
        imageCaptionStackView.spacing = 12
        imageCaptionStackView.alignment = .leading
        
        let stackView = UIStackView(
            arrangedSubviews: [replyLabel,
                               imageCaptionStackView]
        )
        stackView.axis = .vertical
        stackView.spacing = 12
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 16,
                         paddingLeft: 16,
                         paddingRight: 16)

        profileImageView.sd_setImage(with: user.profileImageUrl,
                                     completed: nil)
        uploadTweetButton.setTitle(viewModel.actionButtonTitle,
                                   for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }

    // MARK: - Selectors

    private func tweetUploadButtonTapped() {
        uploadTweetButton.addTarget(self,
                                    action: #selector(handleUploadTweet),
                                    for: .touchUpInside)
    }

    @objc private func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(
            caption: caption,
            type: config
        ) { error, ref in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(
                    type: .reply,
                    tweet: tweet
                )
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

