//
//  NotificationViewController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

final class NotificationController: UITableViewController {
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureTableView()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }

    // MARK: - Helpers
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            NotificationCell.self,
            forCellReuseIdentifier: NotificationCell.identifier
        )
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }

    private func style() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}

// MARK: - UITableViewDataSource 
extension NotificationController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }
        
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(
                controller,
                animated: true
            )
        }
    }
}

// MARK: - NotificationCellDelegate
extension NotificationController: NotificationCellDelegate {
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
