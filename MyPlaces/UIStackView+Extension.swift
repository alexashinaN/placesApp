//
//  UIStackView+Extension.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

extension UIStackView {
	func addArrangedSubviews(_ views: UIView...) {
		views.forEach {
			addArrangedSubview($0)
		}
	}
	
	func removeArrangedSubviews() {
		arrangedSubviews.forEach {
			removeArrangedSubview($0)
		}
	}
}
