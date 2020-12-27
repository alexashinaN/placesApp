//
//  PlaceImageView.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

final class PlaceImageView: UIView {

	private let button = UIButton(type: .custom)
	let placeImage = UIImageView()
	var didTapHandler: (() -> Void)?
	var buttonDidTapHandler: (() -> Void)?
	
	init() {
		super.init(frame: .zero)
		configure()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: 250)
	}
}

private extension PlaceImageView {
	func setupLayout() {
		addSubviews(placeImage, button)
		
		NSLayoutConstraint.activate([
			placeImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
			bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 20),
			placeImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
			rightAnchor.constraint(equalTo: placeImage.rightAnchor, constant: 20),
			placeImage.heightAnchor.constraint(lessThanOrEqualToConstant: 210),
			
			button.heightAnchor.constraint(equalToConstant: 40),
			button.widthAnchor.constraint(equalToConstant: 40),
			rightAnchor.constraint(equalTo: button.rightAnchor, constant: 20),
			bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
		])
	}
	
	func configure() {
		placeImage.contentMode = .scaleAspectFit
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
		button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
		button.setImage(UIImage(named: "map1"), for: .normal)
	}
	
	@objc func didTap() {
		didTapHandler?()
	}
	@objc func buttonDidTap() {
		buttonDidTapHandler?()
	}
}
