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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        style()
        fetchTweets()
    }

    // MARK: - API

    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            print("DEBUG: Tweets are \(tweets)")
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
// MARK: Extension
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        return cell 
    }
}
// MARK: Extension UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
