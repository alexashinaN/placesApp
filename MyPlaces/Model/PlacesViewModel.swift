//
//  PlacesViewModel.swift
//  MyPlaces
//
//  Created by Violence on 26.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import Foundation
import RealmSwift

final class PlacesViewModel: NSObject {
	
	// MARK: - Private property
	
	private let storageService: StorageManager
	private var ascendingSorting = true
	private var currentSort: SortType = .date
	private lazy var placesToShow = places
	private weak var router: PlacesRouter?
	
	private lazy var places: Results<PlaceDTO> = {
		return storageService.loadObjects()
	}()
	
	// MARK: - Public property
	
	var didUpdateSortHandler: ((UIImage?) -> Void)?
	
	weak var tableView: UITableView? {
		didSet {
			tableView?.register(CustomTableViewCell.self, forCellReuseIdentifier: String(describing: CustomTableViewCell.self))
			tableView?.delegate = self
			tableView?.dataSource = self
		}
	}
	
	// MARK: - Initializing
	
	init(storageService: StorageManager, router: PlacesRouter) {
		self.storageService = storageService
		self.router = router
		super.init()
		self.applySort(self.currentSort)
	}
	
	func applySort(_ sort: SortType) {
		currentSort = sort
		placesToShow = placesToShow.sorted(
			byKeyPath: sort == .date ? "date" : "productName",
			ascending: ascendingSorting
		)
		reloadTableView()
	}
	
	func toggleSorting() {
		ascendingSorting.toggle()
		applySort(currentSort)
		didUpdateSortHandler?(UIImage(named: ascendingSorting ? "AZ" : "ZA"))
	}
	
	func didAddTapped() {
		router?.openAddPlace(model: nil) { [weak self] in
			self?.storageService.saveObject($0.toDTO)
			self?.reloadTableView()
		}
	}
}

// MARK: - UITableViewDelegate

extension PlacesViewModel: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 85
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
			guard let self = self else { return }
			self.storageService.deleteObject(self.placesToShow[indexPath.row])
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
		let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
		return swipeActions
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let placeToEdit = placesToShow[indexPath.row]
		router?.openAddPlace(model: placeToEdit.toPlaceModel) { [weak self] in
			self?.storageService.updateObject(placeToEdit, from: $0.toDTO)
			self?.reloadTableView()
		}
	}
}

// MARK: - UITableViewDataSource

extension PlacesViewModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return placesToShow.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
		let model = placesToShow[indexPath.row].toPlaceModel
		cell.places = model
		return cell
	}
}

// MARK: - UISearchResultsUpdating

extension PlacesViewModel: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text, !text.isEmpty  else { return }
		placesToShow = places.filter("productName CONTAINS[c] %@ OR locationName CONTAINS[c] %@ OR typeName CONTAINS[c] %@", text, text, text)
		reloadTableView()
	}
}

// MARK: - Animate reload data tableView

private extension PlacesViewModel {
	func reloadTableView() {
		guard let tableView = tableView else { return }
		UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: tableView.reloadData)
	}
}

// MARK: - UISearchBarDelegate

extension PlacesViewModel: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		placesToShow = places
		applySort(currentSort)
	}
}
