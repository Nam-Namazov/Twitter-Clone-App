//
//  EditProfileCell.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/29/22.
//

import UIKit

final class EditProfileCell: UITableViewCell {
    static let identifier = "EditProfileCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleColor() {
        backgroundColor = .white
    }
}
