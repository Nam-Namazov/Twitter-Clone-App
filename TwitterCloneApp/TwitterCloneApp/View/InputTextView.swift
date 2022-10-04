//
//  CaptionTextView.swift
//  TwitterCloneApp
//
//  Created by Намик on 7/6/22.
//

import Foundation
import UIKit

final class InputTextView: UITextView {
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layout()
        configure()
        observer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
    }
    
    private func observer() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }

    @objc private func handleTextChange() {
        text.isEmpty ? (placeholderLabel.isHidden = false) : (placeholderLabel.isHidden = true)
    }
    
    private func layout() {
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 4)
    }
}
