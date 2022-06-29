//
//  ExploreViewController.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

final class ExploreController: UIViewController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }

    // MARK: - Helpers

    private func style() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
}
