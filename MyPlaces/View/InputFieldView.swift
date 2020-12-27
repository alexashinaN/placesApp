//
//  InputFieldView.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

final class InputFieldView: UIView {

	private let titleLabel = UILabel()
	private let textField = UITextField()
	private var rightButton: UIButton?
	private var model: Model? {
		didSet {
			titleLabel.text = model?.title
			textField.text = model?.inputText
		}
	}
	
	init() {
		super.init(frame: .zero)
		self.configure()
		self.setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension InputFieldView {
	func configure() {
		titleLabel.font = .italicSystemFont(ofSize: 16)
		titleLabel.textColor = .black
		textField.font = .systemFont(ofSize: 18)
		textField.textColor = .black
		textField.borderStyle = .roundedRect
		textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
	}
	
	@objc func textFieldDidChange() {
		guard let text = textField.text else { return }
		model?.inputText = text
	}
	
	func setupLayout() {
		addSubviews(titleLabel, textField)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
			
			textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
			rightAnchor.constraint(equalTo: textField.rightAnchor, constant: 16),
			textField.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}

extension InputFieldView {
	func configure(with model: Model) {
		self.model = model
	}
}
