//
//  EditProfileCell.swift
//  TwitterCloneApp
//
//  Created by Намик on 9/29/22.
//

import UIKit

final class EditProfileCell: UITableViewCell {
    static let identifier = "EditProfileCell"
    
    var viewModel: EditProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        return textField
    }()
    
    private let bioTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .twitterBlue
        textView.placeholderLabel.text = "Bio"
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        styleColor()
        targets()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleColor() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func targets() {
        infoTextField.addTarget(
            self,
            action: #selector(handleUpdateUserInfo),
            for: .editingDidEnd
        )
    }
    
    @objc
    private func handleUpdateUserInfo() {
        
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        titleLabel.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 12,
            paddingLeft: 16
        )
        
        contentView.addSubview(infoTextField)
        infoTextField.anchor(
            top: topAnchor,
            left: titleLabel.rightAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 4,
            paddingLeft: 16,
            paddingRight: 8
        )
        
        contentView.addSubview(bioTextView)
        bioTextView.anchor(
            top: topAnchor,
            left: titleLabel.rightAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 4,
            paddingLeft: 16,
            paddingRight: 8
        )
    }
}
