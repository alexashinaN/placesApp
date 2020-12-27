//
//  AddViewModel.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

final class AddViewModel {
	private let saveHandler: (PlaceModel) -> Void
	private let chooseImageService: ChooseImageService
	private var startModel: PlaceModel?
	private weak var router: AddPlacesRouter?
	
	var image: UIImage?
	var rating: Double
	let placeNameModel: InputFieldView.Model
	let placeLocationModel: InputFieldView.Model
	let placeTypeModel: InputFieldView.Model
	var imageDidChange: ((UIImage?) -> Void)?
	
	init(
		with model: PlaceModel?,
		router: AddPlacesRouter,
		chooseImageService: ChooseImageService,
		saveHandler: @escaping (PlaceModel) -> Void
	) {
		self.rating = model?.rating ?? 0.0
		self.router = router
		self.chooseImageService = chooseImageService
		self.saveHandler = saveHandler
		self.startModel = model
		self.placeNameModel = .init(title: "Name", inputText: model?.productName)
		self.placeLocationModel = .init(title: "Location", inputText: model?.locationName)
		self.placeTypeModel = .init(title: "Type", inputText: model?.typeName)
		self.image = model?.image ?? UIImage(named: "map")
		self.chooseImageService.chooseImageHandler = { [weak self] in
			self?.image = $0
			self?.imageDidChange?(self?.image)
		}
	}
		
	var placeModel: PlaceModel {
		return PlaceModel(
			productName: placeNameModel.inputText ?? "",
			locationName: placeLocationModel.inputText,
			typeName: placeTypeModel.inputText,
			image: image,
			rating: rating
		)
	}
}

extension AddViewModel {
	func saveDidTap() {
		saveHandler(placeModel)
		router?.pop()
	}
	
	func didChooseImageTapped() {
		chooseImageService.choose()
	}
	
	func mapDidTap() {
		router?.openMap(with: placeModel, mode: .place)
	}
}
