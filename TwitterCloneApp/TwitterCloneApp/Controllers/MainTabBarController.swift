//
//  MainTabBarController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit
import Firebase

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController,
                  let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user 
            
        }
    }
    
    let actionButton: UIButton = {
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
//        logUserOut()
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.shared.fetchUser { user in
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
    
    private func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    // MARK: - Selectors

    private func actionButtonSetUp() {
        actionButton.addTarget(self,
                         action: #selector(actionButtonTapped),
                         for: .touchUpInside)
    }

    @objc private func actionButtonTapped() {
        print("1")
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
        let feedVC = createNavController(viewController: FeedController(), itemImage: "home_unselected")

        let exploreVC = createNavController(viewController: ExploreController(), itemImage: "search_unselected")

        let notificationVC = createNavController(viewController: NotificationController(), itemImage: "like_unselected")

        let conversationVC = createNavController(viewController: ConversationController(), itemImage: "ic_mail_outline_white_2x-1")

        viewControllers = [feedVC, exploreVC, notificationVC, conversationVC]

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
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
}
