//
//  ActionSheetLauncher.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/12/22.
//

import UIKit

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelect(options: ActionSheetOptions)
}

final class ActionSheetLauncher: NSObject {
    weak var delegate: ActionSheetLauncherDelegate?
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private var tableViewHeight: CGFloat?
    private lazy var viewModel = ActionSheetViewModel(user: user)
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
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(
            equalToConstant: 50
        ).isActive = true
        cancelButton.anchor(
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingLeft: 12,
            paddingRight: 12
        )
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self,
                         action: #selector(handleDisissal),
                         for: .touchUpInside)
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(
            where: { $0.isKeyWindow }
        ) else {
            return
        }
        
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableView)
        
        let height = CGFloat(viewModel.options.count * 60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(
            x: 0,
            y: window.frame.height,
            width: window.frame.width,
            height: height
        )
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    private func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(
            ActionSheetCell.self,
            forCellReuseIdentifier: ActionSheetCell.identifier
        )
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
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ActionSheetCell.identifier,
            for: indexPath) as? ActionSheetCell else {
            return UITableViewCell()
        }
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        let option = viewModel.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: {_ in
            self.delegate?.didSelect(options: option)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}
