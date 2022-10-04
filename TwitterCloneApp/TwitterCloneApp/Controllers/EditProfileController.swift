//
//  EditProfileController.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/28/22.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController,
                    wantsToUpdate user: User)
    func handleLogout()
}

final class EditProfileController: UITableViewController {
    private let imagePicker = UIImagePickerController()
    private let footerView = EditProfileFooter()
    private var user: User
    private var userInfoChanged = false
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage 
        }
    }
    private lazy var headerView = EditProfileHeader(user: user)
    weak var delegate: EditProfileControllerDelegate?
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureImagePicker()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(handleCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(handleDone)
        )
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 180
        )
        headerView.delegate = self
        
        footerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 100
        )

        tableView.tableFooterView = footerView
        footerView.delegate = self
        
        tableView.register(
            EditProfileCell.self,
            forCellReuseIdentifier: EditProfileCell.identifier
        )
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @objc
    private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func handleDone() {
        view.endEditing(true)
        guard imageChanged || userInfoChanged else { return }
        updateUserData()
    }
    
    private func updateUserData() {
        if imageChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if userInfoChanged && !imageChanged {
            UserService.shared.saveUserData(user: user) { [weak self] error, reference in
                guard let self = self else { return }
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if userInfoChanged && imageChanged {
            UserService.shared.saveUserData(user: user) { error, reference in
                self.updateProfileImage()
            }
        }
    }
    
    private func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { [weak self] profileImageUrl in
            guard let self = self else { return }
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
}

// MARK: - UITableViewDataSource
extension EditProfileController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EditProfileCell.identifier,
            for: indexPath) as? EditProfileCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {
            return cell
        }
        
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EditProfileController {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {
            return 0
        }
        return option == .bio ? 100 : 48
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - EditProfileHeaderDelegate
extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileController: UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        dismiss(animated: true)
    }
}

// MARK: - EditProfileCellDelegate
extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullName = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}

// MARK: - EditProfileFooterDelegate
extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        let alert = UIAlertController(
            title: nil,
            message: "Are you sure to log out?",
            preferredStyle: .actionSheet
        )
        
        let logoutAction = UIAlertAction(title: "Log Out",
                                         style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
