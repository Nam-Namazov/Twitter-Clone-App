//
//  NotificationViewController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

final class NotificationController: UITableViewController {
    // MARK: - Properties
    
    private var notifications = [Notification]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureTableView()
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
        return 10
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
