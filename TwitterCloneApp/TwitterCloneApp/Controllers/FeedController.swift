//
//  FeedViewController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

final class FeedController: UIViewController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        style()
    }

    // MARK: - Helpers

    private func configureUI() {
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    private func style() {
        view.backgroundColor = .white
    }
}
