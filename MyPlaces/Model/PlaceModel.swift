//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Violence on 16.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import RealmSwift

class PlaceDTO: Object {
	@objc dynamic var productName = ""
	@objc dynamic var locationName: String?
	@objc dynamic var typeName: String?
	@objc dynamic var imageData: Data?
	@objc dynamic var date = Date()
	@objc dynamic var rating = 0.0
}

struct PlaceModel {
	let productName: String
	let locationName: String?
	let typeName: String?
	let image: UIImage?
	let rating: Double
}

extension PlaceModel {
	var toDTO: PlaceDTO {
		let dto = PlaceDTO()
		dto.productName = productName
		dto.locationName = locationName
		dto.typeName = typeName
		dto.imageData = image?.pngData()
		dto.rating = rating
		return dto
	}
}

extension PlaceDTO {
	var toPlaceModel: PlaceModel {
		return PlaceModel(productName: productName, locationName: locationName, typeName: typeName, image: UIImage(data: imageData ?? Data()), rating: rating)
	}
}
