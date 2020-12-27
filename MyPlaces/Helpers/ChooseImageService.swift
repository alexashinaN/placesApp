//
//  ChooseImageService.swift
//  MyPlaces
//
//  Created by Violence on 27.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

final class ChooseImageService: NSObject {
	private weak var viewController: UIViewController?
	var chooseImageHandler: ((UIImage?) -> Void)?
	
	init(viewController: UIViewController?) {
		self.viewController = viewController
		super.init()
	}
	
	func choose() {
		let cameraIcon = #imageLiteral(resourceName: "camera")
		let photoIcon = #imageLiteral(resourceName: "photo")
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let camera = UIAlertAction(title: "Camera", style: .default) { _ in
			self.chooseImagePicker(source: .camera)
		}
		camera.setValue(cameraIcon, forKey: "image")
		camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		
		let photo = UIAlertAction(title: "Photo", style: .default) { _ in
			self.chooseImagePicker(source: .photoLibrary)
		}
		photo.setValue(photoIcon, forKey: "image")
		photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		
		actionSheet.addAction(camera)
		actionSheet.addAction(photo)
		actionSheet.addAction(cancel)
		
		viewController?.present(actionSheet, animated: true)
	}
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ChooseImageService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func chooseImagePicker(source: UIImagePickerController.SourceType) {
		if UIImagePickerController.isSourceTypeAvailable(source) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			imagePicker.sourceType = source
			viewController?.present(imagePicker, animated: true)
		}
	}
	
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		let image = info[.editedImage] as? UIImage
		chooseImageHandler?(image)
		picker.dismiss(animated: true)
	}
}
