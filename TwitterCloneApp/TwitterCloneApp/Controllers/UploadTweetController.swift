//
//  UploadTweetController.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/5/22.
//

import UIKit

final class UploadTweetController: UIViewController {
    // MARK: - Properties

    private lazy var uploadTweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setupNavBar()
        tweetUploadButtonTapped()
    }

    // MARK: - API
    // MARK: - Helpers

    private func style() {
        view.backgroundColor = .white
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadTweetButton)
    }

    // MARK: - Selectors

    private func tweetUploadButtonTapped() {
        uploadTweetButton.addTarget(self,
                                    action: #selector(handleUploadTweet),
                                    for: .touchUpInside)
    }

    @objc private func handleUploadTweet() {
        print("DEBUG: Upload tweet here..")
    }

    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

