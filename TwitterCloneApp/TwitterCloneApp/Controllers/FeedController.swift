//
//  FeedViewController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit
import SDWebImage

final class FeedController: UICollectionViewController {
    // MARK: - Properties

    var user: User? {
        didSet { configureLeftBarButton() }
    }
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Lifecycle

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

    // MARK: - API

    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }

    // MARK: - Helpers

    private func configureUI() {
        let logoImageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = logoImageView
    }
    
    private func configureCollectionView() {
        collectionView.register(TweetCell.self,
                                forCellWithReuseIdentifier: TweetCell.identifier)
        collectionView.backgroundColor = .white
    }
    
    private func configureLeftBarButton() {
        guard let user = user else { return }

        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true 

        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }

    private func style() {
        view.backgroundColor = .white
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        cell.tweet = tweets[indexPath.row]
        
        return cell 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}
// MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
