//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Violence on 21.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import RealmSwift

class StorageManager {
	private let queue = DispatchQueue(label: "com.realmswift.nadya.test")
	private var realm: Realm!
	
	static var shared: StorageManager {
		return StorageManager()
	}
	
	private init() {
		queue.sync { self.realm = try! Realm() }
	}
	
	func saveObject(_ place: PlaceDTO) {
		queue.sync {
			try! self.realm.write {
				self.realm.add(place)
			}
		}
	}
	
	func updateObject(_ place: PlaceDTO, from another: PlaceDTO) {
		queue.sync {
			try! self.realm.write {
				place.productName = another.productName
				place.locationName = another.locationName
				place.typeName = another.typeName
				place.imageData = another.imageData
				place.rating = another.rating
			}
		}
	}
	
	func loadObjects() -> Results<PlaceDTO> {
		queue.sync {
			return self.realm.objects(PlaceDTO.self)
		}
	}
	
	func deleteObject(_ place: PlaceDTO) {
		try! self.realm.write {
			self.realm.delete(place)
		}
	}
}
