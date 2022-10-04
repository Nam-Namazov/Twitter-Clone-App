//
//  MainTabBarController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit
import Firebase

final class MainTabBarController: UITabBarController {
    private var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController,
                  let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.layer.cornerRadius = 56 / 2
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        actionButtonSetUp()
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureVC()
            configureUI()
            fetchUser()
        }
    }
    
    // MARK: - Selectors

    private func actionButtonSetUp() {
        actionButton.addTarget(self,
                               action: #selector(actionButtonTapped),
                               for: .touchUpInside)
    }

    @objc private func actionButtonTapped() {
        guard let user = user else { return }

        let controller = UploadTweetController(
            user: user,
            config: .tweet
        )
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true)
    }

    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingBottom: 64,
                            paddingRight: 16,
                            width: 56,
                            height: 56)
    }
    
    private func configureVC() {
        let feedVC = createNavController(
            viewController: FeedController(
                collectionViewLayout: UICollectionViewFlowLayout()
            ),
            itemImage: "home_unselected"
        )
        
        let exploreVC = createNavController(
            viewController: SearchController(),
            itemImage: "search_unselected")
        
        let notificationVC = createNavController(
            viewController: NotificationController(),
            itemImage: "like_unselected")
        
        viewControllers = [feedVC,
                           exploreVC,
                           notificationVC]
    }

    private func createNavController(viewController: UIViewController,
                                     itemImage: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: itemImage)
        return navController
    }

    private func style() {
        view.backgroundColor = .twitterBlue
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
}
