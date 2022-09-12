//
//  ActionSheetLauncher.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/12/22.
//

import UIKit

final class ActionSheetLauncher: NSObject {
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0,
                                       alpha: 0.5)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDisissal)
        )
        view.addGestureRecognizer(tap)
        return view
    }()
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    func show() {
        print("DEBUG: show action sheet for user \(user.username)")
        
        guard let window = UIApplication.shared.windows.first(where: {
            $0.isKeyWindow
        }) else {
            return
        }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableView)
        tableView.frame = CGRect(
            x: 0,
            y: window.frame.height,
            width: window.frame.width,
            height: 300
        )
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= 300
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .red
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc
    private func handleDisissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
}

// MARK: - UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
