//
//  LoginController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

final class LoginController: UIViewController {
    // MARK: - Properties

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "TwitterLogo")
        return imageView
    }()

    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()

    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign Up")
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        configureUI()
        loginButtonAction()
        dontHaveAccountButtonAction()
    }

    // MARK: - Selectors

    private func loginButtonAction() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    private func dontHaveAccountButtonAction() {
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }

    @objc private func handleLogin() {
        print("login tapped")
    }
    
    @objc private func handleShowSignUp() {
        print("sign up tapped")
    }

    // MARK: - Helpers

    private func style() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

    private func configureUI() {
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingLeft: 40,
                                     paddingRight: 40)
    }
}
