//
//  RegistrationController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit
import Firebase

final class RegistrationController: UIViewController {
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"),
                        for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image,
                                                  textField: emailTextField)
        return view
    }()

    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "lock")
        let view = Utilities().inputContainerView(withImage: image,
                                                  textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image,
                                                  textField: fullNameTextField)
        return view
    }()

    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "lock")
        let view = Utilities().inputContainerView(withImage: image,
                                                  textField: userNameTextField)
        return view
    }()

    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()

    private let fullNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full Name")
        return textField
    }()

    private let userNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        return textField
    }()

    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?",
                                                  " Log In")
        return button
    }()

    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureUI()
        targets()
    }

    private func targets() {
        alreadyHaveAccountButton.addTarget(
            self,
            action: #selector(handleShowLogin),
            for: .touchUpInside
        )
        
        plusPhotoButton.addTarget(
            self,
            action: #selector(handleAddProfilePhoto),
            for: .touchUpInside
        )
        
        registrationButton.addTarget(
            self,
            action: #selector(handleRegistration),
            for: .touchUpInside
        )
    }

    @objc
    private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }

    @objc
    private func handleRegistration() {
        guard let profileImage = profileImage else { 
            print("DEBUG: Please Select a profile image...")
            return
        }

        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullname = fullNameTextField.text,
              let username = userNameTextField.text?.lowercased() else { return }

        let credentials = AuthCredentials(email: email,
                                          password: password,
                                          fullname: fullname,
                                          username: username,
                                          profileImage: profileImage)

        AuthService.shared.registerUser(credentials: credentials) { error, ref in
            let scenes = UIApplication.shared.connectedScenes

            guard let windowScene = scenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let tab = window.rootViewController as? MainTabBarController else {
            return
            }

            tab.authenticateUserAndConfigureUI()

            self.dismiss(animated: true, completion: nil)
        }
    }

    private func style() {
        view.backgroundColor = .twitterBlue
    }

    private func configureUI() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(
            inView: view,
            topAnchor: view.safeAreaLayoutGuide.topAnchor
        )
        plusPhotoButton.setDimensions(width: 128,
                                      height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView,
                                                   usernameContainerView,
                                                   registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(
            top: plusPhotoButton.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32
        )

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: 40,
            paddingRight: 40
        )
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage

        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        
        self.plusPhotoButton.setImage(
            profileImage.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        dismiss(animated: true, completion: nil)
    }
}
