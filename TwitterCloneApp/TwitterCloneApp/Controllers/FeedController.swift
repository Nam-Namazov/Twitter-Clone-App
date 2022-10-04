//
//  FeedViewController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit
import SDWebImage

final class FeedController: UICollectionViewController {
    var user: User? {
        didSet { configureLeftBarButton() }
    }
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        style()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        
        TweetService.shared.fetchTweets { [weak self] tweets in
            guard let self = self else { return }
            
            self.tweets = tweets.sorted(by: {
                $0.timestamp > $1.timestamp
            })
            self.checkIfUserLikedTweets()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedTweets() {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet) { [weak self] didLike in
                guard let self = self else { return }
                guard didLike == true else { return }
                
                if let index = self.tweets.firstIndex(where: {
                    $0.tweetID == tweet.tweetID
                }) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    private func style() {
        view.backgroundColor = .white
    }

    private func configureUI() {
        let logoImageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = logoImageView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh),
            for: .valueChanged
        )
        collectionView.refreshControl = refreshControl
    }
    
    private func configureCollectionView() {
        collectionView.register(
            TweetCell.self,
            forCellWithReuseIdentifier: TweetCell.identifier
        )
        collectionView.backgroundColor = .white
    }
    
    private func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProfileImageTap)
        )
        profileImageView.addGestureRecognizer(tap)
        
        profileImageView.sd_setImage(with: user.profileImageUrl,
                                     completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: profileImageView
        )
    }

    @objc
    private func handleRefresh() {
        fetchTweets()
    }
    
    @objc
    private func handleProfileImageTap() {
        guard let user = user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller,
                                                 animated: true)
    }
}

// MARK: - UICollectionViewDataSource / UICollectionViewDelegate
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TweetCell.identifier,
            for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell 
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller,
                                                 animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

// MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleFetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller,
                                                          animated: true)
        }
    }
    
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { error, reference in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(
                toUser: tweet.user,
                type: .like,
                tweetID: tweet.tweetID
            )
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user,
                                               config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
