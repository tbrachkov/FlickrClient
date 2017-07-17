//
//  AppCoordinator.swift
//  FlickrClient
//
//  Created by Todor Brachkov on 17/07/2017.
//  Copyright © 2017 Todor Brachkov. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
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
        children.append(feedCoordinator)
        feedCoordinator.start()
    }
    
    // MARK: - Additional Setup -
    func setupAfterLaunch() {
    }
}
