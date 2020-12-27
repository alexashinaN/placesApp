//
//  CustomTableViewCell.swift
//  MyPlaces
//
//  Created by Violence on 16.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {
	
	var nameLabel = UILabel()
	var locationLabel = UILabel()
	var typeLabel = UILabel()
	var placeImageView = UIImageView()
	var cosmosView = CosmosView() 

	
	var places: PlaceModel? {
		didSet {
			nameLabel.text = places?.productName
			locationLabel.text = places?.locationName
			typeLabel.text = places?.typeName
			placeImageView.image = places?.image
			cosmosView.rating = places?.rating ?? 0.0
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure() {
		nameLabel.numberOfLines = 0
		nameLabel.textAlignment = .left
		nameLabel.lineBreakMode = .byWordWrapping
		nameLabel.textColor = .black
		nameLabel.font = .boldSystemFont(ofSize: 15)
		locationLabel.numberOfLines = 0
		locationLabel.textAlignment = .left
		locationLabel.lineBreakMode = .byWordWrapping
		locationLabel.textColor = .black
		locationLabel.font = .systemFont(ofSize: 10)
		typeLabel.numberOfLines = 0
		typeLabel.textAlignment = .left
		typeLabel.lineBreakMode = .byWordWrapping
		typeLabel.textColor = .black
		typeLabel.font = .systemFont(ofSize: 10)
		placeImageView.contentMode = .scaleToFill
		cosmosView.settings.updateOnTouch = false
	}
	
	func setupLayout() {
		contentView.addSubviews(nameLabel, locationLabel, typeLabel, placeImageView, cosmosView)
		
		NSLayoutConstraint.activate([
			placeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
			placeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			placeImageView.widthAnchor.constraint(equalToConstant: 65),
			placeImageView.heightAnchor.constraint(equalToConstant: 65),
			
			nameLabel.topAnchor.constraint(equalTo: placeImageView.topAnchor, constant: 5),
			nameLabel.leftAnchor.constraint(equalTo: placeImageView.rightAnchor, constant: 5),
			
			locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
			locationLabel.leftAnchor.constraint(equalTo: placeImageView.rightAnchor, constant: 5),
			
			typeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
			typeLabel.leftAnchor.constraint(equalTo: placeImageView.rightAnchor, constant: 5),
			
			contentView.rightAnchor.constraint(equalTo: cosmosView.rightAnchor, constant: 10),
			cosmosView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
	
	override func layoutSubviews() {
		placeImageView.layer.cornerRadius = 65 / 2
		placeImageView.clipsToBounds = true
	}
}
