//
//  PlacesViewModel.SortType.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

extension PlacesViewModel {
	enum SortType: Int {
		case date = 0
		case name
		
		init(value: Int) {
			switch value {
			case 0: self = .date
			default: self = .name
			}
		}
	}
}
