//
//  TweetController.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/4/22.
//

import UIKit

final class TweetController: UICollectionViewController {
    
    private let tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(
            TweetCell.self,
            forCellWithReuseIdentifier: TweetCell.identifier
        )
        collectionView.register(
            TweetHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TweetHeader.identifier
        )
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }

}

// MARK: - UICollectionViewDataSource
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TweetCell.identifier,
            for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        cell.tweet = replies[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.identifier, for: indexPath) as? TweetHeader else {
            return UICollectionReusableView()
        }
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 265)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { [weak self] isFollowed in
                guard let self = self else { return }
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

// MARK: - ActionSheetLauncherDelegate
extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(options: ActionSheetOptions) {
        switch options {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, reference in
                print("DEBUG: did follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, reference in
                print("DEBUG: did unfollow user \(user.username)")
            }
        case .report:
            print("DEBUG: Report tweet")
        case .delete:
            print("DEBUG: Delete tweet")
        }
    }
}
