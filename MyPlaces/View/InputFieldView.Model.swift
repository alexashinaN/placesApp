//
//  InputFieldView.Model.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

extension InputFieldView {
	final class Model {
		let title: String
		var inputText: String?
		
		init(title: String, inputText: String? = nil) {
			self.title = title
			self.inputText = inputText
		}
	}
}
