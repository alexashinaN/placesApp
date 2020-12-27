//
//  RatingControlView.swift
//  MyPlaces
//
//  Created by Violence on 22.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

final class RatingControlView: UIView {
	
	//MARK: - Properties
	
	private let stackView = UIStackView()
	private var ratingButtons: [UIButton] = []
	
	private let starSize = CGSize(width: 44.0, height: 44.0)
	var didChangeRating: ((Double) -> Void)?

	var rating = 0.0 {
		didSet {
			updateButtonSelectionState()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		return CGSize(width: UIView.noIntrinsicMetric, height: 140)
	}

	//MARK: - Initialization
	
	init() {
		super.init(frame: .zero)
		setupButtons()
		configure()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Configure

private extension RatingControlView {
	func configure() {
		stackView.spacing = 8.0
		stackView.alignment = .fill
		stackView.distribution = .fill
	}
	
	func setupLayout() {
		addSubviews(stackView)
		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
			stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
		])
	}
}

// MARK: - Action

private extension RatingControlView {
	
	@objc func ratingButtonTapped(sender: UIButton) {
		guard let index = ratingButtons.firstIndex(of: sender) else { return }

		let selectedRating = Double(index) + 1.0
		
		if selectedRating == rating {
			rating = 0
		} else {
			rating = selectedRating
		}
		didChangeRating?(rating)
	}
}

// MARK: - Buttons work

private extension RatingControlView {
	func setupButtons() {

		stackView.removeArrangedSubviews()
		ratingButtons.removeAll()

		let filledStar = UIImage(named: "filledStar")
		let emptyStar = UIImage(named: "emptyStar")
		let highlightedStar = UIImage(named: "highlightedStar")
		
		for _ in 0..<5 {
			let button = UIButton()
			button.setImage(emptyStar, for: .normal)
			button.setImage(filledStar, for: .selected)
			button.setImage(highlightedStar, for: .highlighted)
			button.setImage(highlightedStar, for: [.highlighted, .selected])
			
			button.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				button.heightAnchor.constraint(equalToConstant: starSize.height),
				button.widthAnchor.constraint(equalToConstant: starSize.width),
			])
			
			button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
			
			stackView.addArrangedSubview(button)
			
			ratingButtons.append(button)
		}
		updateButtonSelectionState()
	}
	
	func updateButtonSelectionState() {
		for (index, button) in ratingButtons.enumerated() {
			button.isSelected = index < Int(rating)
		}
	}
}
