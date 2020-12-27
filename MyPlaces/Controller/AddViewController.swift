//
//  AddViewController.swift
//  MyPlaces
//
//  Created by Violence on 16.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

	private let stackView = UIStackView()
	private let viewModel: AddViewModel
	let getAddressButton = UIButton()

	init(viewModel: AddViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configure()
		setupLayout()
		configureView()
    }
}

extension AddViewController: MapViewControllerDelegate {
	func getNewAddress(_ address: String?) {
		//locationTextField?.text = address 
	}
}

// MARK: - Configure

private extension AddViewController {
	func configure() {
		view.backgroundColor = .white
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
		getAddressButton.setImage(UIImage(named: "Placeholder"), for: .normal)
		getAddressButton.addTarget(self, action: #selector(getAddress), for: .touchUpInside)
		stackView.axis = .vertical
		view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
	}
	
	func configureView() {
		let placeImageView = PlaceImageView()
		let placeNameView = InputFieldView()
		let placeLocationView = InputFieldView()
		let placeTypeView = InputFieldView()
		let placeRatingView = RatingControlView()
		
		placeNameView.configure(with: viewModel.placeNameModel)
		placeLocationView.configure(with: viewModel.placeLocationModel)
		placeTypeView.configure(with: viewModel.placeTypeModel)
		placeRatingView.rating = viewModel.rating
		placeImageView.placeImage.image = viewModel.image
		
		placeRatingView.didChangeRating = { [viewModel] in
			viewModel.rating = $0
		}
		viewModel.imageDidChange = {
			placeImageView.placeImage.image = $0
		}
		placeImageView.buttonDidTapHandler = viewModel.mapDidTap
		placeImageView.didTapHandler = viewModel.didChooseImageTapped
		stackView.addArrangedSubviews(placeImageView, placeNameView, placeLocationView, placeTypeView, placeRatingView)
	}
	
	func setupLayout() {
		view.addSubviews(stackView)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
			stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
}

// MARK: - Actions

private extension AddViewController {
	@objc func cancel(sender: UIBarButtonItem) {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func save(sender: UIBarButtonItem) {
		viewModel.saveDidTap()
	}
	
	@objc func getAddress(sender: UIButton) {
		let mapVC = MapViewController()
		mapVC.mode = .current
		mapVC.mapViewControllerDelegate = self
		navigationController?.present(mapVC, animated: true) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				print("fire")
				mapVC.showUserLocation()
			}
		}
	}
}

