//
//  AppCoordinator.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator, FeedCoordinatorDelegate {
    
    let window: UIWindow
    var children: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
    }
    
    func start() {
        setupAfterLaunch()
        showMain()
        window.makeKeyAndVisible()
    }
    
    // MARK: - Flows -
    func showMain() {
        window.rootViewController = navigationController
        let feedCoordinator = FeedCoordinator(navigationController: navigationController)
        feedCoordinator.delegate = self
        children.append(feedCoordinator)
        feedCoordinator.start()
    }
    
    func showDetailsWithPhoto(_ photo: UIImage) {
        let photoDetailsCoordinator = PhotoDetailsCoordinator(navigationController: navigationController, photo: photo)
        children.append(photoDetailsCoordinator)
        photoDetailsCoordinator.start()
    }
    
    // MARK: - Additional Setup -
    func setupAfterLaunch() {
    }
    
    // MARK: - FeedCoordinatorDelegate -
    func didSelectPhoto(_ photo: UIImage) {
        self.showDetailsWithPhoto(photo)
    }
}
