//
//  MainTabBarController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        style()
    }

    // MARK: - Helpers

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
        view.backgroundColor = .white
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
    }
}
