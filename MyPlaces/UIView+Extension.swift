//
//  UIView+Extension.swift
//  MyPlaces
//
//  Created by Violence on 16.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

extension UIView {
	func addSubviews(_ views: UIView...) {
		views.forEach {
			addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
	}
}
