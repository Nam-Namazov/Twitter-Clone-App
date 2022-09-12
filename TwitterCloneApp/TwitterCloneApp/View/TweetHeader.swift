//
//  TweetHeader.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/4/22.
//

import UIKit

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet()
}

final class TweetHeader: UICollectionReusableView {
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    static let identifier = "TweetHeader"
    static let shared = TweetHeader()
    
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.backgroundColor = .twitterBlue
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProfileImageTapped)
        )
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(
            UIImage(named: "down_arrow_24pt"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(showActionSheet),
            for: .touchUpInside
        )
        return button
    }()
    
    private let retweetsLabel = UILabel()
    private let likesLabel = UILabel()
    
    lazy var statsView: UIView = {
        let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(
            arrangedSubviews: [retweetsLabel, likesLabel]
        )
        stack.axis = .horizontal
        stack.spacing = 12
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor,
                     paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        paddingLeft: 8,
                        height: 1.0)
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(
            self,
            action: #selector(handleCommentTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(
            self,
            action: #selector(handleRetweetTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(
            self,
            action: #selector(handleLikeTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(
            self,
            action: #selector(handleShareTapped),
            for: .touchUpInside
        )
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel,
                                                        usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        let stack = UIStackView(arrangedSubviews: [profileImageView,
                                                   labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor,
                     left: leftAnchor,
                     paddingTop: 16,
                     paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 12,
                            paddingLeft: 16,
                            paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor,
                         left: leftAnchor,
                         paddingTop: 20,
                         paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor,
                             paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 12,
                         height: 40)
        
        let actionStack = UIStackView(
            arrangedSubviews: [commentButton,
                               retweetButton,
                               likeButton,
                               shareButton]
        )
        actionStack.spacing = 72
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(top: statsView.bottomAnchor,
                           paddingTop: 16)
    }
    
    @objc
    private func handleProfileImageTapped() {
        
    }
    
    @objc
    private func showActionSheet() {
        delegate?.showActionSheet()
    }
    
    @objc
    private func handleCommentTapped() {
        
    }
    
    @objc
    private func handleRetweetTapped() {
        
    }
    
    @objc
    private func handleLikeTapped() {
        
    }
    
    @objc
    private func handleShareTapped() {
        
    }
    
    private func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    private func configure() {
        guard let tweet = tweet else { return }
        
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullNameLabel.text = tweet.user.fullName
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString 
    }
}
