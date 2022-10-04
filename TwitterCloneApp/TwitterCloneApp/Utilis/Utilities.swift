//
//  Utilities.swift
//  TwitterCloneApp
//
//  Created by Намик on 6/29/22.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage,
                            textField: UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = image
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         paddingLeft: 8,
                         paddingBottom: 8)
        imageView.setDimensions(width: 24, height: 24)

        view.addSubview(textField)
        textField.anchor(left: imageView.rightAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8,
                         paddingBottom: 8)

        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor,
                           paddingLeft: 8,
                           height: 0.75)

        return view 
    }

    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textColor = .white
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }

    func attributedButton(_ firstPart: String,
                          _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])

        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }
    
    func standardButton(title: String,
                        color: UIColor,
                        layerBorderColor: CGColor?,
                        layerCornerRadius: CGFloat,
                        layerBorderWidth: CGFloat,
                        font: UIFont) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.layer.borderColor = layerBorderColor
        button.layer.cornerRadius = layerCornerRadius
        button.layer.borderWidth = layerBorderWidth
        button.titleLabel?.font = font
        return button
    }
    
    func standardLabel(textColor: UIColor?,
                       numberOfLines: Int,
                       font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.font = font
        return label
    }
}
