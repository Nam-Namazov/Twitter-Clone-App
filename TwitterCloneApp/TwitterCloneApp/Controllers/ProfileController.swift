//
//  ProfileController.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/18/22.
//

import Foundation
import UIKit

final class ProfileController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    private func style() {
        collectionView.backgroundColor = .red
    }
}
