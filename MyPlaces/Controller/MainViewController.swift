//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Violence on 15.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
	private let tableView = UITableView()
	private let sortSegment = UISegmentedControl(items: ["Date", "Name"])
	private let searchController = UISearchController(searchResultsController: nil)
	private let viewModel: PlacesViewModel
	
	init(viewModel: PlacesViewModel) {
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
		setupViewModel()
	}
}

// MARK: - Actions

private extension MainViewController {
	@objc func add(sender: UIBarButtonItem) {
		viewModel.didAddTapped()
	}
	
	@objc func sortSelection(sender: UISegmentedControl) {
		viewModel.applySort(.init(value: sender.selectedSegmentIndex))
	}
	
	@objc func reversedSorting(sender: Any?) {
		viewModel.toggleSorting()
	}
}

// MARK: - Configure

private extension MainViewController {
	func setupLayout() {
		view.addSubviews(tableView, sortSegment)
		NSLayoutConstraint.activate([
			sortSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			sortSegment.leftAnchor.constraint(equalTo: view.leftAnchor),
			sortSegment.rightAnchor.constraint(equalTo: view.rightAnchor),
			
			tableView.topAnchor.constraint(equalTo: sortSegment.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])
	}
	
	func configure() {
		view.backgroundColor = .white
		navigationItem.title = "My places"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "AZ"), style: .plain, target: self, action: #selector(reversedSorting))
		sortSegment.addTarget(self, action: #selector(sortSelection), for: .valueChanged)
		sortSegment.selectedSegmentIndex = 0
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	func setupViewModel() {
		viewModel.tableView = tableView
		searchController.searchResultsUpdater = viewModel
		searchController.searchBar.delegate = viewModel
		viewModel.didUpdateSortHandler = { [navigationItem] in
			navigationItem.leftBarButtonItem?.image = $0
		}
	}
}
