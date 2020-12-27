//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Violence on 15.12.2020.
//  Copyright © 2020 Violence. All rights reserved.
//

import UIKit
import RealmSwift

protocol PlacesRouter: class {
	func openAddPlace(model: PlaceModel?, saveHandler: @escaping (PlaceModel) -> Void)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let schemaVersion: UInt64 = 2
		
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: schemaVersion ,

			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion < 1) {
					// Nothing to do!
					// Realm will automatically detect new properties and removed properties
					// And will update the schema on disk automatically
				}
			})

		// Tell Realm to use this new configuration object for the default Realm
		Realm.Configuration.defaultConfiguration = config
		
		window = UIWindow(frame: UIScreen.main.bounds)
		
		let mainVC = MainViewController(viewModel: PlacesViewModel(storageService: StorageManager.shared, router: self))
		
		let mainNavController = UINavigationController(rootViewController: mainVC)
		
		window?.rootViewController = mainNavController
		window?.makeKeyAndVisible()

		return true
	}
}

extension AppDelegate: PlacesRouter {
	func openAddPlace(model: PlaceModel?, saveHandler: @escaping (PlaceModel) -> Void) {
		let vc = AddViewController(
			viewModel: AddViewModel(
				with: model,
				router: self,
				chooseImageService: ChooseImageService(viewController: navigationController),
				saveHandler: saveHandler
			)
		)
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension AppDelegate {
	var navigationController: UINavigationController? {
		return window?.rootViewController as? UINavigationController
	}
}

protocol AddPlacesRouter: class {
	func pop()
	func openMap(with model: PlaceModel, mode: MapViewController.LocationMode)
}

extension AppDelegate: AddPlacesRouter {
	func pop() {
		navigationController?.popViewController(animated: true)
	}
	func openMap(with model: PlaceModel, mode: MapViewController.LocationMode) {
		let vc = MapViewController()
		vc.mode = mode
		vc.place = model
		navigationController?.present(vc, animated: true)
	}
}
