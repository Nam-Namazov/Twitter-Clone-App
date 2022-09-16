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
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
